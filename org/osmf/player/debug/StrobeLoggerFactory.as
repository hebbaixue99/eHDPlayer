package org.osmf.player.debug
{
   import flash.utils.Dictionary;
   import org.osmf.logging.Logger;
   import org.osmf.logging.LoggerFactory;
   
   public class StrobeLoggerFactory extends LoggerFactory
   {
       
      
      private var loggers:Dictionary;
      
      private var logHandler:LogHandler;
      
      public function StrobeLoggerFactory(param1:LogHandler)
      {
         super();
         this.loggers = new Dictionary();
         this.logHandler = param1;
      }
      
      override public function getLogger(param1:String) : Logger
      {
         var _loc2_:Logger = this.loggers[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new StrobeLogger(param1,this.logHandler);
            this.loggers[param1] = _loc2_;
         }
         return _loc2_;
      }
   }
}
