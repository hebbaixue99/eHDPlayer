package org.osmf.net
{
   import flash.events.NetStatusEvent;
   import flash.net.NetStream;
   import flash.net.SharedObject;
   import flash.system.System;
   import org.osmf.logging.Log;
   import org.osmf.player.debug.StrobeLogger;
   
   public class PlaybackOptimizationMetrics extends NetStreamMetricsBase
   {
      
      public static const ID:String = "PlaybackOptimizationMetrics";
      
      public static const KBITSPS_BYTESTPS_RATIO:uint = 128;
      
      private static const DEFAULT_AVG_MAX_BYTES_SAMPLE_SIZE:Number = 50;
       
      
      private var _duration:Number;
      
      private var avgPlaybackBytesPerSecond:RunningAverage;
      
      private var avgMaxBytesPerSecond:RunningAverage;
      
      private var previousMeasurementTimestamp:Number = NaN;
      
      private const STROBE_LSO_NAMESPACE:String = "org.osmf.strobemediaplayback.lso";
      
      private var logger:StrobeLogger;
      
      public function PlaybackOptimizationMetrics(param1:NetStream)
      {
         var onMetaData:Function = null;
         var onNetStatus:Function = null;
         var netStream:NetStream = param1;
         this.avgPlaybackBytesPerSecond = new RunningAverage(DEFAULT_AVG_MAX_BYTES_SAMPLE_SIZE);
         this.avgMaxBytesPerSecond = new RunningAverage(DEFAULT_AVG_MAX_BYTES_SAMPLE_SIZE);
         this.logger = Log.getLogger("StrobeMediaPlayback") as StrobeLogger;
         onMetaData = function(param1:Object):void
         {
            NetClient(netStream.client).removeHandler(NetStreamCodes.ON_META_DATA,onMetaData);
            averagePlaybackBytesPerSecond = (param1.audiodatarate + param1.videodatarate) * KBITSPS_BYTESTPS_RATIO;
            duration = param1.duration;
         };
         onNetStatus = function(param1:NetStatusEvent):void
         {
            var sharedObject:SharedObject = null;
            var event:NetStatusEvent = param1;
            if(event.info.code == NetStreamCodes.NETSTREAM_PLAY_STOP || event.info.code == NetStreamCodes.NETSTREAM_PAUSE_NOTIFY)
            {
               if(averageDownloadBytesPerSecond > 0)
               {
                  sharedObject = SharedObject.getLocal(STROBE_LSO_NAMESPACE);
                  sharedObject.data.downloadKbitsPerSecond = Math.round(averageDownloadBytesPerSecond / PlaybackOptimizationMetrics.KBITSPS_BYTESTPS_RATIO);
                  try
                  {
                     sharedObject.flush(10000);
                     logger.qos.lsoDownloadKbps = sharedObject.data.downloadKbitsPerSecond;
                     return;
                  }
                  catch(ingore:Error)
                  {
                     return;
                  }
               }
            }
         };
         super(netStream);
         NetClient(netStream.client).addHandler(NetStreamCodes.ON_META_DATA,onMetaData);
         var sharedObject:SharedObject = SharedObject.getLocal(this.STROBE_LSO_NAMESPACE);
         this.averageDownloadBytesPerSecond = sharedObject.data.downloadKbitsPerSecond * PlaybackOptimizationMetrics.KBITSPS_BYTESTPS_RATIO;
         this.logger.qos.lsoDownloadKbps = sharedObject.data.downloadKbitsPerSecond;
         netStream.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function set duration(param1:Number) : void
      {
         this._duration = param1;
      }
      
      public function get downloadRatio() : Number
      {
         return this.averageDownloadBytesPerSecond / this.averagePlaybackBytesPerSecond;
      }
      
      public function get averagePlaybackBytesPerSecond() : Number
      {
         return this.avgPlaybackBytesPerSecond.average;
      }
      
      public function set averagePlaybackBytesPerSecond(param1:Number) : void
      {
         this.avgPlaybackBytesPerSecond.clearSamples();
         this.avgPlaybackBytesPerSecond.addSample(param1);
      }
      
      public function get averageDownloadBytesPerSecond() : Number
      {
         return this.avgMaxBytesPerSecond.average;
      }
      
      public function set averageDownloadBytesPerSecond(param1:Number) : void
      {
         this.avgPlaybackBytesPerSecond.clearSamples();
         return this.avgMaxBytesPerSecond.addSample(param1);
      }
      
      public function get averageDownloadKbps() : Number
      {
         return this.averageDownloadBytesPerSecond / 128;
      }
      
      public function get averagePlaybackKbps() : Number
      {
         return this.averagePlaybackBytesPerSecond / 128;
      }
      
      override protected function calculateMetrics() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         super.calculateMetrics();
         if(netStream.hasOwnProperty("downloadRatio"))
         {
            if(netStream.info.videoBufferLength > 0)
            {
               this.avgPlaybackBytesPerSecond.addSample(netStream.info.videoBufferByteLength / netStream.info.videoBufferLength);
            }
            _loc2_ = netStream["downloadRatio"] * netStream.info.videoBufferByteLength / netStream.info.videoBufferLength;
            if(_loc2_ > 0)
            {
               this.avgMaxBytesPerSecond.addSample(_loc2_);
            }
         }
         else if(netStream.bytesLoaded > 0)
         {
            if(netStream.bytesLoaded < netStream.bytesTotal)
            {
               if(netStream.info.videoBufferLength > 0)
               {
                  this.avgPlaybackBytesPerSecond.addSample(netStream.info.videoBufferByteLength / netStream.info.videoBufferLength);
               }
               this.avgMaxBytesPerSecond.addDeltaTimeRatioSample(netStream.bytesLoaded,new Date().time / 1000);
            }
         }
         else
         {
            _loc1_ = netStream.info.playbackBytesPerSecond;
            _loc2_ = netStream.info.maxBytesPerSecond;
            if(_loc1_ > 0)
            {
               this.avgPlaybackBytesPerSecond.addSample(_loc1_);
            }
            if(_loc2_ > 0)
            {
               this.avgMaxBytesPerSecond.addSample(_loc2_);
            }
         }
         this.logger.qos.duration = this._duration;
         this.logger.qos.currentTime = netStream.time;
         this.logger.qos.buffer.length = netStream.bufferLength;
         this.logger.qos.buffer.time = netStream.bufferTime;
         this.logger.qos.buffer.percentage = netStream.bufferLength / netStream.bufferTime * 100;
         this.logger.qos.memory = System.totalMemory / 1048576;
         this.logger.qos.downloadRatio = this.downloadRatio;
         this.logger.qos.playbackKbps = this.averagePlaybackBytesPerSecond / 128;
         this.logger.qos.downloadKbps = this.averageDownloadBytesPerSecond / 128;
         this.logger.qos.avgDroppedFPS = averageDroppedFPS;
         this.logger.qos.droppedFrames = netStream.info.droppedFrames;
         this.logger.trackObject("NetStream",netStream);
         this.logger.trackObject("NetStreamInfo",netStream.info);
         this.logger.trackObject("PlaybackOptimizationMetrics",this);
      }
   }
}
