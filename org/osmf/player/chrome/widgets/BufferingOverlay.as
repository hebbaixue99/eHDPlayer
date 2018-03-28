package org.osmf.player.chrome.widgets
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.osmf.events.BufferEvent;
   import org.osmf.events.PlayEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.traits.BufferTrait;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.PlayState;
   import org.osmf.traits.PlayTrait;
   
   public class BufferingOverlay extends Widget
   {
      
      private static const _requiredTraits:Vector.<String> = new Vector.<String>();
      
      private static const VISIBILITY_DELAY:int = 1000;
      
      {
         _requiredTraits[0] = MediaTraitType.BUFFER;
         _requiredTraits[1] = MediaTraitType.PLAY;
      }
      
      private var bufferable:BufferTrait;
      
      private var playable:PlayTrait;
      
      private var _visible:Boolean;
      
      private var visibilityTimer:Timer;
      
      public function BufferingOverlay()
      {
         this.visibilityTimer = new Timer(VISIBILITY_DELAY,1);
         this.visibilityTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onVisibilityTimerComplete);
         super();
         mouseEnabled = false;
         mouseChildren = false;
         face = AssetIDs.BUFFERING_OVERLAY;
         this._visible = super.visible;
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         super.configure(param1,param2);
         this.updateState();
      }
      
      override protected function get requiredTraits() : Vector.<String>
      {
         return _requiredTraits;
      }
      
      override protected function processRequiredTraitsAvailable(param1:MediaElement) : void
      {
         this.bufferable = param1.getTrait(MediaTraitType.BUFFER) as BufferTrait;
         this.bufferable.addEventListener(BufferEvent.BUFFER_TIME_CHANGE,this.updateState);
         this.bufferable.addEventListener(BufferEvent.BUFFERING_CHANGE,this.updateState);
         this.playable = param1.getTrait(MediaTraitType.PLAY) as PlayTrait;
         this.playable.addEventListener(PlayEvent.PLAY_STATE_CHANGE,this.updateState);
         this.updateState();
      }
      
      override protected function processRequiredTraitsUnavailable(param1:MediaElement) : void
      {
         if(this.bufferable != null)
         {
            this.bufferable.removeEventListener(BufferEvent.BUFFER_TIME_CHANGE,this.updateState);
            this.bufferable.removeEventListener(BufferEvent.BUFFERING_CHANGE,this.updateState);
            this.bufferable = null;
         }
         if(this.playable != null)
         {
            this.playable.removeEventListener(PlayEvent.PLAY_STATE_CHANGE,this.updateState);
            this.playable = null;
         }
         this.updateState();
      }
      
      override public function measure(param1:Boolean = true) : void
      {
         var _loc2_:DisplayObject = getChildAt(0);
         if(_loc2_)
         {
            _loc2_.scaleX = _loc2_.scaleY = 1;
         }
         scaleX = scaleY = 1;
         super.measure(param1);
      }
      
      override public function layout(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         var _loc4_:DisplayObject = getChildAt(0);
         if(_loc4_)
         {
            _loc4_.scaleX = _loc4_.scaleY = 1;
         }
         scaleX = scaleY = 1;
         super.layout(param1,param2,param3);
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
               this.visibilityTimer.reset();
               this.visibilityTimer.start();
            }
         }
      }
      
      override public function get visible() : Boolean
      {
         return this._visible;
      }
      
      private function updateState(param1:Event = null) : void
      {
         this.visible = this.bufferable == null || this.playable == null?false:this.bufferable.buffering && this.playable.playState == PlayState.PLAYING;
      }
      
      private function onVisibilityTimerComplete(param1:TimerEvent) : void
      {
         super.visible = true;
      }
   }
}
