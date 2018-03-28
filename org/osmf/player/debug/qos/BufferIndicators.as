package org.osmf.player.debug.qos
{
   public class BufferIndicators extends IndicatorsBase
   {
       
      
      public var percentage:Number = 0;
      
      public var time:Number = 0;
      
      public var length:Number = 0;
      
      public var eventCount:uint = 0;
      
      public var avgWaitDuration:Number = 0;
      
      public var totalWaitDuration:Number = 0;
      
      public var previousWaitDuration:Number = 0;
      
      public var maxWaitDuration:Number = 0;
      
      public function BufferIndicators()
      {
         super();
      }
      
      override protected function getOrderedFieldList() : Array
      {
         return ["percentage","time","length","eventCount","avgWaitDuration","totalWaitDuration","previousWaitDuration","maxWaitDuration"];
      }
   }
}
