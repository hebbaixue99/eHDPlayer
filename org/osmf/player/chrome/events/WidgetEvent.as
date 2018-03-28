package org.osmf.player.chrome.events
{
   import flash.events.Event;
   
   public class WidgetEvent extends Event
   {
      
      public static const REQUEST_FULL_SCREEN:String = "requestFullScreen";
       
      
      public function WidgetEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
