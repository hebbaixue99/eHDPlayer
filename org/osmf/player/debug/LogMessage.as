package org.osmf.player.debug
{
   public class LogMessage
   {
       
      
      private var _level:String;
      
      private var _category:String;
      
      private var _message:String;
      
      private var _params:Array;
      
      private var _timestamp:Date;
      
      public function LogMessage(param1:String, param2:String, param3:String, param4:Array, param5:Date = null)
      {
         super();
         this._category = param2;
         this._level = param1;
         this._message = param3;
         this._params = param4;
         if(param5 == null)
         {
            this._timestamp = new Date();
         }
         else
         {
            this._timestamp = param5;
         }
      }
      
      public function get formatedMessage() : String
      {
         var _loc1_:String = this.message;
         var _loc2_:int = this.params.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _loc1_.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),this.params[_loc3_]);
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function get formatedTimestamp() : String
      {
         return this._timestamp.toLocaleString();
      }
      
      public function get params() : Array
      {
         return this._params;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function get level() : String
      {
         return this._level;
      }
      
      public function get timestamp() : Date
      {
         return this._timestamp;
      }
      
      public function toString() : String
      {
         return this.formatedTimestamp + " [" + this.level + "] " + this.category + " " + this.formatedMessage;
      }
   }
}
