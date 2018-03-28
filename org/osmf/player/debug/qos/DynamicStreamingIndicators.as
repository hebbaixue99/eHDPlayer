package org.osmf.player.debug.qos
{
   public class DynamicStreamingIndicators extends IndicatorsBase
   {
       
      
      public var index:uint;
      
      public var numDynamicStreams:uint;
      
      public var currentBitrate:uint;
      
      public var previousSwitchDuration:Number;
      
      public var totalSwitchDuration:Number = 0;
      
      public var dsSwitchEventCount:uint;
      
      public var avgSwitchDuration:Number;
      
      public var currentVerticalResolution:Number;
      
      public var bestVerticalResolution:Number;
      
      public var bestHorizontatalResolution:Number;
      
      public var targetIndex:int;
      
      public var targetBitrate:Number;
      
      public function DynamicStreamingIndicators()
      {
         super();
      }
      
      override protected function getOrderedFieldList() : Array
      {
         return ["index","numDynamicStreams","currentBitrate","previousSwitchDuration","totalSwitchDuration","dsSwitchEventCount","avgSwitchDuration","currentVerticalResolution","bestVerticalResolution","bestHorizontatalResolution"];
      }
   }
}
