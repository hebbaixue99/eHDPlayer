package org.osmf.net
{
   import flash.errors.IllegalOperationError;
   import flash.events.NetStatusEvent;
   import flash.events.TimerEvent;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.net.NetStreamPlayOptions;
   import flash.net.NetStreamPlayTransitions;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import org.osmf.logging.Log;
   import org.osmf.player.debug.StrobeLogger;
   import org.osmf.utils.OSMFStrings;
   
   public class StrobeNetStreamSwitchManager extends NetStreamSwitchManagerBase
   {
      
      private static const RULE_CHECK_INTERVAL:Number = 2500;
      
      private static const DEFAULT_MAX_UP_SWITCHES_PER_STREAM_ITEM:int = 3;
      
      private static const DEFAULT_WAIT_DURATION_AFTER_DOWN_SWITCH:int = 30000;
      
      private static const DEFAULT_CLEAR_FAILED_COUNTS_INTERVAL:Number = 300000;
       
      
      private var netStream:NetStream;
      
      private var dsResource:DynamicStreamingResource;
      
      private var switchingRules:Vector.<SwitchingRuleBase>;
      
      private var metrics:NetStreamMetricsBase;
      
      private var checkRulesTimer:Timer;
      
      private var clearFailedCountsTimer:Timer;
      
      private var actualIndex:int = -1;
      
      private var oldStreamName:String;
      
      private var switching:Boolean;
      
      private var switchingTimestamp:int;
      
      private var _currentIndex:int;
      
      private var lastTransitionIndex:int = -1;
      
      private var connection:NetConnection;
      
      private var dsiFailedCounts:Vector.<int>;
      
      private var failedDSI:Dictionary;
      
      private var _bandwidthLimit:Number = 0;
      
      protected var logger:StrobeLogger;
      
      public function StrobeNetStreamSwitchManager(param1:NetConnection, param2:NetStream, param3:DynamicStreamingResource, param4:NetStreamMetricsBase, param5:Vector.<SwitchingRuleBase>)
      {
         this.logger = Log.getLogger("StrobeMediaPlayback") as StrobeLogger;
         super();
         this.connection = param1;
         this.netStream = param2;
         this.dsResource = param3;
         this.metrics = param4;
         this.switchingRules = param5 || new Vector.<SwitchingRuleBase>();
         this._currentIndex = Math.max(0,Math.min(this.maxAllowedIndex,this.dsResource.initialIndex));
         this.checkRulesTimer = new Timer(RULE_CHECK_INTERVAL);
         this.checkRulesTimer.addEventListener(TimerEvent.TIMER,this.checkRules);
         this.failedDSI = new Dictionary();
         this._bandwidthLimit = 1.4 * param3.streamItems[param3.streamItems.length - 1].bitrate * 1000 / 8;
         param2.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
         NetClient(param2.client).addHandler(NetStreamCodes.ON_PLAY_STATUS,this.onPlayStatus,int.MAX_VALUE);
      }
      
      override public function set autoSwitch(param1:Boolean) : void
      {
         super.autoSwitch = param1;
         this.debug("autoSwitch() - setting to " + param1);
         if(autoSwitch)
         {
            this.debug("autoSwitch() - starting check rules timer.");
            this.checkRulesTimer.start();
         }
         else
         {
            this.debug("autoSwitch() - stopping check rules timer.");
            this.checkRulesTimer.stop();
         }
      }
      
      override public function get currentIndex() : uint
      {
         return this._currentIndex;
      }
      
      override public function get maxAllowedIndex() : int
      {
         var _loc1_:int = this.dsResource.streamItems.length - 1;
         return _loc1_ < super.maxAllowedIndex?int(_loc1_):int(super.maxAllowedIndex);
      }
      
      override public function set maxAllowedIndex(param1:int) : void
      {
         if(param1 > this.dsResource.streamItems.length)
         {
            throw new RangeError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_INVALID_INDEX));
         }
         super.maxAllowedIndex = param1;
         this.metrics.maxAllowedIndex = param1;
      }
      
      override public function switchTo(param1:int) : void
      {
         if(!autoSwitch)
         {
            if(param1 < 0 || param1 > this.maxAllowedIndex)
            {
               throw new RangeError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_INVALID_INDEX));
            }
            this.debug("switchTo() - manually switching to index: " + param1);
            if(this.metrics.resource == null)
            {
               this.prepareForSwitching();
            }
            this.executeSwitch(param1);
            return;
         }
         throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_STREAM_NOT_IN_MANUAL_MODE));
      }
      
      protected function canAutoSwitchNow(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         if(this.dsiFailedCounts[param1] >= 1)
         {
            _loc2_ = getTimer();
            if(_loc2_ - this.failedDSI[param1] < DEFAULT_WAIT_DURATION_AFTER_DOWN_SWITCH)
            {
               this.debug("canAutoSwitchNow() - ignoring switch request because index " + param1 + " has " + this.dsiFailedCounts[param1] + " failure(s) and only " + (_loc2_ - this.failedDSI[param1]) / 1000 + " seconds have passed since the last failure.");
               return false;
            }
         }
         else if(this.dsiFailedCounts[param1] > DEFAULT_MAX_UP_SWITCHES_PER_STREAM_ITEM)
         {
            return false;
         }
         return true;
      }
      
      protected final function get bandwidthLimit() : Number
      {
         return this._bandwidthLimit;
      }
      
      protected final function set bandwidthLimit(param1:Number) : void
      {
         this._bandwidthLimit = param1;
      }
      
      private function executeSwitch(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:NetStreamPlayOptions = new NetStreamPlayOptions();
         var _loc4_:Object = NetStreamUtils.getPlayArgsForResource(this.dsResource);
         _loc3_.start = _loc4_.start;
         _loc3_.len = _loc4_.len;
         _loc3_.streamName = this.dsResource.streamItems[param1].streamName;
         _loc3_.oldStreamName = this.oldStreamName;
         if(param2)
         {
            _loc3_.transition = NetStreamPlayTransitions.RESET;
         }
         else
         {
            _loc3_.transition = NetStreamPlayTransitions.SWITCH;
         }
         this.debug("executeSwitch() - Switching to index " + param1 + " at " + Math.round(this.dsResource.streamItems[param1].bitrate) + " kbps");
         this.logger.qos.ds.targetIndex = param1;
         this.logger.qos.ds.targetBitrate = Math.round(this.dsResource.streamItems[param1].bitrate);
         this.switching = true;
         this.switchingTimestamp = getTimer();
         this.netStream.play2(_loc3_);
         this.oldStreamName = this.dsResource.streamItems[param1].streamName;
         if(param1 < this.actualIndex && autoSwitch)
         {
            this.incrementDSIFailedCount(this.actualIndex);
            this.failedDSI[this.actualIndex] = getTimer();
         }
      }
      
      private function checkRules(param1:TimerEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.switchingRules == null || this.switching)
         {
            _loc5_ = getTimer() - this.switchingTimestamp;
            if(this.switching && _loc5_ > 5000)
            {
               this.logger.warn("Switch not complete after {0} sec.",_loc5_ / 1000);
            }
            return;
         }
         var _loc2_:Number = this.netStream.bufferLength / this.netStream.bufferTime;
         var _loc3_:int = int.MAX_VALUE;
         var _loc4_:int = 0;
         while(_loc4_ < this.switchingRules.length)
         {
            _loc6_ = this.switchingRules[_loc4_].getNewIndex();
            if(_loc6_ != -1 && _loc6_ < _loc3_)
            {
               _loc3_ = _loc6_;
            }
            _loc4_++;
         }
         if(_loc3_ != -1 && _loc3_ != int.MAX_VALUE && _loc3_ != this.actualIndex)
         {
            _loc3_ = Math.min(_loc3_,this.maxAllowedIndex);
         }
         if(_loc3_ != -1 && _loc3_ != int.MAX_VALUE && _loc3_ != this.actualIndex && !this.switching && _loc3_ <= this.maxAllowedIndex && this.canAutoSwitchNow(_loc3_) && (this.netStream.bufferTime == 0 || _loc3_ < this.actualIndex && _loc2_ < 1 || _loc3_ > this.actualIndex && _loc2_ > 1))
         {
            this.debug("checkRules() - Calling for switch to " + _loc3_ + " at " + this.dsResource.streamItems[_loc3_].bitrate + " kbps");
            this.executeSwitch(_loc3_);
         }
      }
      
      private function onNetStatus(param1:NetStatusEvent) : void
      {
         this.debug("onNetStatus() - event.info.code=" + param1.info.code);
         switch(param1.info.code)
         {
            case NetStreamCodes.NETSTREAM_PLAY_START:
               if(this.metrics.resource == null)
               {
                  this.prepareForSwitching();
               }
               else if(autoSwitch && this.checkRulesTimer.running == false)
               {
                  this.checkRulesTimer.start();
               }
               break;
            case NetStreamCodes.NETSTREAM_PLAY_TRANSITION:
               this.switching = false;
               this.actualIndex = this.dsResource.indexFromName(param1.info.details);
               this.metrics.currentIndex = this.actualIndex;
               this.lastTransitionIndex = this.actualIndex;
               break;
            case NetStreamCodes.NETSTREAM_PLAY_FAILED:
               this.switching = false;
               break;
            case NetStreamCodes.NETSTREAM_SEEK_NOTIFY:
               this.switching = false;
               if(this.lastTransitionIndex >= 0)
               {
                  this._currentIndex = this.lastTransitionIndex;
               }
               break;
            case NetStreamCodes.NETSTREAM_PLAY_STOP:
               this.checkRulesTimer.stop();
               this.debug("onNetStatus() - Stopping rules since server has stopped sending data");
         }
      }
      
      private function onPlayStatus(param1:Object) : void
      {
         this.debug("onPlayStatus() - info.code=" + param1.code);
         switch(param1.code)
         {
            case NetStreamCodes.NETSTREAM_PLAY_TRANSITION_COMPLETE:
               if(this.lastTransitionIndex >= 0)
               {
                  this._currentIndex = this.lastTransitionIndex;
                  this.lastTransitionIndex = -1;
               }
               this.debug("onPlayStatus() - Transition complete to index: " + this.currentIndex + " at " + Math.round(this.dsResource.streamItems[this.currentIndex].bitrate) + " kbps");
         }
      }
      
      private function prepareForSwitching() : void
      {
         this.initDSIFailedCounts();
         this.metrics.resource = this.dsResource;
         this.actualIndex = 0;
         this.lastTransitionIndex = -1;
         if(this.dsResource.initialIndex >= 0 && this.dsResource.initialIndex < this.dsResource.streamItems.length)
         {
            this.actualIndex = this.dsResource.initialIndex;
         }
         if(autoSwitch)
         {
            this.checkRulesTimer.start();
         }
         this.setThrottleLimits(this.dsResource.streamItems.length - 1);
         this.debug("prepareForSwitching() - Starting with stream index " + this.actualIndex + " at " + Math.round(this.dsResource.streamItems[this.actualIndex].bitrate) + " kbps");
         this.metrics.currentIndex = this.actualIndex;
      }
      
      private function initDSIFailedCounts() : void
      {
         if(this.dsiFailedCounts != null)
         {
            this.dsiFailedCounts.length = 0;
            this.dsiFailedCounts = null;
         }
         this.dsiFailedCounts = new Vector.<int>();
         var _loc1_:int = 0;
         while(_loc1_ < this.dsResource.streamItems.length)
         {
            this.dsiFailedCounts.push(0);
            _loc1_++;
         }
      }
      
      private function incrementDSIFailedCount(param1:int) : void
      {
         this.dsiFailedCounts[param1]++;
         if(this.dsiFailedCounts[param1] > DEFAULT_MAX_UP_SWITCHES_PER_STREAM_ITEM)
         {
            if(this.clearFailedCountsTimer == null)
            {
               this.clearFailedCountsTimer = new Timer(DEFAULT_CLEAR_FAILED_COUNTS_INTERVAL,1);
               this.clearFailedCountsTimer.addEventListener(TimerEvent.TIMER,this.clearFailedCounts);
            }
            this.clearFailedCountsTimer.start();
         }
      }
      
      private function clearFailedCounts(param1:TimerEvent) : void
      {
         this.clearFailedCountsTimer.removeEventListener(TimerEvent.TIMER,this.clearFailedCounts);
         this.clearFailedCountsTimer = null;
         this.initDSIFailedCounts();
      }
      
      private function setThrottleLimits(param1:int) : void
      {
         this.connection.call("setBandwidthLimit",null,this._bandwidthLimit,this._bandwidthLimit);
      }
      
      private function debug(... rest) : void
      {
         this.logger.debug(new Date().toTimeString() + ">>> NetStreamSwitchManager." + rest);
      }
   }
}
