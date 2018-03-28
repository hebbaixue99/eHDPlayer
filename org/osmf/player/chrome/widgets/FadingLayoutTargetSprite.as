package org.osmf.player.chrome.widgets
{
   import flash.events.Event;
   import org.osmf.layout.LayoutMetadata;
   import org.osmf.layout.LayoutTargetSprite;
   
   public class FadingLayoutTargetSprite extends LayoutTargetSprite
   {
      
      private static const MODE_IDLE:String = null;
      
      private static const MODE_IN:String = "in";
      
      private static const MODE_OUT:String = "out";
       
      
      private var _fadeSteps:Number = 0;
      
      private var _visible:Boolean = true;
      
      private var _alpha:Number;
      
      private var _mode:String;
      
      private var remainingSteps:uint = 0;
      
      public function FadingLayoutTargetSprite(param1:LayoutMetadata = null)
      {
         super(param1);
         this._visible = super.visible;
         this._alpha = super.alpha;
      }
      
      public function get fadeSteps() : Number
      {
         return this._fadeSteps;
      }
      
      public function set fadeSteps(param1:Number) : void
      {
         if(this._fadeSteps != param1)
         {
            this._fadeSteps = param1;
            if(this._fadeSteps <= 0)
            {
               this.setIdle();
            }
            else
            {
               addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
            }
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(param1 != this._visible)
         {
            this._visible = param1;
            if(parent)
            {
               this.mode = !!this._visible?MODE_IN:MODE_OUT;
            }
            else
            {
               this.setIdle();
            }
         }
      }
      
      override public function get visible() : Boolean
      {
         return this._visible;
      }
      
      override public function set alpha(param1:Number) : void
      {
         if(param1 != this._alpha)
         {
            this._alpha = param1;
         }
      }
      
      override public function get alpha() : Number
      {
         return this._alpha;
      }
      
      protected function setSuperVisible(param1:Boolean) : void
      {
         super.visible = param1;
      }
      
      private function get mode() : String
      {
         return this._mode;
      }
      
      private function set mode(param1:String) : void
      {
         var _loc2_:Boolean = false;
         if(param1 != this._mode)
         {
            this._mode = param1;
            _loc2_ = this._fadeSteps && (this._mode == MODE_OUT && super.alpha != 0 && super.visible != false || this._mode == MODE_IN && super.alpha != this._alpha);
            if(_loc2_)
            {
               if(this.remainingSteps <= 0)
               {
                  this.remainingSteps = this._fadeSteps;
               }
               else
               {
                  this.remainingSteps = this._fadeSteps - this.remainingSteps;
               }
               addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               this.onEnterFrame();
            }
            else
            {
               this.setIdle();
            }
         }
      }
      
      private function setIdle() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._mode = MODE_IDLE;
         this.remainingSteps = 0;
         super.alpha = !!this._visible?Number(this._alpha):Number(0);
         this.setSuperVisible(this._visible);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         if(this.visible)
         {
            super.alpha = 0;
            this.mode = MODE_IN;
         }
      }
      
      private function onEnterFrame(param1:Event = null) : void
      {
         if(this.remainingSteps <= 0)
         {
            this.setSuperVisible(this._visible);
            this.mode = MODE_IDLE;
         }
         else
         {
            this.remainingSteps--;
            if(this.mode == MODE_IN)
            {
               super.alpha = this._alpha - this._alpha * this.remainingSteps / this._fadeSteps;
               this.setSuperVisible(true);
            }
            else if(this.mode == MODE_OUT)
            {
               super.alpha = this._alpha * this.remainingSteps / this._fadeSteps;
            }
         }
      }
   }
}
