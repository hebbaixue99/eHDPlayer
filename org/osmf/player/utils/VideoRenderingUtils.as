package org.osmf.player.utils
{
   import flash.geom.Rectangle;
   import org.osmf.elements.LightweightVideoElement;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.utils.MediaElementUtils;
   import org.osmf.player.configuration.VideoRenderingMode;
   import org.osmf.player.errors.StrobePlayerError;
   import org.osmf.player.errors.StrobePlayerErrorCodes;
   
   public class VideoRenderingUtils
   {
       
      
      public function VideoRenderingUtils()
      {
         super();
      }
      
      public static function determineDeblocking(param1:uint, param2:Boolean) : int
      {
         var _loc3_:int = 0;
         switch(param1)
         {
            case VideoRenderingMode.NONE:
               _loc3_ = 1;
               break;
            case VideoRenderingMode.DEBLOCKING:
            case VideoRenderingMode.SMOOTHING_DEBLOCKING:
               _loc3_ = 0;
               break;
            case VideoRenderingMode.AUTO:
               _loc3_ = !!param2?1:0;
               break;
            default:
               throw new StrobePlayerError(StrobePlayerErrorCodes.ILLEGAL_INPUT_VARIABLE);
         }
         return _loc3_;
      }
      
      public static function determineSmoothing(param1:uint, param2:Boolean) : Boolean
      {
         var _loc3_:* = false;
         switch(param1)
         {
            case VideoRenderingMode.NONE:
               _loc3_ = false;
               break;
            case VideoRenderingMode.SMOOTHING:
            case VideoRenderingMode.SMOOTHING_DEBLOCKING:
               _loc3_ = true;
               break;
            case VideoRenderingMode.AUTO:
               _loc3_ = !param2;
               break;
            default:
               throw new StrobePlayerError(StrobePlayerErrorCodes.ILLEGAL_INPUT_VARIABLE);
         }
         return _loc3_;
      }
      
      public static function computeOptimalFullScreenSourceRect(param1:int, param2:int, param3:int, param4:int) : Rectangle
      {
         var _loc5_:Number = param1 / param2 / (param3 / param4);
         var _loc6_:Number = param3;
         var _loc7_:Number = param4;
         if(_loc5_ > 1)
         {
            _loc6_ = param3 * _loc5_;
         }
         else
         {
            _loc7_ = param4 / _loc5_;
         }
         var _loc8_:Rectangle = new Rectangle(0,0,_loc6_,_loc7_);
         return _loc8_;
      }
      
      public static function applyHDSDBestPractices(param1:MediaElement, param2:uint, param3:Boolean) : void
      {
         var _loc4_:LightweightVideoElement = MediaElementUtils.getMediaElementParentOfType(param1,LightweightVideoElement) as LightweightVideoElement;
         if(_loc4_ != null)
         {
            _loc4_.smoothing = VideoRenderingUtils.determineSmoothing(param2,param3);
            _loc4_.deblocking = VideoRenderingUtils.determineDeblocking(param2,param3);
         }
      }
   }
}
