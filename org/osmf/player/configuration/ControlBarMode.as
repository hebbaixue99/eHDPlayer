package org.osmf.player.configuration
{
   public final class ControlBarMode
   {
      
      public static const NONE:String = "none";
      
      public static const DOCKED:String = "docked";
      
      public static const FLOATING:String = "floating";
      
      public static const values:Array = [ControlBarMode.DOCKED,ControlBarMode.FLOATING,ControlBarMode.NONE];
       
      
      public function ControlBarMode()
      {
         super();
      }
   }
}
