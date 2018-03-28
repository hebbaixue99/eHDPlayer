package org.osmf.player.chrome.assets
{
   import flash.text.Font;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class FontAsset extends SymbolAsset
   {
       
      
      private var _font:Font;
      
      private var resource:FontResource;
      
      public function FontAsset(param1:Class, param2:FontResource)
      {
         super(param1);
         this._font = new param1();
         Font.registerFont(param1);
         this.resource = param2;
      }
      
      public function get font() : Font
      {
         return this._font;
      }
      
      public function get format() : TextFormat
      {
         var _loc1_:TextFormat = new TextFormat(this._font.fontName,this.resource.size,this.resource.color);
         _loc1_.align = TextFormatAlign.LEFT;
         return _loc1_;
      }
   }
}
