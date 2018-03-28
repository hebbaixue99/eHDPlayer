package org.osmf.player.chrome.assets
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public class BitmapAsset extends DisplayObjectAsset
   {
       
      
      private var _bitmap:Bitmap;
      
      private var _scale9:Rectangle;
      
      public function BitmapAsset(param1:Bitmap, param2:Rectangle = null)
      {
         this._bitmap = param1;
         this._scale9 = param2;
         super();
      }
      
      override public function get displayObject() : DisplayObject
      {
         return !!this._scale9?new Scale9Bitmap(this._bitmap,this._scale9):new Bitmap(this._bitmap.bitmapData.clone(),this._bitmap.pixelSnapping,this._bitmap.smoothing);
      }
   }
}
