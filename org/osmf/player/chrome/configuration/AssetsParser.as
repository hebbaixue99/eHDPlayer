package org.osmf.player.chrome.configuration
{
   import flash.errors.IllegalOperationError;
   import flash.geom.Rectangle;
   import org.osmf.player.chrome.assets.AssetLoader;
   import org.osmf.player.chrome.assets.AssetResource;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.assets.BitmapResource;
   import org.osmf.player.chrome.assets.FontResource;
   import org.osmf.player.chrome.assets.SymbolResource;
   
   public class AssetsParser
   {
       
      
      public function AssetsParser()
      {
         super();
      }
      
      public function parse(param1:XMLList, param2:AssetsManager) : void
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:AssetLoader = null;
         var _loc6_:AssetResource = null;
         var _loc7_:XML = null;
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_.@baseURL || "";
            for each(_loc7_ in _loc3_.asset)
            {
               _loc5_ = new AssetLoader();
               _loc6_ = this.assetToResource(_loc7_,_loc4_);
               if(_loc5_ && _loc6_)
               {
                  param2.addAsset(_loc6_,_loc5_);
                  continue;
               }
               throw new IllegalOperationError("Unknown resource type",_loc7_.@type);
            }
         }
      }
      
      private function assetToResource(param1:XML, param2:String = "") : AssetResource
      {
         var _loc4_:AssetResource = null;
         var _loc3_:String = String(param1.@type || "").toLowerCase();
         switch(_loc3_)
         {
            case "bitmapfile":
            case "embeddedbitmap":
               _loc4_ = new BitmapResource(param1.@id,param2 + param1.@url,_loc3_ == "embeddedbitmap",this.parseRect(param1.@scale9));
               break;
            case "fontsymbol":
            case "embeddedfont":
               _loc4_ = new FontResource(param1.@id,param2 + param1.@url,_loc3_ == "embeddedfont",param1.@symbol,parseInt(param1.@fontSize || "11"),parseInt(param1.@color || "0xFFFFFF"));
               break;
            case "symbol":
               _loc4_ = new SymbolResource(param1.@id,null,true,param1.@symbol);
         }
         return _loc4_;
      }
      
      private function parseRect(param1:String) : Rectangle
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Array = param1.split(",");
         if(_loc3_.length == 4)
         {
            _loc2_ = new Rectangle(parseInt(_loc3_[0]),parseInt(_loc3_[1]),parseInt(_loc3_[2]),parseInt(_loc3_[3]));
         }
         return _loc2_;
      }
   }
}
