package org.osmf.player.chrome.assets
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   
   public class SymbolAsset extends DisplayObjectAsset
   {
       
      
      private var _type:Class;
      
      public function SymbolAsset(param1:Class)
      {
         this._type = param1;
         super();
      }
      
      public function get type() : Class
      {
         return this._type;
      }
      
      override public function get displayObject() : DisplayObject
      {
         var _loc1_:* = new this.type();
         if(_loc1_ is BitmapData)
         {
            _loc1_ = new Bitmap(_loc1_);
         }
         return _loc1_ as DisplayObject;
      }
   }
}
