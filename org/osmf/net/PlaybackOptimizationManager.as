package org.osmf.net
{
   import flash.net.NetStream;
   import org.osmf.elements.VideoElement;
   import org.osmf.logging.Log;
   import org.osmf.player.chrome.utils.MediaElementUtils;
   import org.osmf.player.configuration.PlayerConfiguration;
   import org.osmf.player.debug.StrobeLogger;
   import org.osmf.player.media.VideoElementRegistry;
   
   public class PlaybackOptimizationManager
   {
       
      
      private const bitrateMultiplier:Number = 1.15;
      
      private var configuration:PlayerConfiguration;
      
      private var _downloadBytesPerSecond:Number = NaN;
      
      protected var logger:StrobeLogger;
      
      public function PlaybackOptimizationManager(param1:PlayerConfiguration)
      {
         this.logger = Log.getLogger("StrobeMediaPlayback") as StrobeLogger;
         super();
         this.configuration = param1;
      }
      
      public function get downloadBytesPerSecond() : Number
      {
         return this._downloadBytesPerSecond;
      }
      
      public function set downloadBytesPerSecond(param1:Number) : void
      {
         this._downloadBytesPerSecond = param1;
      }
      
      public function optimizePlayback(param1:NetStream, param2:DynamicStreamingResource) : void
      {
         var _loc5_:String = null;
         var _loc3_:VideoElement = VideoElementRegistry.getInstance().retriveMediaElementByNetStream(param1);
         if(_loc3_ != null)
         {
            _loc5_ = MediaElementUtils.getStreamType(_loc3_);
            this.logger.qos.streamType = _loc5_;
            if(param2 == null && (_loc5_ == StreamType.LIVE || _loc5_ == StreamType.DVR))
            {
               this.logger.info("The buffer is not optimized for the streamType={0}.",_loc5_);
               return;
            }
            if(param2 != null)
            {
               param2.addMetadataValue("streamType",_loc5_);
            }
         }
         var _loc4_:PlaybackOptimizationMetrics = this.createPlaybackOptimizationMetrics(param1);
         if(!isNaN(this.downloadBytesPerSecond))
         {
            _loc4_.averageDownloadBytesPerSecond = this.downloadBytesPerSecond;
         }
         else
         {
            this.downloadBytesPerSecond = _loc4_.averageDownloadBytesPerSecond;
         }
         if(param2 == null)
         {
            if(this.configuration.optimizeBuffering)
            {
               this.createBufferManager(param1,_loc4_);
            }
         }
         else
         {
            if(this.configuration.optimizeBuffering && this.configuration.dynamicStreamBufferTime > 0)
            {
               param1.bufferTime = this.configuration.dynamicStreamBufferTime;
            }
            if(this.configuration.optimizeInitialIndex)
            {
               if(!isNaN(this.downloadBytesPerSecond))
               {
                  this.updateInitialIndex(param2,this.downloadBytesPerSecond);
               }
            }
         }
      }
      
      protected function createPlaybackOptimizationMetrics(param1:NetStream) : PlaybackOptimizationMetrics
      {
         return new PlaybackOptimizationMetrics(param1);
      }
      
      protected function createBufferManager(param1:NetStream, param2:PlaybackOptimizationMetrics) : NetStreamBufferManagerBase
      {
         var _loc3_:NetStreamBufferManagerBase = null;
         _loc3_ = new NetStreamBufferManagerBase(param1,param2);
         _loc3_.initialBufferTime = this.configuration.initialBufferTime;
         _loc3_.expandedBufferTime = this.configuration.expandedBufferTime;
         _loc3_.minContinuousTime = this.configuration.minContinuousPlaybackTime;
         return _loc3_;
      }
      
      protected function updateInitialIndex(param1:DynamicStreamingResource, param2:Number) : void
      {
         var _loc5_:DynamicStreamingItem = null;
         var _loc3_:int = -1;
         var _loc4_:Number = param2 / PlaybackOptimizationMetrics.KBITSPS_BYTESTPS_RATIO;
         for each(_loc5_ in param1.streamItems)
         {
            if(_loc5_.bitrate <= _loc4_)
            {
               _loc3_++;
            }
         }
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         this.logger.info("Setting the initial index to: " + _loc3_);
         param1.initialIndex = _loc3_;
      }
   }
}
