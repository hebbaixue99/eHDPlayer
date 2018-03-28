package org.osmf.logging
{
   public class TraceLogger extends Logger
   {
      
      private static const LEVEL_DEBUG:String = "DEBUG";
      
      private static const LEVEL_WARN:String = "WARN";
      
      private static const LEVEL_INFO:String = "INFO";
      
      private static const LEVEL_ERROR:String = "ERROR";
      
      private static const LEVEL_FATAL:String = "FATAL";
       
      
      public function TraceLogger(param1:String)
      {
         super(param1);
      }
      
      override public function debug(param1:String, ... rest) : void
      {
         this.logMessage(LEVEL_DEBUG,param1,rest);
      }
      
      override public function info(param1:String, ... rest) : void
      {
         this.logMessage(LEVEL_INFO,param1,rest);
      }
      
      override public function warn(param1:String, ... rest) : void
      {
         this.logMessage(LEVEL_WARN,param1,rest);
      }
      
      override public function error(param1:String, ... rest) : void
      {
         this.logMessage(LEVEL_ERROR,param1,rest);
      }
      
      override public function fatal(param1:String, ... rest) : void
      {
         this.logMessage(LEVEL_FATAL,param1,rest);
      }
      
      protected function logMessage(param1:String, param2:String, param3:Array) : void
      {
         var _loc4_:String = "";
         _loc4_ = _loc4_ + (new Date().toLocaleString() + " [" + param1 + "] ");
         _loc4_ = _loc4_ + ("[" + category + "] " + this.applyParams(param2,param3));
         trace(_loc4_);
      }
      
      private function applyParams(param1:String, param2:Array) : String
      {
         var _loc3_:String = param1;
         var _loc4_:int = param2.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _loc3_.replace(new RegExp("\\{" + _loc5_ + "\\}","g"),param2[_loc5_]);
            _loc5_++;
         }
         return _loc3_;
      }
   }
}
