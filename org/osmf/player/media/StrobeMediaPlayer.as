package org.osmf.player.media
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import org.osmf.elements.LightweightVideoElement;
   import org.osmf.events.DisplayObjectEvent;
   import org.osmf.events.MediaElementChangeEvent;
   import org.osmf.events.MediaPlayerCapabilityChangeEvent;
   import org.osmf.events.MediaPlayerStateChangeEvent;
   import org.osmf.events.SeekEvent;
   import org.osmf.logging.Log;
   import org.osmf.media.MediaElement;
   import org.osmf.media.MediaPlayer;
   import org.osmf.media.MediaPlayerState;
   import org.osmf.net.DynamicStreamingItem;
   import org.osmf.net.DynamicStreamingResource;
   import org.osmf.net.StreamType;
   import org.osmf.player.chrome.utils.MediaElementUtils;
   import org.osmf.player.debug.StrobeLogger;
   import org.osmf.player.metadata.PlayerMetadata;
   import org.osmf.player.utils.VideoRenderingUtils;
   import org.osmf.traits.DVRTrait;
   import org.osmf.traits.MediaTraitType;
   
   public class StrobeMediaPlayer extends MediaPlayer
   {
       
      
      public var highQualityThreshold:uint = 480;
      
      public var videoRenderingMode:uint = 4;
      
      public var autoSwitchQuality:Boolean = true;
      
      private var _isDVRLive:Boolean;
      
      private var _streamType:String;
      
      private var fullScreenVideoWidth:uint = 0;
      
      private var fullScreenVideoHeight:uint = 0;
      
      protected var logger:StrobeLogger;
      
      public function StrobeMediaPlayer(param1:MediaElement = null)
      {
         this.logger = Log.getLogger("StrobeMediaPlayback") as StrobeLogger;
         super(param1);
         addEventListener(MediaPlayerCapabilityChangeEvent.IS_DYNAMIC_STREAM_CHANGE,this.onIsDynamicStreamChange);
         addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE,this.onMediaSizeChange);
         addEventListener(DisplayObjectEvent.DISPLAY_OBJECT_CHANGE,this.onDisplayObjectChange);
         addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE,this.onMediaPlayerStateChange);
         addEventListener(MediaElementChangeEvent.MEDIA_ELEMENT_CHANGE,this.onMediaElementChangeEvent);
      }
      
      public function get isDVRRecording() : Boolean
      {
         return !!media.hasTrait(MediaTraitType.DVR)?Boolean((media.getTrait(MediaTraitType.DVR) as DVRTrait).isRecording):false;
      }
      
      public function get isDVRLive() : Boolean
      {
         return this._isDVRLive;
      }
      
      public function set isDVRLive(param1:Boolean) : void
      {
         this._isDVRLive = param1;
      }
      
      public function get isLive() : Boolean
      {
         if(this.streamType == StreamType.LIVE)
         {
            return true;
         }
         if(this.streamType == StreamType.DVR)
         {
            return this.isDVRLive;
         }
         return false;
      }
      
      public function get streamType() : String
      {
         return this._streamType;
      }
      
      public function set streamType(param1:String) : void
      {
         this._streamType = param1;
      }
      
      public function getFullScreenSourceRect(param1:int, param2:int) : Rectangle
      {
         var _loc3_:Rectangle = null;
         if(this.fullScreenVideoHeight > this.highQualityThreshold && this.fullScreenVideoWidth > 0)
         {
            _loc3_ = VideoRenderingUtils.computeOptimalFullScreenSourceRect(param1,param2,this.fullScreenVideoWidth,this.fullScreenVideoHeight);
         }
         return _loc3_;
      }
      
      public function seekUntilSuccess(param1:Number, param2:uint = 10) : void
      {
         var repeatCount:uint = 0;
         var workarroundTimer:Timer = null;
         var position:Number = param1;
         var maxRepeatCount:uint = param2;
         repeatCount = 0;
         workarroundTimer = new Timer(2000,1);
         workarroundTimer.addEventListener(TimerEvent.TIMER,function(param1:Event):void
         {
            if(canSeek)
            {
               repeatCount++;
               if(repeatCount < maxRepeatCount)
               {
                  seek(position);
               }
            }
         });
         addEventListener(SeekEvent.SEEKING_CHANGE,function(param1:SeekEvent):void
         {
            if(param1.seeking == false)
            {
               removeEventListener(param1.type,arguments.callee);
               if(workarroundTimer != null)
               {
                  workarroundTimer.stop();
                  workarroundTimer = null;
               }
            }
            else if(workarroundTimer != null)
            {
               workarroundTimer.start();
            }
         });
         seek(position);
      }
      
      public function snapToLive() : Boolean
      {
         var _loc1_:Number = NaN;
         if(this.isDVRRecording == false)
         {
            return false;
         }
         if(!playing)
         {
            play();
         }
         if(canSeek)
         {
            _loc1_ = Math.max(0,duration - bufferTime - 2);
            if(canSeekTo(_loc1_))
            {
               this.seekUntilSuccess(_loc1_);
               this.isDVRLive = true;
               return true;
            }
         }
         return false;
      }
      
      private function onMediaElementChangeEvent(param1:MediaElementChangeEvent) : void
      {
         var _loc2_:PlayerMetadata = null;
         if(media != null)
         {
            _loc2_ = new PlayerMetadata();
            _loc2_.mediaPlayer = this;
            media.metadata.addValue(PlayerMetadata.ID,_loc2_);
         }
      }
      
      private function onMediaPlayerStateChange(param1:MediaPlayerStateChangeEvent) : void
      {
         if(param1.state == MediaPlayerState.PLAYING)
         {
            if(isDynamicStream && autoDynamicStreamSwitch != this.autoSwitchQuality)
            {
               autoDynamicStreamSwitch = this.autoSwitchQuality;
            }
         }
      }
      
      private function onMediaSizeChange(param1:DisplayObjectEvent) : void
      {
         var _loc2_:LightweightVideoElement = null;
         if(!isDynamicStream && param1.newWidth > 0 && param1.newHeight > 0)
         {
            this.fullScreenVideoWidth = param1.newWidth;
            this.fullScreenVideoHeight = param1.newHeight;
         }
         if(this.fullScreenVideoWidth > 0 && this.fullScreenVideoHeight > 0)
         {
            _loc2_ = MediaElementUtils.getMediaElementParentOfType(media,LightweightVideoElement) as LightweightVideoElement;
            if(_loc2_ != null)
            {
               if(isDynamicStream && this.fullScreenVideoHeight > param1.newHeight)
               {
                  _loc2_.smoothing = true;
                  _loc2_.deblocking = 0;
                  this.logger.info("Enabling smoothing/deblocking since the current resolution is lower then the best vertical resolution for this DynamicStream:" + this.fullScreenVideoHeight + "p");
               }
               else
               {
                  _loc2_.smoothing = VideoRenderingUtils.determineSmoothing(this.videoRenderingMode,param1.newHeight > this.highQualityThreshold);
                  _loc2_.deblocking = VideoRenderingUtils.determineDeblocking(this.videoRenderingMode,param1.newHeight > this.highQualityThreshold);
                  this.logger.info("Updating smoothing & deblocking settings. smoothing=" + _loc2_.smoothing + " deblocking=" + _loc2_.deblocking);
               }
            }
            else if(isDynamicStream && currentDynamicStreamIndex == maxAllowedDynamicStreamIndex)
            {
               this.fullScreenVideoWidth = param1.newWidth;
               this.fullScreenVideoHeight = param1.newHeight;
            }
         }
      }
      
      private function onDisplayObjectChange(param1:Event) : void
      {
         var _loc3_:PlayerMetadata = null;
         var _loc2_:String = MediaElementUtils.getStreamType(media);
         if(_loc2_ != this.streamType)
         {
            this.streamType = _loc2_;
            this.logger.qos.streamType = this.streamType;
            _loc3_ = new PlayerMetadata();
            _loc3_.mediaPlayer = this;
            media.metadata.addValue(PlayerMetadata.ID,_loc3_);
         }
      }
      
      private function onIsDynamicStreamChange(param1:Event) : void
      {
         var _loc2_:DynamicStreamingResource = null;
         var _loc3_:DynamicStreamingItem = null;
         if(isDynamicStream)
         {
            this.autoDynamicStreamSwitch = false;
            _loc2_ = MediaElementUtils.getResourceFromParentOfType(media,DynamicStreamingResource) as DynamicStreamingResource;
            if(_loc2_ != null)
            {
               _loc3_ = DynamicStreamingItem(_loc2_.streamItems[_loc2_.streamItems.length - 1]);
               this.fullScreenVideoWidth = _loc3_.width;
               this.fullScreenVideoHeight = _loc3_.height;
               this.logger.qos.ds.bestHorizontatalResolution = this.fullScreenVideoWidth;
               this.logger.qos.ds.bestVerticalResolution = this.fullScreenVideoHeight;
            }
         }
      }
   }
}
