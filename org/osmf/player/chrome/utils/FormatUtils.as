package org.osmf.player.chrome.utils
{
   public class FormatUtils
   {
       
      
      public function FormatUtils()
      {
         super();
      }
      
      public static function formatTimeStatus(param1:Number, param2:Number, param3:Boolean = false, param4:String = "Live") : Vector.<String>
      {
         var h:int = 0;
         var m:int = 0;
         var s:int = 0;
         var currentPosition:Number = param1;
         var totalDuration:Number = param2;
         var isLive:Boolean = param3;
         var LIVE:String = param4;
         var prettyPrintSeconds:Function = function(param1:Number, param2:Boolean = false, param3:Boolean = false):String
         {
            param1 = Math.floor(!!isNaN(param1)?Number(0):Number(Math.max(0,param1)));
            h = Math.floor(param1 / 3600);
            m = Math.floor(param1 % 3600 / 60);
            s = param1 % 60;
            return (h > 0 || param3?h + ":":"") + ((h > 0 || param2) && m < 10?"0":"") + m + ":" + (s < 10?"0":"") + s;
         };
         var totalDurationString:String = !!isNaN(totalDuration)?LIVE:prettyPrintSeconds(totalDuration);
         var currentPositionString:String = !!isLive?LIVE:prettyPrintSeconds(currentPosition,h > 0 || m > 9,h > 0);
         while(currentPositionString.length < totalDurationString.length)
         {
            currentPositionString = " " + currentPositionString;
         }
         while(totalDurationString.length < currentPositionString.length)
         {
            totalDurationString = " " + totalDurationString;
         }
         var result:Vector.<String> = new Vector.<String>();
         result[0] = currentPositionString;
         result[1] = totalDurationString;
         return result;
      }
   }
}
