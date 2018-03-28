package org.osmf.player.debug.qos
{
   public class QoSDashboard extends IndicatorsBase
   {
       
      
      public var duration:Number;
      
      public var currentTime:Number;
      
      public var downloadRatio:Number;
      
      public var downloadKbps:Number;
      
      public var playbackKbps:Number;
      
      public var lsoDownloadKbps:Number;
      
      public var memory:Number;
      
      public var droppedFrames:uint;
      
      public var avgDroppedFPS:Number;
      
      public var streamType:String;
      
      public var buffer:BufferIndicators;
      
      public var rendering:RenderingIndicators;
      
      public var ds:DynamicStreamingIndicators;
      
      public function QoSDashboard()
      {
         this.buffer = new BufferIndicators();
         this.rendering = new RenderingIndicators();
         this.ds = new DynamicStreamingIndicators();
         super();
      }
      
      override protected function getOrderedFieldList() : Array
      {
         return ["duration","currentTime","downloadRatio","downloadKbps","playbackKbps","lsoDownloadKbps","memory","droppedFrames","avgDroppedFPS"];
      }
   }
}
