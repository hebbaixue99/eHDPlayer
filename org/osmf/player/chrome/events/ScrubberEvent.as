package org.osmf.player.chrome.events
{
   import flash.events.Event;
   
   public class ScrubberEvent extends Event
   {
      
      public static const SCRUB_START:String = "scrubStart";
      
      public static const SCRUB_UPDATE:String = "scrubUpdate";
      
      public static const SCRUB_END:String = "scrubEnd";
       
      
      public function ScrubberEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
