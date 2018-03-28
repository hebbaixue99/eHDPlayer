package org.osmf.player.debug
{
   import org.osmf.elements.LightweightVideoElement;
   import org.osmf.events.DisplayObjectEvent;
   import org.osmf.events.DynamicStreamEvent;
   import org.osmf.events.MediaErrorEvent;
   import org.osmf.events.MediaPlayerCapabilityChangeEvent;
   import org.osmf.events.MediaPlayerStateChangeEvent;
   import org.osmf.media.MediaPlayerState;
   import org.osmf.player.chrome.utils.MediaElementUtils;
   import org.osmf.player.media.StrobeMediaPlayer;
   import org.osmf.traits.DynamicStreamTrait;
   import org.osmf.traits.MediaTraitType;
   
   public class DebugStrobeMediaPlayer extends StrobeMediaPlayer
   {
       
      
      private var bufferingStartTimestamp:Number;
      
      private var swichingStartTime:Date;
      
      private var width:Number;
      
      private var height:Number;
      
      private var previousIndex:uint;
      
      private var previousBitrate:Number;
      
      public function DebugStrobeMediaPlayer()
      {
         super();
         addEventListener(MediaPlayerCapabilityChangeEvent.IS_DYNAMIC_STREAM_CHANGE,logger.event);
         addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE,logger.event);
         addEventListener(DynamicStreamEvent.SWITCHING_CHANGE,logger.event);
         addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,logger.event);
         addEventListener(MediaErrorEvent.MEDIA_ERROR,logger.event);
         addEventListener(MediaPlayerCapabilityChangeEvent.TEMPORAL_CHANGE,logger.event);
         addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,this.onMediaPlayerStateChange);
         addEventListener(DynamicStreamEvent.SWITCHING_CHANGE,this.onSwitchingChange);
         addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE,this.onMediaSizeChange);
      }
      
      private function onMediaPlayerStateChange(param1:MediaPlayerStateChangeEvent) : void
      {
         var _loc2_:Number = NaN;
         if(param1.state == MediaPlayerState.PLAYING)
         {
            logger.qos.buffer.eventCount++;
            _loc2_ = new Date().time;
            logger.qos.buffer.previousWaitDuration = _loc2_ - this.bufferingStartTimestamp;
            logger.qos.buffer.totalWaitDuration = logger.qos.buffer.totalWaitDuration + logger.qos.buffer.previousWaitDuration;
            logger.qos.buffer.avgWaitDuration = logger.qos.buffer.totalWaitDuration / logger.qos.buffer.eventCount;
            logger.qos.buffer.maxWaitDuration = Math.max(logger.qos.buffer.maxWaitDuration,logger.qos.buffer.previousWaitDuration);
            this.bufferingStartTimestamp = NaN;
         }
         if(param1.state == MediaPlayerState.BUFFERING)
         {
            this.bufferingStartTimestamp = new Date().time;
         }
      }
      
      private function onMediaSizeChange(param1:DisplayObjectEvent) : void
      {
         this.width = param1.newWidth;
         this.height = param1.newHeight;
         logger.qos.rendering.width = param1.newWidth;
         logger.qos.rendering.height = param1.newHeight;
         logger.qos.rendering.aspectRatio = this.width / this.height;
         logger.qos.ds.currentVerticalResolution = this.height;
         var _loc2_:LightweightVideoElement = MediaElementUtils.getMediaElementParentOfType(media,LightweightVideoElement) as LightweightVideoElement;
         if(_loc2_ != null)
         {
            logger.qos.rendering.HD = param1.newHeight > highQualityThreshold;
            logger.qos.rendering.smoothing = _loc2_.smoothing;
            logger.qos.rendering.deblocking = _loc2_.deblocking == 0?"Lets the video compressor apply the deblocking filter as needed.":"Does not use a deblocking filter";
            if(isDynamicStream)
            {
               logger.qos.ds.index = currentDynamicStreamIndex;
               logger.qos.ds.numDynamicStreams = numDynamicStreams;
               logger.qos.ds.currentBitrate = getBitrateForDynamicStreamIndex(currentDynamicStreamIndex);
            }
         }
      }
      
      private function onSwitchingChange(param1:DynamicStreamEvent) : void
      {
         var _loc2_:DynamicStreamTrait = null;
         var _loc4_:int = 0;
         _loc2_ = media.getTrait(MediaTraitType.DYNAMIC_STREAM) as DynamicStreamTrait;
         var _loc3_:Date = new Date();
         var _loc5_:int = _loc2_.currentIndex;
         var _loc6_:Number = _loc2_.getBitrateForIndex(_loc5_);
         logger.qos.ds.index = _loc5_;
         logger.qos.ds.currentBitrate = _loc6_;
         if(param1.switching)
         {
            this.swichingStartTime = _loc3_;
            this.previousIndex = _loc2_.currentIndex;
            this.previousBitrate = _loc2_.getBitrateForIndex(_loc2_.currentIndex);
         }
         else
         {
            logger.qos.ds.previousSwitchDuration = new Date().time - this.swichingStartTime.time;
            logger.qos.ds.totalSwitchDuration = logger.qos.ds.totalSwitchDuration + logger.qos.ds.previousSwitchDuration;
            logger.qos.ds.dsSwitchEventCount++;
            logger.qos.ds.avgSwitchDuration = logger.qos.ds.totalSwitchDuration / logger.qos.ds.dsSwitchEventCount;
            logger.info("Switch complete. Previous (index, bitrate)=({0},{1}). Current (index, bitrate)=({2},{3})",this.previousIndex,this.previousBitrate,_loc5_,_loc6_);
         }
      }
   }
}
