package org.osmf.player.chrome.assets
{
   import flash.display.DisplayObject;
   
   public class SWFAsset extends DisplayObjectAsset
   {
       
      
      private var _displayObject:DisplayObject;
      
      public function SWFAsset(param1:DisplayObject)
      {
         this._displayObject = param1;
         super();
      }
      
      override public function get displayObject() : DisplayObject
      {
         return this._displayObject;
      }
   }
}
