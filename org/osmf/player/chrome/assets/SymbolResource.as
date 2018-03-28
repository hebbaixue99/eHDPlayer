package org.osmf.player.chrome.assets
{
   public class SymbolResource extends AssetResource
   {
       
      
      private var _symbol:String;
      
      public function SymbolResource(param1:String, param2:String, param3:Boolean, param4:String)
      {
         this._symbol = param4;
         super(param1,param2,param3);
      }
      
      public function get symbol() : String
      {
         return this._symbol;
      }
   }
}
