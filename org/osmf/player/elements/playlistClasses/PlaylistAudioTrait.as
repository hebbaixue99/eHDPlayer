package org.osmf.player.elements.playlistClasses
{
   import org.osmf.events.AudioEvent;
   import org.osmf.events.MediaElementEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.traits.AudioTrait;
   import org.osmf.traits.MediaTraitType;
   
   class PlaylistAudioTrait extends AudioTrait
   {
       
      
      private var _mediaElement:MediaElement;
      
      private var _audioTrait:AudioTrait;
      
      function PlaylistAudioTrait()
      {
         super();
      }
      
      public function set mediaElement(param1:MediaElement) : void
      {
         if(param1 != this._mediaElement)
         {
            if(this._mediaElement)
            {
               this._mediaElement.removeEventListener(MediaElementEvent.TRAIT_ADD,this.onMediaElementTraitsChange);
               this._mediaElement.removeEventListener(MediaElementEvent.TRAIT_REMOVE,this.onMediaElementTraitsChange);
            }
            this._mediaElement = param1;
            if(this._mediaElement)
            {
               this._mediaElement.addEventListener(MediaElementEvent.TRAIT_ADD,this.onMediaElementTraitsChange);
               this._mediaElement.addEventListener(MediaElementEvent.TRAIT_REMOVE,this.onMediaElementTraitsChange);
            }
            this.updateAudioTrait();
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._audioTrait != null;
      }
      
      override protected function mutedChangeStart(param1:Boolean) : void
      {
         if(this._audioTrait && this._audioTrait.muted != param1)
         {
            this._audioTrait.muted = param1;
         }
      }
      
      override protected function panChangeEnd() : void
      {
         if(this._audioTrait && this._audioTrait.pan != pan)
         {
            this._audioTrait.pan = pan;
         }
         super.panChangeEnd();
      }
      
      override protected function volumeChangeEnd() : void
      {
         if(this._audioTrait && this._audioTrait.volume != volume)
         {
            this._audioTrait.volume = volume;
         }
         super.volumeChangeEnd();
      }
      
      private function set audioTrait(param1:AudioTrait) : void
      {
         var _loc2_:AudioTrait = null;
         if(param1 != this._audioTrait)
         {
            _loc2_ = this._audioTrait;
            this._audioTrait = param1;
            if(!(this._audioTrait && _loc2_))
            {
               dispatchEvent(new PlaylistTraitEvent(PlaylistTraitEvent.ENABLED_CHANGE));
            }
         }
      }
      
      private function onMediaElementTraitsChange(param1:MediaElementEvent) : void
      {
         this.updateAudioTrait(param1.type == MediaElementEvent.TRAIT_REMOVE && param1.traitType == MediaTraitType.AUDIO);
      }
      
      private function updateAudioTrait(param1:Boolean = false) : void
      {
         var _loc2_:AudioTrait = !!this._mediaElement?!!param1?null:this._mediaElement.getTrait(MediaTraitType.AUDIO) as AudioTrait:null;
         if(this._audioTrait != _loc2_)
         {
            if(this._audioTrait)
            {
               this._audioTrait.removeEventListener(AudioEvent.MUTED_CHANGE,this.onAudioTraitMutedChange);
               this._audioTrait.removeEventListener(AudioEvent.PAN_CHANGE,this.onAudioTraitPanChange);
               this._audioTrait.removeEventListener(AudioEvent.VOLUME_CHANGE,this.onAudioTraitVolumeChange);
            }
            this.audioTrait = _loc2_;
            if(_loc2_)
            {
               _loc2_.muted = muted;
               _loc2_.pan = pan;
               _loc2_.volume = volume;
               _loc2_.addEventListener(AudioEvent.MUTED_CHANGE,this.onAudioTraitMutedChange);
               _loc2_.addEventListener(AudioEvent.PAN_CHANGE,this.onAudioTraitPanChange);
               _loc2_.addEventListener(AudioEvent.VOLUME_CHANGE,this.onAudioTraitVolumeChange);
            }
         }
      }
      
      private function onAudioTraitMutedChange(param1:AudioEvent) : void
      {
         if(muted != this._audioTrait.muted)
         {
            muted = this._audioTrait.muted;
         }
      }
      
      private function onAudioTraitPanChange(param1:AudioEvent) : void
      {
         if(pan != this._audioTrait.pan)
         {
            pan = this._audioTrait.pan;
         }
      }
      
      private function onAudioTraitVolumeChange(param1:AudioEvent) : void
      {
         if(volume != this._audioTrait.volume)
         {
            volume = this._audioTrait.volume;
         }
      }
   }
}
