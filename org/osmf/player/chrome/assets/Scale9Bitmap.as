package org.osmf.player.chrome.assets
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class Scale9Bitmap extends Bitmap
   {
       
      
      private var sourceData:BitmapData;
      
      private var scale9:Rectangle;
      
      public function Scale9Bitmap(param1:Bitmap, param2:Rectangle)
      {
         this.scale9 = param2;
         this.sourceData = param1.bitmapData.clone();
         super(param1.bitmapData.clone(),param1.pixelSnapping,param1.smoothing);
      }
      
      override public function set width(param1:Number) : void
      {
         this.apply9Scale(param1,height);
      }
      
      override public function set height(param1:Number) : void
      {
         this.apply9Scale(width,param1);
      }
      
      private function apply9Scale(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Matrix = null;
         var _loc8_:Rectangle = null;
         if(bitmapData)
         {
            bitmapData.dispose();
         }
         if(param1 && param2 && (param1 != this.sourceData.width || param2 != this.sourceData.height))
         {
            bitmapData = new BitmapData(param1,param2,true,0);
            _loc3_ = this.sourceData.width;
            _loc4_ = this.sourceData.height;
            _loc5_ = _loc4_ - this.scale9.y - this.scale9.height;
            _loc6_ = _loc3_ - this.scale9.x - this.scale9.width;
            _loc7_ = new Matrix();
            _loc8_ = new Rectangle();
            _loc8_ = new Rectangle(0,0,this.scale9.x,this.scale9.y);
            bitmapData.draw(this.sourceData,_loc7_,null,null,_loc8_,smoothing);
            _loc7_.tx = param1 - _loc3_;
            _loc8_ = new Rectangle(param1 - _loc6_,0,this.scale9.x,this.scale9.y);
            bitmapData.draw(this.sourceData,_loc7_,null,null,_loc8_,smoothing);
            _loc7_.ty = param2 - _loc4_;
            _loc8_ = new Rectangle(param1 - _loc6_,param2 - _loc5_,this.scale9.x,_loc6_);
            bitmapData.draw(this.sourceData,_loc7_,null,null,_loc8_,smoothing);
            _loc7_.tx = 0;
            _loc8_ = new Rectangle(0,param2 - _loc5_,this.scale9.x,_loc5_);
            bitmapData.draw(this.sourceData,_loc7_,null,null,_loc8_,smoothing);
            _loc7_.identity();
            _loc7_.a = (param1 - this.scale9.x - _loc5_) / this.scale9.width;
            _loc7_.tx = this.scale9.x - this.scale9.x * _loc7_.a;
            _loc8_ = new Rectangle(this.scale9.x,0,this.scale9.width * _loc7_.a,this.scale9.y);
            bitmapData.draw(this.sourceData,_loc7_,null,null,_loc8_,smoothing);
            _loc7_.ty = param2 - _loc4_;
            _loc8_ = new Rectangle(this.scale9.x,param2 - _loc5_,this.scale9.width * _loc7_.a,_loc6_);
            bitmapData.draw(this.sourceData,_loc7_,null,null,_loc8_,smoothing);
            _loc7_.d = (param2 - this.scale9.y - _loc6_) / this.scale9.height;
            _loc7_.ty = this.scale9.y - this.scale9.y * _loc7_.d;
            _loc8_ = new Rectangle(this.scale9.x,this.scale9.y,this.scale9.width * _loc7_.a,this.scale9.height * _loc7_.d);
            bitmapData.draw(this.sourceData,_loc7_,null,null,_loc8_,smoothing);
            _loc7_.identity();
            _loc7_.d = (param2 - this.scale9.y - _loc6_) / this.scale9.height;
            _loc7_.ty = this.scale9.y - this.scale9.y * _loc7_.d;
            _loc8_ = new Rectangle(0,this.scale9.y,this.scale9.x,this.scale9.height * _loc7_.d);
            bitmapData.draw(this.sourceData,_loc7_,null,null,_loc8_,smoothing);
            _loc7_.tx = param1 - _loc3_;
            _loc8_ = new Rectangle(param1 - _loc5_,this.scale9.y,_loc5_,this.scale9.height * _loc7_.d);
            bitmapData.draw(this.sourceData,_loc7_,null,null,_loc8_,smoothing);
         }
         else
         {
            bitmapData = this.sourceData.clone();
         }
      }
   }
}
