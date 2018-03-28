package org.osmf.player.chrome.widgets
{
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import org.osmf.metadata.MetadataWatcher;
   
   public class AutoHideWidget extends Widget
   {
       
      
      private var autoHideWatcher:MetadataWatcher;
      
      private var autoHideTimeoutWatcher:MetadataWatcher;
      
      private var _autoHide:Boolean;
      
      private var _autoHideTimeout:int = 3000;
      
      private var mouseOver:Boolean;
      
      private var autoHideTimer:Timer = null;
      
      public function AutoHideWidget()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onFirstAddedToStage);
      }
      
      public function get autoHide() : Boolean
      {
         return this._autoHide;
      }
      
      public function set autoHide(param1:Boolean) : void
      {
         if(this._autoHide && !param1 && this._autoHideTimeout > 0)
         {
            this.stopWatchingMouseMoves();
         }
         this._autoHide = param1;
         this.visible = !!this._autoHide?Boolean(this.mouseOver):true;
      }
      
      public function get autoHideTimeout() : int
      {
         return this._autoHideTimeout;
      }
      
      public function set autoHideTimeout(param1:int) : void
      {
         this._autoHideTimeout = param1;
         this.visible = !!this._autoHide?Boolean(this.mouseOver):true;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         this.startWatchingMouseMoves();
      }
      
      private function onFirstAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onFirstAddedToStage);
         addEventListener(MouseEvent.MOUSE_OVER,this.onStageMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onStageMouseOut);
         if(this._autoHide && this._autoHideTimeout > 0)
         {
            this.startWatchingMouseMoves();
         }
      }
      
      private function onStageMouseOver(param1:MouseEvent) : void
      {
         if(!this._autoHide)
         {
            return;
         }
         this.mouseOver = true;
         this.stopWatchingMouseMoves();
         this.visible = !!this._autoHide?Boolean(this.mouseOver):true;
      }
      
      private function onStageMouseOut(param1:MouseEvent) : void
      {
         if(!this._autoHide)
         {
            return;
         }
         this.mouseOver = false;
         this.visible = !!this._autoHide?Boolean(this.mouseOver):true;
      }
      
      private function startWatchingMouseMoves(param1:Event = null) : void
      {
         if(this._autoHideTimeout <= 0)
         {
            return;
         }
         if(stage == null)
         {
            addEventListener(Event.ADDED_TO_STAGE,this.startWatchingMouseMoves);
         }
         else
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.startWatchingMouseMoves);
         }
         if(stage != null && this._autoHide && this._autoHideTimeout > 0 && !this.mouseOver)
         {
            if(this.autoHideTimer == null)
            {
               stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
               this.autoHideTimer = new Timer(this._autoHideTimeout);
               this.autoHideTimer.addEventListener(TimerEvent.TIMER,this.onAutoHideTimer);
               this.autoHideTimer.start();
            }
         }
      }
      
      private function stopWatchingMouseMoves() : void
      {
         if(this._autoHideTimeout <= 0)
         {
            return;
         }
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         }
         if(this.autoHideTimer != null)
         {
            this.autoHideTimer.removeEventListener(TimerEvent.TIMER,this.onAutoHideTimer);
            this.autoHideTimer.stop();
            this.autoHideTimer = null;
         }
      }
      
      private function onAutoHideTimer(param1:Event) : void
      {
         if(this._autoHideTimeout <= 0)
         {
            return;
         }
         if(visible)
         {
            this.visible = false;
            if(stage && stage.displayState != StageDisplayState.NORMAL)
            {
               Mouse.hide();
            }
         }
      }
      
      private function onMouseMove(param1:Event) : void
      {
         if(this._autoHideTimeout <= 0)
         {
            return;
         }
         if(this.autoHideTimer == null)
         {
            return;
         }
         this.autoHideTimer.reset();
         this.autoHideTimer.start();
         if(!visible)
         {
            this.visible = true;
            if(stage && stage.displayState != StageDisplayState.NORMAL)
            {
               Mouse.show();
            }
         }
      }
   }
}
