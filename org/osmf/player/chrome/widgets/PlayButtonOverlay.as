package org.osmf.player.chrome.widgets
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.PlayState;
   import org.osmf.traits.PlayTrait;
   
   public class PlayButtonOverlay extends PlayableButton
   {
      
      private static const VISIBILITY_DELAY:int = 500;
       
      
      private var _visible:Boolean = true;
      
      private var visibilityTimer:Timer;
      
      public var _bMouseClick:Boolean = false;
      
      public function PlayButtonOverlay()
      {
         this.visibilityTimer = new Timer(VISIBILITY_DELAY,1);
         this.visibilityTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onVisibilityTimerComplete);
         super();
         upFace = AssetIDs.PLAY_BUTTON_OVERLAY_NORMAL;
         downFace = AssetIDs.PLAY_BUTTON_OVERLAY_DOWN;
         overFace = AssetIDs.PLAY_BUTTON_OVERLAY_OVER;
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         super.configure(param1,param2);
         this.visible = false;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(param1 != this._visible)
         {
            this._visible = param1;
            if(param1 == false)
            {
               this.visibilityTimer.stop();
               super.visible = false;
            }
            else
            {
               if(this.visibilityTimer.running)
               {
                  this.visibilityTimer.stop();
               }
               if(parent)
               {
                  this.visibilityTimer.reset();
                  this.visibilityTimer.start();
               }
               else
               {
                  super.visible = true;
               }
            }
         }
      }
      
      override public function get visible() : Boolean
      {
         return this._visible;
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:PlayTrait = media.getTrait(MediaTraitType.PLAY) as PlayTrait;
         _loc2_.play();
         this._bMouseClick = true;
      }
      
      override protected function visibilityDeterminingEventHandler(param1:Event = null) : void
      {
         var _loc2_:Boolean = playable && (playable.playState == PlayState.STOPPED || playable.playState == PlayState.PAUSED);
         if(!_loc2_)
         {
         }
         this.visible = _loc2_;
      }
      
      private function onVisibilityTimerComplete(param1:TimerEvent) : void
      {
         super.visible = true;
      }
   }
}
