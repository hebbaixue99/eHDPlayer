package org.osmf.player.utils
{
   import flash.utils.Dictionary;
   
   public class StrobePlayerStrings
   {
      
      public static const ILLEGAL_INPUT_VARIABLE:String = "illegalInputVariable";
      
      public static const DYNAMIC_STREAMING_RESOURCE_EXPECTED:String = "dynamicStreamingResourceExpected";
      
      public static const CONFIGURATION_LOAD_ERROR:String = "configurationFileLoadError";
      
      private static const resourceDict:Dictionary = new Dictionary();
      
      private static var _resourceStringFunction:Function = defaultResourceStringFunction;
      
      {
         resourceDict[ILLEGAL_INPUT_VARIABLE] = "Illegal input variables";
         resourceDict[DYNAMIC_STREAMING_RESOURCE_EXPECTED] = "A DynamicStreamingResource was expected along the proxy chain.";
      }
      
      public function StrobePlayerStrings()
      {
         super();
      }
      
      public static function getString(param1:String, param2:Array = null) : String
      {
         return resourceStringFunction(param1,param2);
      }
      
      public static function get resourceStringFunction() : Function
      {
         return _resourceStringFunction;
      }
      
      public static function set resourceStringFunction(param1:Function) : void
      {
         _resourceStringFunction = param1;
      }
      
      private static function defaultResourceStringFunction(param1:String, param2:Array = null) : String
      {
         var _loc3_:String = !!resourceDict.hasOwnProperty(param1)?String(resourceDict[param1]):null;
         if(_loc3_ == null)
         {
            _loc3_ = String(resourceDict["missingStringResource"]);
            param2 = [param1];
         }
         if(param2)
         {
            _loc3_ = substitute(_loc3_,param2);
         }
         return _loc3_;
      }
      
      private static function substitute(param1:String, ... rest) : String
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc3_:String = "";
         if(param1 != null)
         {
            _loc3_ = param1;
            _loc4_ = rest.length;
            if(_loc4_ == 1 && rest[0] is Array)
            {
               _loc5_ = rest[0] as Array;
               _loc4_ = _loc5_.length;
            }
            else
            {
               _loc5_ = rest;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc3_ = _loc3_.replace(new RegExp("\\{" + _loc6_ + "\\}","g"),_loc5_[_loc6_]);
               _loc6_++;
            }
         }
         return _loc3_;
      }
   }
}
