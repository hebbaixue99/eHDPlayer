package org.osmf.player.chrome.assets
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Dictionary;
   
   import org.osmf.player.chrome.configuration.AssetsParser;
   
   public class AssetsManager extends EventDispatcher
   {
       
      
      private var loaders:Dictionary;
      
      private var resourceByLoader:Dictionary;
      
      private var assetCount:int = 0;
      
      private var _completionCount:int = -1;
      
      public function AssetsManager()
      {
         super();
         this.loaders = new Dictionary();
         this.resourceByLoader = new Dictionary();
      }
      
      public function addConfigurationAssets(param1:XML) : void
      {
         var _loc2_:AssetsParser = new AssetsParser();
         _loc2_.parse(param1.assets,this);
      }
      
      public function addAsset(param1:AssetResource, param2:AssetLoader) : void
      {
         var _loc3_:AssetLoader = this.getLoader(param1.id);
         if(_loc3_ == null)
         {
            this.assetCount++;
            this.loaders[param1] = param2;
            this.resourceByLoader[param2] = param1;
         }
      }
      
      public function getResource(param1:AssetLoader) : AssetResource
      {
         return this.resourceByLoader[param1];
      }
      
      public function getLoader(param1:String) : AssetLoader
      {
         var _loc2_:AssetLoader = null;
         var _loc3_:AssetResource = null;
         for each(_loc3_ in this.resourceByLoader)
         {
            if(_loc3_.id == param1)
            {
               _loc2_ = this.loaders[_loc3_];
               break;
            }
         }
         return _loc2_;
      }
      
      public function getAsset(param1:String) : Asset
      {
         var _loc2_:AssetLoader = this.getLoader(param1);
         return !!_loc2_?_loc2_.asset:null;
      }
      
      public function getDisplayObject(param1:String) : DisplayObject
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObjectAsset = this.getAsset(param1) as DisplayObjectAsset;
         if(_loc3_)
         {
            _loc2_ = _loc3_.displayObject;
         }
         return _loc2_;
      }
      
      public function load() : void
      {
		  ExternalInterface.call("msg","AssetsManager.load");
         var _loc1_:AssetLoader = null;
         this.completionCount = this.assetCount;
		 var count:int = this.assetCount;
		 ExternalInterface.call("msg","[this.assetCount]="+this.assetCount); 
		// ExternalInterface.call("msg","[this.assetCount]="+this.loaders);
         for each(_loc1_ in this.loaders)
         {
			 ExternalInterface.call("msg","[load()_completionCount]="+count--); 
            _loc1_.addEventListener(Event.COMPLETE,this.onAssetLoaderComplete);
            _loc1_.load(this.resourceByLoader[_loc1_]);
         }
      }
      
      private function set completionCount(param1:int) : void
      {
         if(this._completionCount != param1)
         {
            this._completionCount = param1;
            if(this._completionCount == 0)
            {
               dispatchEvent(new Event(Event.COMPLETE));
            }
         }
      }
      
      private function get completionCount() : int
      {
         return this._completionCount;
      }
      
      private function onAssetLoaderComplete(param1:Event) : void
      {
		  ExternalInterface.call("msg","onAssetLoaderComplete_"+_completionCount);
         var _loc2_:AssetLoader = param1.target as AssetLoader;
         var _loc3_:AssetResource = this.resourceByLoader[param1.target];
         this.completionCount--;
      }
      
      private function onAssetLoaderError(param1:IOErrorEvent) : void
      {
		  ExternalInterface.call("msg","onAssetLoaderError_"+_completionCount);
         var _loc2_:AssetResource = this.resourceByLoader[param1.target];
         this.completionCount--;
      }
   }
}
