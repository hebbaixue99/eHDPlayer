package org.osmf.player.elements.playlistClasses
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import org.osmf.elements.DurationElement;
   import org.osmf.elements.proxyClasses.LoadFromDocumentLoadTrait;
   import org.osmf.events.MediaError;
   import org.osmf.events.MediaErrorEvent;
   import org.osmf.media.DefaultMediaFactory;
   import org.osmf.media.MediaElement;
   import org.osmf.media.MediaFactory;
   import org.osmf.media.MediaResourceBase;
   import org.osmf.media.MediaTypeUtil;
   import org.osmf.media.URLResource;
   import org.osmf.player.elements.ErrorElement;
   import org.osmf.traits.LoadState;
   import org.osmf.traits.LoadTrait;
   import org.osmf.traits.LoaderBase;
   import org.osmf.utils.URL;
   
   public class PlaylistLoader extends LoaderBase
   {
      
      private static const PLAIN_TEXT_MIME_TYPE:String = "text/plain";
      
      private static const M3U_EXTENSION:String = "m3u";
       
      
      private var parser:PlaylistParser;
      
      private var factory:MediaFactory;
      
      private var errorElementConstructorFunction:Function;
      
      private var supportedMimeTypes:Vector.<String>;
      
      private var _playlistMetadata:PlaylistMetadata;
      
      private var _playlistElement:InnerPlaylistElement;
      
      public function PlaylistLoader(param1:MediaFactory = null, param2:Function = null, param3:Function = null)
      {
         this.supportedMimeTypes = new Vector.<String>();
         super();
         this.supportedMimeTypes.push(PLAIN_TEXT_MIME_TYPE);
         this.parser = new PlaylistParser(param2);
         this.factory = param1 || new DefaultMediaFactory();
         this.errorElementConstructorFunction = param3;
      }
      
      public function get playlistElement() : InnerPlaylistElement
      {
         return this._playlistElement;
      }
      
      public function get playlistMetadata() : PlaylistMetadata
      {
         return this._playlistMetadata;
      }
      
      override public function canHandleResource(param1:MediaResourceBase) : Boolean
      {
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
            _loc4_ = !!_loc4_?_loc4_.toLocaleLowerCase():null;
            return _loc4_ == M3U_EXTENSION;
         }
         return false;
      }
      
      override protected function executeLoad(param1:LoadTrait) : void
      {
         var playlistLoader:URLLoader = null;
         var onError:Function = null;
         var onComplete:Function = null;
         var loadTrait:LoadTrait = param1;
         onError = function(param1:ErrorEvent):void
         {
            playlistLoader.removeEventListener(Event.COMPLETE,onComplete);
            playlistLoader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            playlistLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
            updateLoadTrait(loadTrait,LoadState.LOAD_ERROR);
            loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,new MediaError(0,param1.text)));
         };
         onComplete = function(param1:Event):void
         {
            playlistLoader.removeEventListener(Event.COMPLETE,onComplete);
            playlistLoader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            playlistLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
            processPlaylistContent(param1.target.data,loadTrait);
         };
         updateLoadTrait(loadTrait,LoadState.LOADING);
         playlistLoader = new URLLoader(new URLRequest(URLResource(loadTrait.resource).url));
         playlistLoader.addEventListener(Event.COMPLETE,onComplete);
         playlistLoader.addEventListener(IOErrorEvent.IO_ERROR,onError);
         playlistLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
      }
      
      override protected function executeUnload(param1:LoadTrait) : void
      {
         updateLoadTrait(param1,LoadState.UNINITIALIZED);
      }
      
      function processPlaylistContent(param1:String, param2:LoadTrait) : void
      {
         var playlist:Vector.<MediaResourceBase> = null;
         var mediaElements:Vector.<MediaElement> = null;
         var firstMediaElement:MediaElement = null;
         var resource:MediaResourceBase = null;
         var mediaElement:MediaElement = null;
         var urlResource:URLResource = null;
         var contents:String = param1;
         var loadTrait:LoadTrait = param2;
         try
         {
            playlist = this.parser.parse(contents);
         }
         catch(parseError:Error)
         {
            updateLoadTrait(loadTrait,LoadState.LOAD_ERROR);
            loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,new MediaError(parseError.errorID,parseError.message)));
         }
         if(playlist != null && playlist.length > 0)
         {
            try
            {
               mediaElements = new Vector.<MediaElement>();
               this._playlistMetadata = new PlaylistMetadata();
               for each(resource in playlist)
               {
                  mediaElement = this.factory.createMediaElement(resource);
                  if(mediaElement == null)
                  {
                     urlResource = resource as URLResource;
                     mediaElement = new DurationElement(5,new ErrorElement("Playlist element failed playback:\n" + "Incompatible resource" + (!!urlResource?" : \'" + urlResource.url + "\'":".")));
                  }
                  firstMediaElement = firstMediaElement || mediaElement;
                  mediaElements.push(mediaElement);
                  this._playlistMetadata.addElement(mediaElement);
               }
               this._playlistMetadata.currentElement = firstMediaElement;
               this._playlistElement = new InnerPlaylistElement(this._playlistMetadata,this.errorElementConstructorFunction);
               LoadFromDocumentLoadTrait(loadTrait).mediaElement = this._playlistElement;
               dispatchEvent(new Event(Event.COMPLETE));
               updateLoadTrait(loadTrait,LoadState.READY);
               return;
            }
            catch(error:Error)
            {
               updateLoadTrait(loadTrait,LoadState.LOAD_ERROR);
               loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR,false,false,new MediaError(error.errorID,error.message)));
               return;
            }
         }
      }
   }
}
