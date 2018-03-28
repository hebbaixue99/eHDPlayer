package org.osmf.player.chrome.assets
{
   import flash.geom.Rectangle;
   
   public class BitmapResource extends AssetResource
   {
       
      
      private var _scale9:Rectangle;
      
      public function BitmapResource(param1:String, param2:String, param3:Boolean, param4:Rectangle)
      {
         this._scale9 = param4;
         super(param1,param2,param3);
      }
      
      public function get scale9() : Rectangle
      {
         return this._scale9;
      }
   }
}
