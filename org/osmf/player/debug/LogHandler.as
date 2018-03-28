package org.osmf.player.debug
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Timer;
   import org.osmf.player.debug.qos.IndicatorsBase;
   import org.osmf.player.debug.qos.QoSDashboard;
   
   public class LogHandler
   {
       
      
      public var qos:QoSDashboard;
      
      private var timer:Timer;
      
      private var logCount:uint = 0;
      
      protected var qosIndicators:Object;
      
      protected var changedQOSIndicators:Object;
      
      protected var logMessages:Vector.<LogMessage>;
      
      protected var qosProperties:Array;
      
      protected var qosPropertiesSorted:Boolean = true;
      
      private const MIN_UPDATE_INTERVAL:uint = 1000;
      
      private const MAX_LOG_COUNT:uint = 1000;
      
      private const LINE_SEPARATOR:String = "___";
      
      public function LogHandler()
      {
         this.qos = new QoSDashboard();
         this.qosIndicators = new Object();
         this.changedQOSIndicators = new Object();
         this.logMessages = new Vector.<LogMessage>();
         this.qosProperties = new Array();
         super();
         this.timer = new Timer(this.MIN_UPDATE_INTERVAL);
         this.timer.addEventListener(TimerEvent.TIMER,this.handleData);
         this.timer.start();
      }
      
      public function handleProperty(param1:String, param2:Object) : void
      {
         if(param2 == null)
         {
            return;
         }
         if(param2 is Number)
         {
            if(param2 == 0)
            {
               return;
            }
            param2 = int(Number(param2) * 1000) / 1000;
         }
         if(!this.qosIndicators.hasOwnProperty(param1))
         {
            this.qosProperties.push(param1);
            this.qosPropertiesSorted = false;
         }
         if(this.qosIndicators[param1] != param2)
         {
            this.qosIndicators[param1] = param2;
            this.changedQOSIndicators[param1] = param2;
         }
      }
      
      public function handleLogMessage(param1:LogMessage) : void
      {
         this.logMessages.unshift(param1);
         if(this.logMessages.length > this.MAX_LOG_COUNT)
         {
            this.logMessages.pop();
         }
      }
      
      protected function handleData(param1:Event = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:IndicatorsBase = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:LogMessage = null;
         var _loc2_:String = "";
         for each(_loc3_ in this.qos.getFields())
         {
            if(this.qos[_loc3_] is IndicatorsBase)
            {
               _loc5_ = this.qos[_loc3_] as IndicatorsBase;
               for each(_loc6_ in _loc5_.getFields())
               {
                  _loc2_ = _loc2_ + (_loc3_ + "__" + _loc6_ + "==" + this.format(_loc5_[_loc6_]));
                  _loc2_ = _loc2_ + this.LINE_SEPARATOR;
               }
            }
            else
            {
               _loc2_ = _loc2_ + ("KeyStats__" + _loc3_ + "==" + this.format(this.qos[_loc3_]));
               _loc2_ = _loc2_ + this.LINE_SEPARATOR;
            }
         }
         if(!this.qosPropertiesSorted)
         {
            this.qosProperties.sort();
            this.qosPropertiesSorted = true;
         }
         for each(_loc4_ in this.qosProperties)
         {
            if(this.changedQOSIndicators.hasOwnProperty(_loc4_))
            {
               _loc2_ = _loc2_ + (_loc4_ + "==" + this.format(this.changedQOSIndicators[_loc4_]));
               _loc2_ = _loc2_ + this.LINE_SEPARATOR;
            }
         }
         if(_loc2_.length > 0)
         {
            ExternalInterface.call("org.osmf.player.debug.track",_loc2_);
         }
         this.changedQOSIndicators = new Object();
         if(this.logMessages.length > 0)
         {
            _loc7_ = "";
            for each(_loc8_ in this.logMessages)
            {
               _loc7_ = _loc7_ + _loc8_.toString();
               _loc7_ = _loc7_ + this.LINE_SEPARATOR;
            }
            ExternalInterface.call("org.osmf.player.debug.logs",_loc7_);
            this.logMessages = new Vector.<LogMessage>();
         }
      }
      
      private function format(param1:Object) : Object
      {
         if(param1 is Number)
         {
            param1 = int(Number(param1) * 1000) / 1000;
         }
         return param1;
      }
   }
}
