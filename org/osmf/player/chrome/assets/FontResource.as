package org.osmf.player.chrome.assets
{
   public class FontResource extends SymbolResource
   {
       
      
      private var _size:Number;
      
      private var _color:uint;
      
      public function FontResource(param1:String, param2:String, param3:Boolean, param4:String, param5:Number, param6:uint)
      {
         super(param1,param2,param3,param4);
         this._size = param5;
         this._color = param6;
      }
      
      public function get size() : Number
      {
         return this._size;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
   }
}
