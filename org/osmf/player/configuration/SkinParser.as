package org.osmf.player.configuration
{
   import org.osmf.player.chrome.assets.AssetLoader;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.assets.BitmapResource;
   
   public class SkinParser
   {
       
      
      public function SkinParser()
      {
         super();
      }
      
      public function parse(param1:XML, param2:AssetsManager) : void
      {
         var _loc3_:Vector.<String> = null;
         var _loc4_:XML = null;
         var _loc5_:XML = null;
         if(param1 != null)
         {
            _loc3_ = new Vector.<String>();
            for each(_loc4_ in param1.element)
            {
               this.parseElement(_loc4_,"",param2);
            }
            for each(_loc5_ in param1.elements)
            {
               this.parseElements(_loc5_,param2);
            }
         }
      }
      
      public function parseElements(param1:XML, param2:AssetsManager) : void
      {
         var _loc4_:XML = null;
         var _loc3_:String = param1.@basePath || "";
         for each(_loc4_ in param1.element)
         {
            this.parseElement(_loc4_,_loc3_,param2);
         }
      }
      
      public function parseElement(param1:XML, param2:String, param3:AssetsManager) : void
      {
         var _loc4_:String = param1.@id;
         if(_loc4_ && _loc4_ != "")
         {
            param3.addAsset(new BitmapResource(_loc4_,param2 + param1.@src,false,null),new AssetLoader());
         }
         else
         {
            trace("WARNING: missing skin element id (for the asset at",param2 + param1.@src,")");
         }
      }
   }
}
