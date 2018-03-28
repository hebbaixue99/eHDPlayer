package org.osmf.elements.loaderClasses
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   import org.osmf.events.MediaError;
   import org.osmf.events.MediaErrorCodes;
   import org.osmf.events.MediaErrorEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.media.URLResource;
   import org.osmf.traits.DisplayObjectTrait;
   import org.osmf.traits.LoadState;
   import org.osmf.traits.LoadTrait;
   
   public class LoaderUtils
   {
      
      private static const SWF_MIME_TYPE:String = "application/x-shockwave-flash";
       
      
      public function LoaderUtils()
      {
         super();
      }
      
      public static function createDisplayObjectTrait(param1:Loader, param2:MediaElement) : DisplayObjectTrait
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:LoaderInfo = param1.contentLoaderInfo;
         _loc3_ = param1;
         _loc3_.scrollRect = new Rectangle(0,0,_loc6_.width,_loc6_.height);
         _loc4_ = _loc6_.width;
         _loc5_ = _loc6_.height;
         return new DisplayObjectTrait(_loc3_,_loc4_,_loc5_);
      }
      
      public static function loadLoadTrait(param1:LoadTrait, param2:Function, param3:Boolean, param4:Boolean, param5:Function = null) : void
      {
         var loader:Loader = null;
         var onLoadComplete:Function = null;
         var onIOError:Function = null;
         var onSecurityError:Function = null;
         var loadTrait:LoadTrait = param1;
         var updateLoadTraitFunction:Function = param2;
         var useCurrentSecurityDomain:Boolean = param3;
         var checkPolicyFile:Boolean = param4;
         var validateLoadedContentFunction:Function = param5;
         var toggleLoaderListeners:Function = function(param1:Loader, param2:Boolean):void
         {
            if(param2)
            {
               param1.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
               param1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
               param1.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
            }
            else
            {
               param1.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);
               param1.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
               param1.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
            }
         };
         onLoadComplete = function(param1:Event):void
         {
            var _loc2_:Boolean = false;
            toggleLoaderListeners(loader,false);
            if(validateLoadedContentFunction != null)
            {
               _loc2_ = validateLoadedContentFunction(loader.content);
               if(_loc2_)
               {
                  loader.unloadAndStop();
                  loader = null;
                  loadLoadTrait(loadTrait,updateLoadTraitFunction,useCurrentSecurityDomain,false,null);
               }
               else
               {
                  loader.unloadAndStop();
                  loader = null;
                  updateLoadTraitFunction(loadTrait,LoadState.LOAD_ERROR);
                  loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,new MediaError(MediaErrorCodes.IO_ERROR)));
               }
            }
            else
            {
               updateLoadTraitFunction(loadTrait,LoadState.READY);
            }
         };
         onIOError = function(param1:IOErrorEvent, param2:String = null):void
         {
            toggleLoaderListeners(loader,false);
            loader = null;
            updateLoadTraitFunction(loadTrait,LoadState.LOAD_ERROR);
            loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,new MediaError(MediaErrorCodes.IO_ERROR,!!param1?param1.text:param2)));
         };
         onSecurityError = function(param1:SecurityErrorEvent, param2:String = null):void
         {
            toggleLoaderListeners(loader,false);
            loader = null;
            updateLoadTraitFunction(loadTrait,LoadState.LOAD_ERROR);
            loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,new MediaError(MediaErrorCodes.SECURITY_ERROR,!!param1?param1.text:param2)));
         };
         var loaderLoadTrait:LoaderLoadTrait = loadTrait as LoaderLoadTrait;
         loader = new Loader();
         loaderLoadTrait.loader = loader;
         updateLoadTraitFunction(loadTrait,LoadState.LOADING);
         var context:LoaderContext = new LoaderContext();
         var urlReq:URLRequest = new URLRequest((loadTrait.resource as URLResource).url.toString());
         context.checkPolicyFile = checkPolicyFile;
         if(useCurrentSecurityDomain && urlReq.url.search(/^file:\//i) == -1)
         {
            context.securityDomain = SecurityDomain.currentDomain;
         }
         if(validateLoadedContentFunction != null)
         {
            context.applicationDomain = new ApplicationDomain();
         }
         toggleLoaderListeners(loader,true);
         try
         {
            loader.load(urlReq,context);
            return;
         }
         catch(ioError:IOError)
         {
            onIOError(null,ioError.message);
            return;
         }
         catch(securityError:SecurityError)
         {
            onSecurityError(null,securityError.message);
            return;
         }
      }
      
      public static function unloadLoadTrait(param1:LoadTrait, param2:Function) : void
      {
         var _loc3_:LoaderLoadTrait = param1 as LoaderLoadTrait;
         param2(param1,LoadState.UNLOADING);
         _loc3_.loader.unloadAndStop();
         param2(param1,LoadState.UNINITIALIZED);
      }
   }
}
