package org.osmf.player.chrome.widgets
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import org.osmf.player.chrome.events.ScrubberEvent;
   
   public class Slider extends Sprite
   {
       
      
      private const UPDATE_INTERVAL:int = 40;
      
      private var currentFace:DisplayObject;
      
      private var up:DisplayObject;
      
      private var down:DisplayObject;
      
      private var disabled:DisplayObject;
      
      private var _enabled:Boolean = true;
      
      private var _origin:Number = 0.0;
      
      private var _rangeX:Number = 100.0;
      
      private var _rangeY:Number = 100.0;
      
      private var _sliding:Boolean;
      
      private var scrubTimer:Timer;
      
      public function Slider(param1:DisplayObject, param2:DisplayObject, param3:DisplayObject)
      {
         this.up = param1;
         this.down = param2;
         this.disabled = param3;
         this.scrubTimer = new Timer(this.UPDATE_INTERVAL);
         this.scrubTimer.addEventListener(TimerEvent.TIMER,this.onDraggingTimer);
         this.updateFace(this.up);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         super();
      }
      
      public function get sliding() : Boolean
      {
         return this._sliding;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(param1 != this._enabled)
         {
            this._enabled = param1;
            mouseEnabled = param1;
            this.updateFace(!!this._enabled?this.up:this.disabled);
         }
      }
      
      public function set origin(param1:Number) : void
      {
         this._origin = param1;
      }
      
      public function get origin() : Number
      {
         return this._origin;
      }
      
      public function set rangeX(param1:Number) : void
      {
         this._rangeX = param1;
      }
      
      public function get rangeX() : Number
      {
         return this._rangeX;
      }
      
      public function set rangeY(param1:Number) : void
      {
         this._rangeY = param1;
      }
      
      public function get rangeY() : Number
      {
         return this._rangeY;
      }
      
      public function start(param1:Boolean = true) : void
      {
         if(this._enabled && this._sliding == false)
         {
            this._sliding = true;
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageExitDrag);
            this.updateFace(this.down);
            this.scrubTimer.start();
            dispatchEvent(new ScrubberEvent(ScrubberEvent.SCRUB_START));
            startDrag(param1,new Rectangle(this.rangeY == 0?Number(this._origin):Number(x),this.rangeX == 0?Number(this._origin):Number(y),this._rangeX,this._rangeY));
         }
      }
      
      public function stop() : void
      {
         if(this._enabled && this._sliding)
         {
            this.scrubTimer.stop();
            stopDrag();
            this.updateFace(this.up);
            this._sliding = false;
            try
            {
               stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageExitDrag);
            }
            catch(e:Error)
            {
            }
            dispatchEvent(new ScrubberEvent(ScrubberEvent.SCRUB_END));
         }
      }
      
      override public function set x(param1:Number) : void
      {
         if(this._sliding == false)
         {
            super.x = param1;
         }
      }
      
      override public function set y(param1:Number) : void
      {
         if(this._sliding == false)
         {
            super.y = param1;
         }
      }
      
      private function updateFace(param1:DisplayObject) : void
      {
         if(this.currentFace != param1)
         {
            if(this.currentFace)
            {
               removeChild(this.currentFace);
            }
            this.currentFace = param1;
            if(this.currentFace)
            {
               addChild(this.currentFace);
            }
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.start(false);
      }
      
      private function onStageExitDrag(param1:MouseEvent) : void
      {
         this.stop();
      }
      
      private function onDraggingTimer(param1:TimerEvent) : void
      {
         dispatchEvent(new ScrubberEvent(ScrubberEvent.SCRUB_UPDATE));
      }
   }
}
