package org.osmf.player.elements.playlistClasses
{
   import org.osmf.events.MediaElementEvent;
   import org.osmf.events.TimeEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.TimeTrait;
   
   class PlaylistTimeTrait extends TimeTrait
   {
       
      
      private var _mediaElement:MediaElement;
      
      private var _timeTrait:TimeTrait;
      
      function PlaylistTimeTrait(param1:Number = NaN)
      {
         super(param1);
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
            this.updateTimeTrait();
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._timeTrait != null;
      }
      
      public function signalCompletion() : void
      {
         signalComplete();
      }
      
      override public function get currentTime() : Number
      {
         return !!this._timeTrait?Number(this._timeTrait.currentTime):Number(0);
      }
      
      private function set timeTrait(param1:TimeTrait) : void
      {
         var _loc2_:TimeTrait = null;
         if(param1 != this._timeTrait)
         {
            _loc2_ = this._timeTrait;
            this._timeTrait = param1;
            if(!(this._timeTrait && _loc2_))
            {
               dispatchEvent(new PlaylistTraitEvent(PlaylistTraitEvent.ENABLED_CHANGE));
            }
         }
      }
      
      private function onMediaElementTraitsChange(param1:MediaElementEvent) : void
      {
         this.updateTimeTrait(param1.type == MediaElementEvent.TRAIT_REMOVE && param1.traitType == MediaTraitType.TIME);
      }
      
      private function updateTimeTrait(param1:Boolean = false) : void
      {
         var _loc2_:TimeTrait = !!this._mediaElement?!!param1?null:this._mediaElement.getTrait(MediaTraitType.TIME) as TimeTrait:null;
         if(this._timeTrait != _loc2_)
         {
            if(this._timeTrait)
            {
               this._timeTrait.removeEventListener(TimeEvent.COMPLETE,this.onTimeTraitComplete);
               this._timeTrait.removeEventListener(TimeEvent.DURATION_CHANGE,this.onTimeTraitDurationChange);
            }
            this.timeTrait = _loc2_;
            if(this._timeTrait)
            {
               this._timeTrait.addEventListener(TimeEvent.COMPLETE,this.onTimeTraitComplete);
               this._timeTrait.addEventListener(TimeEvent.DURATION_CHANGE,this.onTimeTraitDurationChange);
               setDuration(this._timeTrait.duration);
            }
            else
            {
               setDuration(NaN);
            }
         }
      }
      
      private function onTimeTraitComplete(param1:TimeEvent) : void
      {
         dispatchEvent(new PlaylistTraitEvent(PlaylistTraitEvent.ACTIVE_ITEM_COMPLETE));
      }
      
      private function onTimeTraitDurationChange(param1:TimeEvent) : void
      {
         setDuration(param1.time);
      }
   }
}
