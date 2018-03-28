package org.osmf.player.chrome.widgets
{
   import flash.events.Event;
   import org.osmf.events.MediaElementEvent;
   import org.osmf.events.PlayEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.PlayTrait;
   
   public class PlayableButton extends ButtonWidget
   {
      
      private static const _requiredTraits:Vector.<String> = new Vector.<String>();
      
      {
         _requiredTraits[0] = MediaTraitType.PLAY;
      }
      
      private var _playable:PlayTrait;
      
      public function PlayableButton()
      {
         super();
      }
      
      protected function get playable() : PlayTrait
      {
         return this._playable;
      }
      
      override protected function get requiredTraits() : Vector.<String>
      {
         return _requiredTraits;
      }
      
      override protected function processMediaElementChange(param1:MediaElement) : void
      {
         this.setPlayable(!!media?media.getTrait(MediaTraitType.PLAY) as PlayTrait:null);
      }
      
      override protected function onMediaElementTraitAdd(param1:MediaElementEvent) : void
      {
         if(param1.traitType == MediaTraitType.PLAY)
         {
            this.setPlayable(media.getTrait(MediaTraitType.PLAY) as PlayTrait);
         }
         super.onMediaElementTraitAdd(param1);
      }
      
      override protected function onMediaElementTraitRemove(param1:MediaElementEvent) : void
      {
         if(param1.traitType == MediaTraitType.PLAY && this._playable)
         {
            this.setPlayable(null);
         }
         super.onMediaElementTraitRemove(param1);
      }
      
      override protected function processRequiredTraitsAvailable(param1:MediaElement) : void
      {
         this.setPlayable(media.getTrait(MediaTraitType.PLAY) as PlayTrait);
      }
      
      override protected function processRequiredTraitsUnavailable(param1:MediaElement) : void
      {
         this.setPlayable(null);
      }
      
      protected function visibilityDeterminingEventHandler(param1:Event = null) : void
      {
      }
      
      private function setPlayable(param1:PlayTrait) : void
      {
         if(param1 != this._playable)
         {
            if(this._playable != null)
            {
               this._playable.removeEventListener(PlayEvent.CAN_PAUSE_CHANGE,this.visibilityDeterminingEventHandler);
               this._playable.removeEventListener(PlayEvent.PLAY_STATE_CHANGE,this.visibilityDeterminingEventHandler);
               this._playable = null;
            }
            this._playable = param1;
            if(this._playable)
            {
               this._playable.addEventListener(PlayEvent.CAN_PAUSE_CHANGE,this.visibilityDeterminingEventHandler);
               this._playable.addEventListener(PlayEvent.PLAY_STATE_CHANGE,this.visibilityDeterminingEventHandler);
            }
         }
         this.visibilityDeterminingEventHandler();
      }
   }
}
