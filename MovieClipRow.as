package
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   
   public class MovieClipRow extends Sprite
   {
       
      
     // public var ASSET_ScrubLiveBase:ASSET_ScrubDvrLive;
      
      //public var ASSET_ScrubLiveInactiveBase:ASSET_ScrubDvrLiveInactive;
      
      private var base:MovieClip;
      
      private var _mask:DisplayObject;
      
      private var _width:Number;
      
      private var clones:Number;
      
      public function MovieClipRow()
      {
         super();
         var _loc1_:* = getQualifiedClassName(this) + "Base";
         if(hasOwnProperty(_loc1_))
         {
            this.base = this[_loc1_] as MovieClip;
            this.base.visible = false;
            this._mask = !!this.base.hasOwnProperty("maskMovieClip")?this.base.maskMovieClip:this.base;
            addEventListener(Event.ENTER_FRAME,this.draw);
            this._width = super.width;
            scaleX = 1;
            scaleY = 1;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         if(param1 != this._width)
         {
            this._width = param1;
            this.draw();
         }
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      private function draw(param1:Event = null) : void
      {
         var _loc2_:BitmapData = new BitmapData(this._mask.width,this._mask.height);
         _loc2_.draw(this.base,null,null,null,this._mask.getBounds(this.base));
         graphics.clear();
         graphics.beginBitmapFill(_loc2_);
         graphics.drawRect(0,0,this._width,this._mask.height);
         graphics.endFill();
      }
   }
}
