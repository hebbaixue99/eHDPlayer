package org.osmf.player.elements.playlistClasses
{
   import org.osmf.events.LoadEvent;
   import org.osmf.events.MediaElementEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.media.MediaResourceBase;
   import org.osmf.traits.LoadState;
   import org.osmf.traits.LoadTrait;
   import org.osmf.traits.LoaderBase;
   import org.osmf.traits.MediaTraitType;
   
   class PlaylistLoadTrait extends LoadTrait
   {
       
      
      private var _mediaElement:MediaElement;
      
      private var loadTrait:LoadTrait;
      
      function PlaylistLoadTrait(param1:LoaderBase, param2:MediaResourceBase)
      {
         super(param1,param2);
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
            this.updateLoadTrait();
         }
      }
      
      override public function load() : void
      {
         if(loadState != LoadState.LOADING && loadState != LoadState.READY)
         {
            setLoadState(LoadState.LOADING);
            if(this.loadTrait)
            {
               this.loadTrait.load();
            }
         }
      }
      
      override public function get bytesLoaded() : Number
      {
         return !!this.loadTrait?Number(this.loadTrait.bytesLoaded):Number(NaN);
      }
      
      override public function get bytesTotal() : Number
      {
         return !!this.loadTrait?Number(this.loadTrait.bytesTotal):Number(NaN);
      }
      
      private function onLoadStateChange(param1:LoadEvent) : void
      {
         setLoadState(param1.loadState == LoadState.LOAD_ERROR?LoadState.READY:param1.loadState);
      }
      
      private function onBytesTotalChange(param1:LoadEvent) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function onBytesLoadedChange(param1:LoadEvent) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function onMediaElementTraitsChange(param1:MediaElementEvent) : void
      {
         this.updateLoadTrait(param1.type == MediaElementEvent.TRAIT_REMOVE && param1.traitType == MediaTraitType.LOAD);
      }
      
      private function updateLoadTrait(param1:Boolean = false) : void
      {
         var _loc3_:LoadTrait = null;
         var _loc2_:LoadTrait = !!this._mediaElement?!!param1?null:this._mediaElement.getTrait(MediaTraitType.LOAD) as LoadTrait:null;
         if(this.loadTrait != _loc2_)
         {
            if(this.loadTrait)
            {
               this.loadTrait.removeEventListener(LoadEvent.LOAD_STATE_CHANGE,this.onLoadStateChange);
               this.loadTrait.removeEventListener(LoadEvent.BYTES_TOTAL_CHANGE,this.onBytesTotalChange);
               this.loadTrait.removeEventListener(LoadEvent.BYTES_LOADED_CHANGE,this.onBytesLoadedChange);
            }
            if(_loc2_)
            {
               _loc2_.addEventListener(LoadEvent.LOAD_STATE_CHANGE,this.onLoadStateChange);
               _loc2_.addEventListener(LoadEvent.BYTES_TOTAL_CHANGE,this.onBytesTotalChange);
               _loc2_.addEventListener(LoadEvent.BYTES_LOADED_CHANGE,this.onBytesLoadedChange);
            }
            _loc3_ = this.loadTrait;
            this.loadTrait = _loc2_;
            if(_loc2_)
            {
               if(loadState != LoadState.UNINITIALIZED && loadState != LoadState.UNLOADING && _loc2_.loadState != LoadState.LOADING && _loc2_.loadState != LoadState.READY)
               {
                  _loc2_.load();
               }
               else
               {
                  setLoadState(_loc2_.loadState);
               }
            }
         }
      }
   }
}
