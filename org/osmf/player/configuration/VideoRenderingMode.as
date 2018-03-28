package org.osmf.player.configuration
{
   public class VideoRenderingMode
   {
      
      public static const NONE:uint = 0;
      
      public static const SMOOTHING:uint = 1;
      
      public static const DEBLOCKING:uint = 2;
      
      public static const SMOOTHING_DEBLOCKING:uint = 3;
      
      public static const AUTO:uint = 4;
      
      public static const values:Array = [VideoRenderingMode.NONE,VideoRenderingMode.SMOOTHING,VideoRenderingMode.DEBLOCKING,VideoRenderingMode.SMOOTHING_DEBLOCKING,VideoRenderingMode.AUTO];
       
      
      public function VideoRenderingMode()
      {
         super();
      }
   }
}
