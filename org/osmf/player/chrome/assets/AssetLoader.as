package org.osmf.player.chrome.assets
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.utils.getDefinitionByName;
   
   public class AssetLoader extends EventDispatcher
   {
       
      
      protected var resource:AssetResource;
      
      private var _asset:Asset;
      
      public function AssetLoader()
      {
         super();
      }
      
      public function load(param1:AssetResource) : void
      {
         var _loc2_:Loader = null;
         this.resource = param1;
		 ExternalInterface.call("msg","param1.id="+param1.id);
		 //if (param1.id=="defaultFont"){
		//	 dispatchEvent(new Event(Event.COMPLETE));
		// }else 
		 if(param1.local == false)
         {
            if(param1 is BitmapResource || param1 is FontResource || param1 is SymbolResource)
            {
               _loc2_ = new Loader();
               _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
               _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderComplete);
			   ExternalInterface.call("msg","param1.url="+param1.url);
			   _loc2_.load(new URLRequest(param1.url));
            }else{
				dispatchEvent(new Event(Event.COMPLETE));
			}
         }
         else
         {
			ExternalInterface.call("msg","constructLocalAsset_begin");
			if (param1.id=="defaultFont"){
				dispatchEvent(new Event(Event.COMPLETE));
			}else{
            this._asset = this.constructLocalAsset();
            dispatchEvent(new Event(Event.COMPLETE));
			}
			ExternalInterface.call("msg","constructLocalAsset_end");
         }
	 // }
      }
      
      public function get asset() : Asset
      {
         return this._asset;
      }
      
      protected function onLoaderError(param1:IOErrorEvent) : void
      {
         trace("WARNING: failed loading asset:",this.resource.id,"from",this.resource.url);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function onLoaderComplete(param1:Event) : void
      {
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         this._asset = this.constructLoadedAsset(_loc2_);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function constructLoadedAsset(param1:LoaderInfo) : Asset
      {
         var _loc2_:Asset = null;
         var _loc3_:Class = null;
         if(this.resource is FontResource)
         {
            _loc3_ = param1.applicationDomain.getDefinition(FontResource(this.resource).symbol) as Class;
            _loc2_ = new FontAsset(_loc3_,this.resource as FontResource);
         }
         else if(this.resource is BitmapResource)
         {
            if(param1.contentType == "application/x-shockwave-flash")
            {
               _loc2_ = new SWFAsset(param1.content);
            }
            else if(param1.contentType != "")
            {
               _loc2_ = new BitmapAsset(param1.content as Bitmap,this.resource is BitmapResource?BitmapResource(this.resource).scale9:null);
            }
         }
         else if(this.resource is SymbolResource)
         {
            _loc3_ = param1.applicationDomain.getDefinition(SymbolResource(this.resource).symbol) as Class;
            _loc2_ = new SymbolAsset(_loc3_);
         }
         return _loc2_;
      }
      
      protected function constructLocalAsset() : Asset
      {
         var asset:Asset = null;
         var type:Class = null;
         var bitmap:* = undefined;
         try
         {
            type = getDefinitionByName(this.resource.url) as Class;
         }
         catch(error:Error)
         {
            trace("WARNING: failure instantiating local asset:",error.message);
         }
         if(type != null)
         {
            if(this.resource is BitmapResource)
            {
               bitmap = new type();
               if(bitmap is BitmapData)
               {
                  bitmap = new Bitmap(bitmap);
               }
               asset = new BitmapAsset(bitmap,BitmapResource(this.resource).scale9);
            }
            else if(this.resource is FontResource)
            {
               asset = new FontAsset(type,this.resource as FontResource);
            }
            else if(this.resource is SymbolResource)
            {
               asset = new SymbolAsset(type);
            }
            else
            {
               trace("WARNING: no suitable asset type found for " + this.resource.id);
            }
         }
         else
         {
            trace("WARNING: failed loading " + this.resource.id);
         }
         return asset;
      }
   }
}
