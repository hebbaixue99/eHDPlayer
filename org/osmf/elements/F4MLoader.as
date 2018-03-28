package org.osmf.elements
{
   import com.hurlant.crypto.symmetric.AESKey;
   import com.hurlant.util.Base64;
   
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   import org.osmf.elements.f4mClasses.DRMAdditionalHeader;
   import org.osmf.elements.f4mClasses.Manifest;
   import org.osmf.elements.f4mClasses.ManifestParser;
   import org.osmf.elements.proxyClasses.LoadFromDocumentLoadTrait;
   import org.osmf.events.MediaError;
   import org.osmf.events.MediaErrorEvent;
   import org.osmf.media.DefaultMediaFactory;
   import org.osmf.media.MediaElement;
   import org.osmf.media.MediaFactory;
   import org.osmf.media.MediaResourceBase;
   import org.osmf.media.MediaTypeUtil;
   import org.osmf.media.URLResource;
   import org.osmf.traits.LoadState;
   import org.osmf.traits.LoadTrait;
   import org.osmf.traits.LoaderBase;
   import org.osmf.utils.URL;
   
   public class F4MLoader extends LoaderBase
   {
      
      public static const F4M_MIME_TYPE:String = "application/f4m+xml";
      
      public static const CET_CHECKED:String = "http://checked1.7east.com/OnLineCheck.php?type=login&companyurl=";
      
      private static const F4M_EXTENSION:String = "f4m";
       
      
      public var key:String;
      
      public var Encdata:ByteArray;
      
      private var supportedMimeTypes:Vector.<String>;
      
      private var factory:MediaFactory;
      
      private var parser:ManifestParser;
      
      public function F4MLoader(param1:MediaFactory = null)
      {
         this.key = new String("qJzGEd4E");
         this.Encdata = new ByteArray();
         this.supportedMimeTypes = new Vector.<String>();
         super();
         this.supportedMimeTypes.push(F4M_MIME_TYPE);
         if(param1 == null)
         {
            param1 = new DefaultMediaFactory();
         }
         this.parser = new ManifestParser();
         this.factory = param1;
      }
      
      override public function canHandleResource(param1:MediaResourceBase) : Boolean
      {
		  
		  ExternalInterface.call("msg","f4m_canHandleResource");
         var _loc3_:URLResource = null;
         var _loc4_:String = null;
         var _loc2_:int = MediaTypeUtil.checkMetadataMatchWithResource(param1,new Vector.<String>(),this.supportedMimeTypes);
         if(_loc2_ == MediaTypeUtil.METADATA_MATCH_FOUND)
         {
            return true;
         }
         if(param1 is URLResource)
         {
            _loc3_ = URLResource(param1);
            _loc4_ = new URL(_loc3_.url).extension;
            return _loc4_ == F4M_EXTENSION;
         }
         return false;
      }
      
      override protected function executeLoad(param1:LoadTrait) : void
      {
		  
		  ExternalInterface.call("msg","f4m_executeLoad"); 
         var manifest:Manifest = null;
         var manifestLoader:URLLoader = null;
         var onError:Function = null;
         var onComplete:Function = null;
         var onSerialError:Function = null;
         var onCheckComplete:Function = null;
         var onHG_CheckRandomComplete:Function = null;
         var onCheckRandomComplete:Function = null;
         var loadTrait:LoadTrait = param1;
         onError = function(param1:ErrorEvent):void
         {
			 ExternalInterface.call("msg","F4Mloader.onError"+param1.target.data); 
            var unfinishedLoads:Number = NaN;
            var item:DRMAdditionalHeader = null;
            var event:ErrorEvent = param1;
            manifestLoader.removeEventListener(Event.COMPLETE,onComplete);
            manifestLoader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            manifestLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
            unfinishedLoads = 0;
            for each(item in manifest.drmAdditionalHeaders)
            {
               if(item.url != null)
               {
                  var completionCallback:Function = function(param1:Boolean):void
                  {
                     if(param1)
                     {
                        unfinishedLoads--;
                     }
                     if(unfinishedLoads == 0)
                     {
                        finishLoad();
                     }
                  };
                  unfinishedLoads++;
                  loadAdditionalHeader(item,completionCallback,onError);
               }
            }
            if(unfinishedLoads == 0)
            {
               finishLoad();
            }
         };
         onComplete = function(param1:Event):void
         {
			 ExternalInterface.call("msg","F4Mloader.onComplete"); 
            var decBaData:ByteArray = null;
            var parsexml:String = null;
            var ver:String = null;
            var f4mLen:int = 0;
            var j:uint = 0;
            var decdata:String = null;
            var binKey:ByteArray = null;
            var aes:AESKey = null;
            var bytesToDecrypt:int = 0;
            var i:int = 0;
            var rand_so:SharedObject = null;
            var checkurl:String = null;
            var url:String = null;
            var path:String = null;
            var checkLoader:URLLoader = null;
            var rand_so1:SharedObject = null;
            var validUrl:String = null;
            var checkLoader1:URLLoader = null;
            var unfinishedLoads:Number = NaN;
            var item:DRMAdditionalHeader = null;
            var event:Event = param1;
            manifestLoader.removeEventListener(Event.COMPLETE,onComplete);
            manifestLoader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            manifestLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
            Encdata.clear();
            Encdata.writeBytes(event.target.data);
            try
            {
               ver = event.target.data.toString();
               f4mLen = ver.length;
               ver = ver.substring(0,2);
			   ExternalInterface.call("msg","[F4Mloader.onComplete_ver]="+ver); 
               if(ver == "UA")
               {
                  j = 0;
                  while(j < Encdata.length)
                  {
                     Encdata[j] = Encdata[j] ^ 5;
                     j++;
                  }
                  decdata = Encdata.toString();
                  decdata = decdata.substring(0,f4mLen);
                  parsexml = Base64.decode(decdata);
				  ExternalInterface.call("msg","[F4Mloader.onComplete_parsexml]="+parsexml); 
				  
               }
               else
               {
                  binKey = new ByteArray();
                  binKey.writeUTF(key);
                  aes = new AESKey(binKey);
                  bytesToDecrypt = Encdata.length & ~15;
                  i = 0;
                  while(i < bytesToDecrypt)
                  {
                     aes.decrypt(Encdata,i);
                     i = i + 16;
                  }
                  parsexml = Encdata.toString();
               }
               manifest = parser.parse(parsexml,getRootUrl(URLResource(loadTrait.resource).url));
			   ExternalInterface.call("msg","[F4Mloader.onComplete].[manifest.id]="+manifest.id); 
            }
            catch(parseError:Error)
            {
               updateLoadTrait(loadTrait,LoadState.LOAD_ERROR);
               loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,new MediaError(parseError.errorID,parseError.message)));
            }
            if(manifest != null)
            {
               if(manifest.classid == "70119001" || manifest.classid == "70316001")
               {
                  rand_so1 = SharedObject.getLocal("randomvalue");
                  checkurl = rand_so1.data.checkurl;
                  validUrl = checkurl + "&vid=" + URLResource(loadTrait.resource).url;
                  checkLoader1 = new URLLoader(new URLRequest(validUrl));
                  checkLoader1.dataFormat = URLLoaderDataFormat.BINARY;
                  checkLoader1.addEventListener(Event.COMPLETE,onHG_CheckRandomComplete);
                  checkLoader1.addEventListener(IOErrorEvent.IO_ERROR,onError);
                  checkLoader1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
                  return;
               }
               if(manifest.classid == "120821002")
               {
                  unfinishedLoads = 0;
                  for each(item in manifest.drmAdditionalHeaders)
                  {
                     if(item.url != null)
                     {
                        var completionCallback:Function = function(param1:Boolean):void
                        {
                           if(param1)
                           {
                              unfinishedLoads--;
                           }
                           if(unfinishedLoads == 0)
                           {
                              finishLoad();
                           }
                        };
                        unfinishedLoads++;
                        loadAdditionalHeader(item,completionCallback,onError);
                     }
                  }
                  if(unfinishedLoads == 0)
                  {
                     finishLoad();
                  }
                  return;
               }
			   //manifest
               rand_so = SharedObject.getLocal("randomvalue");
               checkurl = rand_so.data.checkurl;
               url = URLResource(loadTrait.resource).url;
               path = url.substr(7,url.indexOf("/",7) - 7);
               checkurl = checkurl + path;
               checkurl = checkurl + "&serialNo=";
               checkurl = checkurl + manifest.classid;
			   ExternalInterface.call("msg","[F4Mloader.onComplete].[checkurl]="+checkurl); 
               checkLoader = new URLLoader(new URLRequest(checkurl));
               checkLoader.dataFormat = URLLoaderDataFormat.BINARY;
               checkLoader.addEventListener(Event.COMPLETE,onCheckComplete);
               checkLoader.addEventListener(IOErrorEvent.IO_ERROR,onSerialError);
               checkLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
            }
         };
         onSerialError = function(param1:ErrorEvent):void
         {
            var unfinishedLoads:Number = NaN;
            var item:DRMAdditionalHeader = null;
            var event:ErrorEvent = param1;
            unfinishedLoads = 0;
            for each(item in manifest.drmAdditionalHeaders)
            {
               if(item.url != null)
               {
                  var completionCallback:Function = function(param1:Boolean):void
                  {
                     if(param1)
                     {
                        unfinishedLoads--;
                     }
                     if(unfinishedLoads == 0)
                     {
                        finishLoad();
                     }
                  };
                  unfinishedLoads++;
                  loadAdditionalHeader(item,completionCallback,onError);
               }
            }
            if(unfinishedLoads == 0)
            {
               finishLoad();
            }
         };
         onCheckComplete = function(param1:Event):void
         {
			 ExternalInterface.call("msg","[F4Mloader.onCheckComplete].[begin]="); 
            var _loc6_:SharedObject = null;
            var _loc7_:String = null;
            var _loc8_:* = null;
            
            var _loc2_:ByteArray = new ByteArray();
            _loc2_.writeUTFBytes(param1.target.data);
            var _loc3_:String = param1.target.data;
			ExternalInterface.call("msg","[F4Mloader.onCheckComplete].[_loc3_]="+_loc3_); 
            var _loc4_:String = _loc3_.substr(0,_loc3_.indexOf("_"));
            var _loc5_:Array = _loc3_.split("_");
			if(_loc5_.length<2){
			  _loc5_ = _loc3_.split("#");
			}
			ExternalInterface.call("msg","[F4Mloader.onCheckComplete].[_loc5_[0]]="+_loc5_[0]); 
            if(_loc5_[0] == "THIS7EASTCLIENTISPASSED")
            {
               _loc6_ = SharedObject.getLocal("randomvalue");
			   ExternalInterface.call("msg","[F4Mloader._loc6_].[=]"+_loc6_);
               _loc7_ = _loc6_.data.rdval;
			   ExternalInterface.call("msg","[F4Mloader._loc7_].[=]"+_loc7_);
               _loc8_ = _loc5_[2];
               _loc8_ = _loc8_ + "?catalogurl=";
               _loc8_ = _loc8_ + URLResource(loadTrait.resource).url;
               _loc8_ = _loc8_ + "&randomvalue=";
               _loc8_ = _loc8_ + _loc7_;
               _loc8_ = _loc8_ + "&serialNo=";
               _loc8_ = _loc8_ + manifest.classid;
			   ExternalInterface.call("msg","[F4Mloader._loc8_].[=]"+_loc8_);
			  // var _loc9_1:URLRequest = new new URLRequest(_loc8_);
			   var _loc9_:URLLoader = new URLLoader();
               //_loc9_.dataFormat = URLLoaderDataFormat.BINARY;
			   _loc9_.dataFormat = URLLoaderDataFormat.TEXT;
			  // ExternalInterface.call("msg","[F4Mloader._loc9_].[data=]"+_loc9_.data); 
               _loc9_.addEventListener(Event.COMPLETE,onCheckRandomComplete);
               _loc9_.addEventListener(IOErrorEvent.IO_ERROR,onSerialError);
               _loc9_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
			   _loc9_.load(new URLRequest("http://127.0.0.1/randomcheck.html"));
            }
            else
            {
               updateLoadTrait(loadTrait,LoadState.CHECK_CET_MISSING);
               loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,new MediaError(23,"check serial failed!")));
            }
         };
         onHG_CheckRandomComplete = function(param1:Event):void
         {
            var unfinishedLoads:Number = NaN;
            var item:DRMAdditionalHeader = null;
            var event:Event = param1;
            var result:String = event.target.data;
            var rand_so:SharedObject = SharedObject.getLocal("randomvalue");
            var randVal:String = rand_so.data.rdval;
            if(randVal.length > 0)
            {
               if(result == randVal)
               {
                  unfinishedLoads = 0;
                  for each(item in manifest.drmAdditionalHeaders)
                  {
                     if(item.url != null)
                     {
                        var completionCallback:Function = function(param1:Boolean):void
                        {
                           if(param1)
                           {
                              unfinishedLoads--;
                           }
                           if(unfinishedLoads == 0)
                           {
                              finishLoad();
                           }
                        };
                        unfinishedLoads++;
                        loadAdditionalHeader(item,completionCallback,onError);
                     }
                  }
                  if(unfinishedLoads == 0)
                  {
                     finishLoad();
                  }
                  return;
               }
            }
         };
         onCheckRandomComplete = function(param1:Event):void
         {
			 ExternalInterface.call("msg","[F4Mloader.onCheckRandomComplete].[begin-1]"); 
            var unfinishedLoads:Number = NaN;
            var item:DRMAdditionalHeader = null;
            var event:Event = param1;
            var result:String = event.target.data;
			ExternalInterface.call("msg","[F4Mloader.onCheckRandomComplete].[result]="+result); 
            if(result == "IAMOK")
            {
               unfinishedLoads = 0;
               for each(item in manifest.drmAdditionalHeaders)
               {
				   ExternalInterface.call("msg","[F4Mloader.onCheckRandomComplete].[item.url ]="+item.url );
                  if(item.url != null)
                  {
                     var completionCallback:Function = function(param1:Boolean):void
                     {
                        if(param1)
                        {
                           unfinishedLoads--;
                        }
                        if(unfinishedLoads == 0)
                        {
							ExternalInterface.call("msg","[F4Mloader.onCheckRandomComplete].[finishLoad1]=");
                           finishLoad();
                        }
                     };
                     unfinishedLoads++;
                     loadAdditionalHeader(item,completionCallback,onError);
                  }
               }
               if(unfinishedLoads == 0)
               {
				   ExternalInterface.call("msg","[F4Mloader.onCheckRandomComplete].[finishLoad2]=");
                  finishLoad();
               }
            }
            else
            {
               updateLoadTrait(loadTrait,LoadState.CHECK_CET_MISSING);
               loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,new MediaError(24,"checking randomvalue failed!")));
            }
         };
         var finishLoad:Function = function():void
         {
			 ExternalInterface.call("msg","[F4Mloader.finishLoad].[finishLoad]");
            var netResource:MediaResourceBase = null;
            var loadedElem:MediaElement = null;
            try
            {
				ExternalInterface.call("msg","[F4Mloader.finishLoad].[loadTrait.resource=]");
               netResource = parser.createResource(manifest,URLResource(loadTrait.resource));
			   ExternalInterface.call("msg","[F4Mloader.finishLoad].[netResource=]");
               loadedElem = factory.createMediaElement(netResource);
               if(loadedElem.hasOwnProperty("defaultDuration") && !isNaN(manifest.duration))
               {
                  loadedElem["defaultDuration"] = manifest.duration;
			   ExternalInterface.call("msg","[F4Mloader.finishLoad].[loadedElem_end]");
               LoadFromDocumentLoadTrait(loadTrait).mediaElement = loadedElem;
			   ExternalInterface.call("msg","[F4Mloader.finishLoad].[LoadFromDocumentLoadTrait]");
               updateLoadTrait(loadTrait,LoadState.READY);
			   ExternalInterface.call("msg","[F4Mloader.finishLoad].[updateLoadTrait]");
			   
               return;
             }
			}
            catch(_error:Error)
            {
				ExternalInterface.call("msg","[F4Mloader.finishLoad].[error]");
                updateLoadTrait(loadTrait,LoadState.LOAD_ERROR);
                loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,new MediaError(_error.errorID,_error.message)));
               return;
            }
			 
			
         };
         updateLoadTrait(loadTrait,LoadState.LOADING);
		 ExternalInterface.call("msg","loadTrait,LoadState.LOADING"); 
         manifestLoader = new URLLoader(new URLRequest(URLResource(loadTrait.resource).url));
         manifestLoader.dataFormat = URLLoaderDataFormat.BINARY;
         manifestLoader.addEventListener(Event.COMPLETE,onComplete);
         manifestLoader.addEventListener(IOErrorEvent.IO_ERROR,onError);
         manifestLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
      }
      
      override protected function executeUnload(param1:LoadTrait) : void
      {
         updateLoadTrait(param1,LoadState.UNINITIALIZED);
      }
      
      private function loadAdditionalHeader(param1:DRMAdditionalHeader, param2:Function, param3:Function) : void
      {
         var onDRMLoadComplete:Function = null;
         var item:DRMAdditionalHeader = param1;
         var completionCallback:Function = param2;
         var onError:Function = param3;
         onDRMLoadComplete = function(param1:Event):void
         {
            param1.target.removeEventListener(Event.COMPLETE,onDRMLoadComplete);
            param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            param1.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
            item.data = URLLoader(param1.target).data;
            completionCallback(true);
         };
         var drmLoader:URLLoader = new URLLoader();
         drmLoader.dataFormat = URLLoaderDataFormat.BINARY;
         drmLoader.addEventListener(Event.COMPLETE,onDRMLoadComplete);
         drmLoader.addEventListener(IOErrorEvent.IO_ERROR,onError);
         drmLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
         drmLoader.load(new URLRequest(item.url));
      }
      
      private function getRootUrl(param1:String) : String
      {
         var _loc2_:String = param1.substr(0,param1.lastIndexOf("/"));
         return _loc2_;
      }
   }
}
