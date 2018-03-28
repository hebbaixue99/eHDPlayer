package org.osmf.player.media
{
   import org.osmf.elements.DurationElement;
   import org.osmf.elements.VideoElement;
   import org.osmf.media.DefaultMediaFactory;
   import org.osmf.media.MediaElement;
   import org.osmf.media.MediaFactoryItem;
   import org.osmf.media.MediaResourceBase;
   import org.osmf.net.HTTPStreamingNetLoaderAdapter;
   import org.osmf.net.NetLoader;
   import org.osmf.net.PlaybackOptimizationManager;
   import org.osmf.net.RTMPDynamicStreamingNetLoaderAdapter;
   import org.osmf.net.StreamingURLResource;
   import org.osmf.player.chrome.ChromeProvider;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.configuration.PlayerConfiguration;
   import org.osmf.player.elements.ErrorElement;
   import org.osmf.player.elements.PlaylistElement;
   import org.osmf.player.elements.playlistClasses.PlaylistLoader;
   import org.osmf.player.errors.ErrorTranslator;
   
   public class StrobeMediaFactory extends DefaultMediaFactory
   {
       
      
      private var configuration:PlayerConfiguration;
      
      private var assetManager:AssetsManager;
      
      public function StrobeMediaFactory(param1:PlayerConfiguration)
      {
         var _loc2_:PlaybackOptimizationManager = null;
         super();
         this.configuration = param1;
         this.assetManager = ChromeProvider.getInstance().assetManager;
         addItem(new MediaFactoryItem("org.osmf.player.elements.PlaylistElement",new PlaylistLoader().canHandleResource,this.playlistElementConstructor));
         if(param1.optimizeBuffering || param1.optimizeInitialIndex)
         {
            _loc2_ = this.createPlaybackOptimizationManager(param1);
            this.addStrobeAdapterToItemById("org.osmf.elements.video.httpstreaming",this.createHTTPStreamingNetLoaderAdapter(_loc2_));
            this.addStrobeAdapterToItemById("org.osmf.elements.video.rtmpdynamicStreaming",this.createRTMPDynamicStreamingNetLoaderAdapter(_loc2_));
         }
      }
      
      protected function createPlaybackOptimizationManager(param1:PlayerConfiguration) : PlaybackOptimizationManager
      {
         return new PlaybackOptimizationManager(param1);
      }
      
      protected function createRTMPDynamicStreamingNetLoaderAdapter(param1:PlaybackOptimizationManager) : NetLoader
      {
         return new RTMPDynamicStreamingNetLoaderAdapter(param1);
      }
      
      private function addStrobeAdapterToItemById(param1:String, param2:NetLoader) : void
      {
         var id:String = param1;
         var netLoaderStrobeAdapter:NetLoader = param2;
         addItem(new MediaFactoryItem(id,netLoaderStrobeAdapter.canHandleResource,function():MediaElement
         {
            var _loc1_:* = new VideoElement(null,netLoaderStrobeAdapter);
            VideoElementRegistry.getInstance().register(_loc1_);
            return _loc1_;
         }));
      }
      
      private function playlistElementConstructor() : MediaElement
      {
         return new PlaylistElement(new PlaylistLoader(this,this.playlistLoaderResourceConstructor,this.playlistLoaderErrorElementConstructor));
      }
      
      private function playlistLoaderResourceConstructor(param1:String) : MediaResourceBase
      {
         return new StreamingURLResource(param1,this.configuration.streamType);
      }
      
      private function playlistLoaderErrorElementConstructor(param1:Error) : MediaElement
      {
         var _loc2_:String = null;
         if(this.configuration != null && this.configuration.verbose == false)
         {
            _loc2_ = ErrorTranslator.translate(param1).message;
         }
         else
         {
            _loc2_ = param1.message;
            if(param1.hasOwnProperty("detail"))
            {
               _loc2_ = _loc2_ + ("\n" + param1["detail"]);
            }
         }
         return new DurationElement(5,new ErrorElement("Playlist element failed playback:\n" + _loc2_));
      }
      
      protected function createHTTPStreamingNetLoaderAdapter(param1:PlaybackOptimizationManager) : NetLoader
      {
         return new HTTPStreamingNetLoaderAdapter(param1);
      }
   }
}
