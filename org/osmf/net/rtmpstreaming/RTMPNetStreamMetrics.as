package org.osmf.net.rtmpstreaming
{
   import flash.net.NetStream;
   import org.osmf.net.NetStreamMetricsBase;
   import org.osmf.net.StreamType;
   
   public class RTMPNetStreamMetrics extends NetStreamMetricsBase
   {
      
      private static const DEFAULT_AVG_MAX_BYTES_SAMPLE_SIZE:Number = 50;
       
      
      private var _averageMaxBytesPerSecondArray:Array;
      
      private var _averageMaxBytesPerSecond:Number;
      
      public function RTMPNetStreamMetrics(param1:NetStream)
      {
         super(param1);
         this._averageMaxBytesPerSecondArray = new Array();
      }
      
      public function get averageMaxBytesPerSecond() : Number
      {
         return this._averageMaxBytesPerSecond;
      }
      
      override protected function calculateMetrics() : void
      {
         var maxBytesPerSecond:Number = NaN;
         var totalMaxBytesPerSecond:Number = NaN;
         var peakMaxBytesPerSecond:Number = NaN;
         var b:uint = 0;
         super.calculateMetrics();
         try
         {
            maxBytesPerSecond = netStream.info.maxBytesPerSecond;
            this._averageMaxBytesPerSecondArray.unshift(maxBytesPerSecond);
            if(this._averageMaxBytesPerSecondArray.length > DEFAULT_AVG_MAX_BYTES_SAMPLE_SIZE)
            {
               this._averageMaxBytesPerSecondArray.pop();
            }
            totalMaxBytesPerSecond = 0;
            peakMaxBytesPerSecond = 0;
            b = 0;
            while(b < this._averageMaxBytesPerSecondArray.length)
            {
               totalMaxBytesPerSecond = totalMaxBytesPerSecond + this._averageMaxBytesPerSecondArray[b];
               peakMaxBytesPerSecond = this._averageMaxBytesPerSecondArray[b] > peakMaxBytesPerSecond?Number(this._averageMaxBytesPerSecondArray[b]):Number(peakMaxBytesPerSecond);
               b++;
            }
            this._averageMaxBytesPerSecond = this._averageMaxBytesPerSecondArray.length < DEFAULT_AVG_MAX_BYTES_SAMPLE_SIZE?Number(0):!!this.isLive?Number(peakMaxBytesPerSecond):Number(totalMaxBytesPerSecond / this._averageMaxBytesPerSecondArray.length);
            return;
         }
         catch(error:Error)
         {
            throw error;
         }
      }
      
      private function get isLive() : Boolean
      {
         return resource && resource.streamType == StreamType.LIVE;
      }
   }
}
