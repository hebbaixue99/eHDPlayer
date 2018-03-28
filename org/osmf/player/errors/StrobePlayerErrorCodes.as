package org.osmf.player.errors
{
   import org.osmf.player.utils.StrobePlayerStrings;
   
   public class StrobePlayerErrorCodes
   {
      
      public static const ILLEGAL_INPUT_VARIABLE:int = 0;
      
      public static const DYNAMIC_STREAMING_RESOURCE_EXPECTED:int = 1;
      
      public static const CONFIGURATION_LOAD_ERROR:int = 2;
      
      private static const errorMap:Array = [{
         "errorID":ILLEGAL_INPUT_VARIABLE,
         "message":StrobePlayerStrings.ILLEGAL_INPUT_VARIABLE
      },{
         "errorID":DYNAMIC_STREAMING_RESOURCE_EXPECTED,
         "message":StrobePlayerStrings.DYNAMIC_STREAMING_RESOURCE_EXPECTED
      },{
         "errorID":CONFIGURATION_LOAD_ERROR,
         "message":StrobePlayerStrings.CONFIGURATION_LOAD_ERROR
      }];
       
      
      public function StrobePlayerErrorCodes()
      {
         super();
      }
      
      static function getMessageForErrorID(param1:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < errorMap.length)
         {
            if(errorMap[_loc3_].errorID == param1)
            {
               _loc2_ = StrobePlayerStrings.getString(errorMap[_loc3_].message);
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
