package org.osmf.player.elements.playlistClasses
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.osmf.events.MediaErrorEvent;
   import org.osmf.events.SeekEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.PlayState;
   import org.osmf.traits.PlayTrait;
   import org.osmf.traits.SeekTrait;
   
   public class InnerPlaylistElement extends ProxyElementEx
   {
       
      
      private var playlistMetadata:PlaylistMetadata;
      
      private var errorElementConstructorFunction:Function;
      
      private var _activeMediaElement:MediaElement;
      
      private var loadTrait:PlaylistLoadTrait;
      
      private var playTrait:PlaylistPlayTrait;
      
      private var timeTrait:PlaylistTimeTrait;
      
      private var audioTrait:PlaylistAudioTrait;
      
      private var switchOver:Boolean = true;
      
      public function InnerPlaylistElement(param1:PlaylistMetadata, param2:Function)
      {
         this.playlistMetadata = param1;
         this.errorElementConstructorFunction = param2;
         super(null);
         if(param1 == null)
         {
            throw new ArgumentError();
         }
         this.loadTrait = new PlaylistLoadTrait(null,null);
         addTrait(this.loadTrait.traitType,this.loadTrait);
         this.playTrait = new PlaylistPlayTrait();
         addTrait(this.playTrait.traitType,this.playTrait);
         this.timeTrait = new PlaylistTimeTrait();
         this.timeTrait.addEventListener(PlaylistTraitEvent.ENABLED_CHANGE,this.onTimeTraitEnabledChange);
         this.timeTrait.addEventListener(PlaylistTraitEvent.ACTIVE_ITEM_COMPLETE,this.onTimeTraitActiveItemComplete);
         this.audioTrait = new PlaylistAudioTrait();
         this.audioTrait.addEventListener(PlaylistTraitEvent.ENABLED_CHANGE,this.onAudioTraitEnabledChange);
         this.activeMediaElement = param1.currentElement;
      }
      
      public function set activeMediaElement(param1:MediaElement) : void
      {
         var oldElement:MediaElement = null;
         var oldPlayTrait:PlayTrait = null;
         var oldSeekTrait:SeekTrait = null;
         var value:MediaElement = param1;
         if(value != this._activeMediaElement)
         {
            oldElement = this._activeMediaElement;
            this.loadTrait.mediaElement = value;
            this.timeTrait.mediaElement = value;
            this.playTrait.mediaElement = value;
            this.audioTrait.mediaElement = value;
            this._activeMediaElement = value;
            this.playlistMetadata.currentElement = value;
            proxiedElement = value;
            if(value != null)
            {
               value.addEventListener(MediaErrorEvent.MEDIA_ERROR,this.onActiveChildMediaError,false,int.MAX_VALUE);
            }
            if(oldElement != null)
            {
               var stopOldElement:Function = function():void
               {
                  var workarroundTimer:Timer = new Timer(500,1);
                  workarroundTimer.addEventListener(TimerEvent.TIMER,function(param1:Event):void
                  {
                     if(oldPlayTrait && oldPlayTrait.playState == PlayState.PLAYING)
                     {
                        oldPlayTrait.stop();
                     }
                     playlistMetadata.switching = false;
                  });
                  workarroundTimer.start();
               };
               oldElement.removeEventListener(MediaErrorEvent.MEDIA_ERROR,this.onActiveChildMediaError);
               oldPlayTrait = oldElement.getTrait(MediaTraitType.PLAY) as PlayTrait;
               oldSeekTrait = oldElement.getTrait(MediaTraitType.SEEK) as SeekTrait;
               this.playlistMetadata.switching = true;
               if(oldSeekTrait && oldSeekTrait.canSeekTo(0))
               {
                  oldSeekTrait.addEventListener(SeekEvent.SEEKING_CHANGE,function(param1:SeekEvent):void
                  {
                     if(param1.seeking == false)
                     {
                        stopOldElement();
                        oldSeekTrait.removeEventListener(SeekEvent.SEEKING_CHANGE,arguments.callee);
                     }
                  });
                  oldSeekTrait.seek(0);
               }
               else
               {
                  stopOldElement();
               }
            }
         }
      }
      
      public function get activeMediaElement() : MediaElement
      {
         return this._activeMediaElement;
      }
      
      public function activateNextElement() : MediaElement
      {
         var _loc1_:MediaElement = this.playlistMetadata.nextElement;
         if(_loc1_)
         {
            this.activeMediaElement = _loc1_;
         }
         return _loc1_;
      }
      
      public function activatePreviousElement() : MediaElement
      {
         var _loc1_:MediaElement = this.playlistMetadata.previousElement;
         if(_loc1_)
         {
            this.activeMediaElement = _loc1_;
         }
         return _loc1_;
      }
      
      private function blockTrait(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:Vector.<String> = this.blockedTraits.concat();
         var _loc4_:Number = _loc3_.indexOf(param1);
         if(_loc4_ == -1 && param2 == true)
         {
            _loc3_.push(param1);
            this.blockedTraits = _loc3_;
         }
         else if(_loc4_ > -1 && param2 == false)
         {
            _loc3_.splice(_loc4_,1);
            this.blockedTraits = _loc3_;
         }
      }
      
      private function unblockTrait(param1:String) : void
      {
         this.blockTrait(param1,false);
      }
      
      private function onPlayTraitEnabledChange(param1:Event) : void
      {
         if(this.playTrait.enabled)
         {
            addTrait(this.playTrait.traitType,this.playTrait);
            this.unblockTrait(this.playTrait.traitType);
         }
         else
         {
            this.blockTrait(this.playTrait.traitType);
            removeTrait(this.playTrait.traitType);
         }
      }
      
      private function onTimeTraitEnabledChange(param1:Event) : void
      {
         if(this.timeTrait.enabled)
         {
            addTrait(this.timeTrait.traitType,this.timeTrait);
            this.unblockTrait(this.timeTrait.traitType);
         }
         else
         {
            this.blockTrait(this.timeTrait.traitType);
            removeTrait(this.timeTrait.traitType);
         }
      }
      
      private function onTimeTraitActiveItemComplete(param1:Event) : void
      {
         if(this.activateNextElement() == null)
         {
            if(this.playlistMetadata.indexOf(this._activeMediaElement) != 0)
            {
               this.activeMediaElement = this.playlistMetadata.elementAt(0);
            }
            this.playTrait.stop();
            this.timeTrait.signalCompletion();
         }
      }
      
      private function onAudioTraitEnabledChange(param1:PlaylistTraitEvent) : void
      {
         if(this.audioTrait.enabled)
         {
            addTrait(this.audioTrait.traitType,this.audioTrait);
            this.unblockTrait(this.audioTrait.traitType);
         }
         else
         {
            this.blockTrait(this.audioTrait.traitType);
            removeTrait(this.audioTrait.traitType);
         }
      }
      
      private function onActiveChildMediaError(param1:MediaErrorEvent) : void
      {
         var _loc2_:MediaElement = null;
         var _loc3_:Number = NaN;
         if(this.errorElementConstructorFunction != null)
         {
            param1.stopImmediatePropagation();
            _loc2_ = this.errorElementConstructorFunction(param1.error);
            _loc3_ = this.playlistMetadata.indexOf(this._activeMediaElement);
            this.playlistMetadata.updateElementAt(_loc3_,_loc2_);
            this.activeMediaElement = _loc2_;
         }
      }
   }
}
