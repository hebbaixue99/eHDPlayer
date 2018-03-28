package org.osmf.net
{
   class RunningAverage
   {
       
      
      private var previousTimestamp:Number = NaN;
      
      private var previousValue:Number = NaN;
      
      private var samples:Array;
      
      private var sampleCount:int;
      
      private var _average:Number;
      
      function RunningAverage(param1:int)
      {
         this.samples = new Array();
         super();
         this.sampleCount = param1;
      }
      
      public function get average() : Number
      {
         return this._average;
      }
      
      public function addSample(param1:Number) : void
      {
         if(isNaN(param1))
         {
            return;
         }
         this.samples.unshift(param1);
         if(this.samples.length > this.sampleCount)
         {
            this.samples.pop();
         }
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < this.samples.length)
         {
            _loc2_ = _loc2_ + this.samples[_loc3_];
            _loc3_++;
         }
         this._average = _loc2_ / this.samples.length;
      }
      
      public function addDeltaTimeRatioSample(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = param2 - this.previousTimestamp;
         if(_loc3_ > 0)
         {
            this.addSample((param1 - this.previousValue) / _loc3_);
         }
         this.previousTimestamp = param2;
         this.previousValue = param1;
      }
      
      public function clearSamples() : void
      {
         this.samples = new Array();
      }
   }
}
