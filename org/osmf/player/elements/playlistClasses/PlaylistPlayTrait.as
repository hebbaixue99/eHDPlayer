package org.osmf.player.elements.playlistClasses
{
   import org.osmf.events.MediaElementEvent;
   import org.osmf.events.PlayEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.PlayState;
   import org.osmf.traits.PlayTrait;
   
   class PlaylistPlayTrait extends PlayTrait
   {
       
      
      private var _mediaElement:MediaElement;
      
      private var _playTrait:PlayTrait;
      
      function PlaylistPlayTrait()
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
            this.updatePlayTrait();
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._playTrait != null;
      }
      
      override protected function playStateChangeStart(param1:String) : void
      {
         super.playStateChangeStart(param1);
         if(this._playTrait && this._playTrait.playState != param1)
         {
            switch(param1)
            {
               case PlayState.PAUSED:
                  this._playTrait.pause();
                  break;
               case PlayState.PLAYING:
                  this._playTrait.play();
                  break;
               case PlayState.STOPPED:
                  this._playTrait.stop();
            }
         }
      }
      
      private function set playTrait(param1:PlayTrait) : void
      {
         var _loc2_:PlayTrait = null;
         if(param1 != this._playTrait)
         {
            _loc2_ = this._playTrait;
            this._playTrait = param1;
            if(!(this._playTrait && _loc2_))
            {
               dispatchEvent(new PlaylistTraitEvent(PlaylistTraitEvent.ENABLED_CHANGE));
            }
         }
      }
      
      private function onMediaElementTraitsChange(param1:MediaElementEvent) : void
      {
         this.updatePlayTrait(param1.type == MediaElementEvent.TRAIT_REMOVE && param1.traitType == MediaTraitType.PLAY);
      }
      
      private function updatePlayTrait(param1:Boolean = false) : void
      {
         var _loc2_:PlayTrait = !!this._mediaElement?!!param1?null:this._mediaElement.getTrait(MediaTraitType.PLAY) as PlayTrait:null;
         if(this._playTrait != _loc2_)
         {
            if(this._playTrait)
            {
               this._playTrait.removeEventListener(PlayEvent.CAN_PAUSE_CHANGE,this.onCanPauseChange);
            }
            if(_loc2_)
            {
               _loc2_.addEventListener(PlayEvent.CAN_PAUSE_CHANGE,this.onCanPauseChange);
            }
            this.playTrait = _loc2_;
            if(_loc2_ && playState != _loc2_.playState)
            {
               switch(playState)
               {
                  case PlayState.PAUSED:
                     _loc2_.pause();
                     break;
                  case PlayState.PLAYING:
                     _loc2_.play();
                     break;
                  case PlayState.STOPPED:
                     _loc2_.stop();
               }
            }
            if(_loc2_ == null)
            {
               setCanPause(false);
            }
         }
      }
      
      private function onCanPauseChange(param1:PlayEvent) : void
      {
         setCanPause(param1.canPause);
      }
   }
}
