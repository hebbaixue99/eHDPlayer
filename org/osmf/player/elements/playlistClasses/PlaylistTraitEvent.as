package org.osmf.player.elements.playlistClasses
{
   import flash.events.Event;
   
   class PlaylistTraitEvent extends Event
   {
      
      public static const ACTIVE_ITEM_COMPLETE:String = "lastItemComplete";
      
      public static const ENABLED_CHANGE:String = "enabledChange";
       
      
      function PlaylistTraitEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
