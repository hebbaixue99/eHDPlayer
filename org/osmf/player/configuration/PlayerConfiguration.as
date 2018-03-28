package org.osmf.player.configuration
{
   import org.osmf.media.MediaResourceBase;
   
   public class PlayerConfiguration
   {
       
      
      public var id:String = "";
      
      public var src:String = "";
      
      public var usrinfo:String = "";
      
      public var viewInterval:uint = 0;
      
      public var viewColor:uint = 0;
      
      public var ctrlrights:String = "";
      
      public var ctrlserver:String = "http://checked1.7east.com/OnLineCheck.php?type=login&companyurl=";
      
      public var assetMetadata:Object;
      
      public var backgroundColor:uint = 0;
      
      public var tintColor:uint = 0;
      
      public var controlBarAutoHide:Boolean = true;
      
      public var controlBarMode:String = "docked";
      
      public var loop:Boolean = false;
      
      public var autoPlay:Boolean = false;
      
      public var scaleMode:String = "letterbox";
      
      public var skin:String = "";
      
      public var modifystudyrec:String = "";
      
      public var logoScope:String = "";
      
      public var verbose:Boolean = false;
      
      public var poster:String = "";
      
      public var playButtonOverlay:Boolean = true;
      
      public var bufferingOverlay:Boolean = true;
      
      public var highQualityThreshold:uint = 480;
      
      public var videoRenderingMode:uint;
      
      public var autoSwitchQuality:Boolean = false;
      
      public var optimizeInitialIndex:Boolean = true;
      
      public var optimizeBuffering:Boolean = true;
      
      public var streamType:String = "liveOrRecorded";
      
      public var urlIncludesFMSApplicationInstance:Boolean = false;
      
      public var initialBufferTime:Number = 15;
      
      public var expandedBufferTime:Number = 20;
      
      public var dynamicStreamBufferTime:Number = 0;
      
      public var minContinuousPlaybackTime:Number = 30;
      
      public var pluginConfigurations:Vector.<MediaResourceBase>;
      
      public function PlayerConfiguration()
      {
         this.assetMetadata = new Object();
         this.videoRenderingMode = VideoRenderingMode.AUTO;
         this.pluginConfigurations = new Vector.<MediaResourceBase>();
         super();
      }
   }
}
