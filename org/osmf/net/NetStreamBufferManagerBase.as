package org.osmf.net
{
   import flash.events.NetStatusEvent;
   import flash.net.NetStream;
   import org.osmf.logging.Log;
   import org.osmf.player.debug.StrobeLogger;
   
   public class NetStreamBufferManagerBase
   {
       
      
      protected var netStream:NetStream;
      
      protected var metrics:PlaybackOptimizationMetrics;
      
      private var _initialBufferTime:Number = 15;
      
      private var _expandedBufferTime:Number = 15;
      
      private var _minContinuousTime:Number = 30;
      
      private var started:Boolean = false;
      
      private var logger:StrobeLogger;
      
      public function NetStreamBufferManagerBase(param1:NetStream, param2:PlaybackOptimizationMetrics)
      {
         this.logger = Log.getLogger("StrobeMediaPlayback") as StrobeLogger;
         super();
         this.netStream = param1;
         this.metrics = param2;
         param1.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
      }
      
      public function get expandedBufferTime() : Number
      {
         return this._expandedBufferTime;
      }
      
      public function set expandedBufferTime(param1:Number) : void
      {
         this._expandedBufferTime = param1;
      }
      
      public function get initialBufferTime() : Number
      {
         return this._initialBufferTime;
      }
      
      public function set initialBufferTime(param1:Number) : void
      {
         this._initialBufferTime = param1;
      }
      
      public function get minContinuousTime() : Number
      {
         return this._minContinuousTime;
      }
      
      public function set minContinuousTime(param1:Number) : void
      {
         this._minContinuousTime = param1;
      }
      
      public function computeBufferTime() : Number
      {
         var _loc1_:Number = NaN;
         if(isNaN(this.metrics.downloadRatio) || this.metrics.downloadRatio > 1)
         {
            return NaN;
         }
         if(isNaN(this.metrics.duration - this.netStream.time))
         {
            return NaN;
         }
         var _loc2_:Number = this.minContinuousTime;
         if(this.metrics.duration - this.netStream.time > 0)
         {
            _loc2_ = Math.min(this.metrics.duration - this.netStream.time,_loc2_);
         }
         var _loc3_:Number = _loc2_ * (1 - this.metrics.downloadRatio);
         _loc3_ = Math.max(this.netStream.bufferLength,_loc3_);
         return _loc3_;
      }
      
      protected function onNetStatus(param1:NetStatusEvent) : void
      {
         var _loc2_:Number = NaN;
         switch(param1.info.code)
         {
            case NetStreamCodes.NETSTREAM_PLAY_START:
               if(!this.started)
               {
                  this.netStream.bufferTime = this.initialBufferTime;
                  this.started = true;
               }
               break;
            case NetStreamCodes.NETSTREAM_SEEK_NOTIFY:
               this.netStream.bufferTime = this.initialBufferTime;
               break;
            case NetStreamCodes.NETSTREAM_BUFFER_FULL:
               if(isNaN(this.metrics.downloadRatio) || this.metrics.downloadRatio > 1)
               {
                  this.logger.info("ExpandedBuffer:. previousBufferTime={0} currentBufferTime={1}",this.netStream.bufferTime,this.expandedBufferTime);
                  this.logger.qos.buffer.time = this.expandedBufferTime;
                  if(this.expandedBufferTime == 15)
                  {
                     this.netStream.bufferTime = 20;
                  }
                  else if(this.expandedBufferTime == 20)
                  {
                     this.netStream.bufferTime = 40;
                  }
                  else if(this.expandedBufferTime >= 40)
                  {
                     this.netStream.bufferTime = 80;
                  }
                  this.expandedBufferTime++;
                  break;
               }
            case NetStreamCodes.NETSTREAM_BUFFER_EMPTY:
               _loc2_ = this.computeBufferTime();
               if(_loc2_ > 0 && _loc2_ != this.netStream.bufferTime)
               {
                  this.logger.info("DynamicBuffer: previousBufferTime={0} currentBufferTime={1}",this.netStream.bufferTime,_loc2_);
                  this.logger.qos.buffer.time = _loc2_;
                  this.netStream.bufferTime = _loc2_;
               }
         }
      }
   }
}
