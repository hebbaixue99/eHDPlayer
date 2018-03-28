package org.osmf.player.chrome.widgets
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.osmf.events.MediaElementEvent;
   import org.osmf.events.MetadataEvent;
   import org.osmf.events.PlayEvent;
   import org.osmf.events.SeekEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.metadata.Metadata;
   import org.osmf.net.NetStreamLoadTrait;
   import org.osmf.net.StreamType;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.events.ScrubberEvent;
   import org.osmf.player.chrome.hint.WidgetHint;
   import org.osmf.player.chrome.metadata.ChromeMetadata;
   import org.osmf.player.chrome.utils.FormatUtils;
   import org.osmf.player.chrome.utils.MediaElementUtils;
   import org.osmf.player.media.StrobeMediaPlayer;
   import org.osmf.player.metadata.PlayerMetadata;
   import org.osmf.traits.DVRTrait;
   import org.osmf.traits.LoadTrait;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.PlayState;
   import org.osmf.traits.PlayTrait;
   import org.osmf.traits.SeekTrait;
   import org.osmf.traits.TimeTrait;
   
   public class ScrubBar extends Widget
   {
      
      private static const TIME_LIVE:String = "Live";
      
      private static const CURRENT_POSITION_UPDATE_INTERVAL:int = 100;
      
      private static const _requiredTraits:Vector.<String> = new Vector.<String>();
      
      {
         _requiredTraits[0] = MediaTraitType.TIME;
         _requiredTraits[1] = MediaTraitType.DVR;
      }
      
      public var track:String = "scrubBarTrack";
      
      public var trackLeft:String = "scrubBarTrackLeft";
      
      public var trackRight:String = "scrubBarTrackRight";
      
      public var loadedTrack:String = "scrubBarLoadedTrack";
      
      public var loadedTrackEnd:String = "scrubBarLoadedTrackEnd";
      
      public var playedTrack:String = "scrubBarPlayedTrack";
      
      public var dvrLiveTrack:String = "scrubBarDVRLiveTrack";
      
      public var dvrLiveInactiveTrack:String = "scrubBarDVRLiveInactiveTrack";
      
      public var font:String = "defaultFont";
      
      public var scrubberUp:String = "scrubBarScrubberNormal";
      
      public var scrubberDown:String = "scrubBarScrubberDown";
      
      public var scrubberDisabled:String = "scrubBarScrubberDisabled";
      
      public var timeHint:String = "scrubBarTimeHint";
      
      public var liveOnlyTrack:String = "scrubBarLiveOnlyTrack";
      
      public var liveOnlyInactiveTrack:String = "scrubBarLiveOnlyInactiveTrack";
      
      private var _live:Boolean = false;
      
      private var scrubber:Slider;
      
      private var scrubBarClickArea:Sprite;
      
      private var scrubBarHint:TimeHintWidget;
      
      private var scrubberStart:Number;
      
      private var scrubberEnd:Number;
      
      private var scrubBarWidth:Number;
      
      private var scrubberWidth:Number;
      
      private var currentPositionTimer:Timer;
      
      private var scrubBarTrack:DisplayObject;
      
      private var scrubBarLoadedTrack:DisplayObject;
      
      private var scrubBarLoadedTrackEnd:DisplayObject;
      
      private var scrubBarPlayedTrack:DisplayObject;
      
      private var scrubBarTrackLeft:DisplayObject;
      
      private var scrubBarTrackRight:DisplayObject;
      
      private var scrubBarDVRLiveTrack:DisplayObject;
      
      private var scrubBarDVRLiveInactiveTrack:DisplayObject;
      
      private var scrubBarLiveOnlyTrack:DisplayObject;
      
      private var scrubBarLiveOnlyInactiveTrack:DisplayObject;
      
      private var preScrubPlayState:String;
      
      private var lastWidth:Number;
      
      private var lastHeight:Number;
      
      private var seekToTime:Number;
      
      private var started:Boolean;
      
      private var scrubBarLiveTrackWidth:Number;
      
      private var mediaPlayer:StrobeMediaPlayer;
      
      public function ScrubBar()
      {
         this.scrubBarClickArea = new Sprite();
         this.scrubBarClickArea.addEventListener(MouseEvent.MOUSE_DOWN,this.onTrackMouseDown);
         this.scrubBarClickArea.addEventListener(MouseEvent.MOUSE_UP,this.onTrackMouseUp);
         this.scrubBarClickArea.addEventListener(MouseEvent.MOUSE_OVER,this.onTrackMouseOver);
         this.scrubBarClickArea.addEventListener(MouseEvent.MOUSE_MOVE,this.onTrackMouseMove);
         this.scrubBarClickArea.addEventListener(MouseEvent.MOUSE_OUT,this.onTrackMouseOut);
         addChild(this.scrubBarClickArea);
         this.currentPositionTimer = new Timer(CURRENT_POSITION_UPDATE_INTERVAL);
         this.currentPositionTimer.addEventListener(TimerEvent.TIMER,this.updateScrubberPosition);
         super();
      }
      
      override public function layout(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         var _loc4_:Metadata = null;
         if(param1 == 0 || param2 == 0)
         {
            return;
         }
         if(this.scrubber.width != this.scrubberWidth || this.lastWidth != param1 || this.lastHeight != param2)
         {
            this.lastWidth = param1;
            this.lastHeight = param2;
            this.scrubBarWidth = Math.max(10,param1);
            this.scrubberWidth = this.scrubber.width;
            this.scrubBarTrack.x = this.scrubBarTrackLeft.width;
            this.scrubBarTrack.y = this.scrubBarTrackLeft.y;
            this.scrubBarTrack.width = this.scrubBarWidth - this.scrubBarTrackLeft.width - this.scrubBarTrackRight.width;
            this.scrubBarLiveOnlyTrack.x = this.scrubBarTrack.x;
            this.scrubBarLiveOnlyTrack.y = this.scrubBarTrack.y + 2;
            this.scrubBarLiveOnlyTrack.width = this.scrubBarWidth - this.scrubBarTrackLeft.width - this.scrubBarTrackRight.width;
            this.scrubBarLiveOnlyInactiveTrack.x = this.scrubBarTrack.x;
            this.scrubBarLiveOnlyInactiveTrack.y = this.scrubBarTrack.y + 2;
            this.scrubBarLiveOnlyInactiveTrack.width = this.scrubBarWidth - this.scrubBarTrackLeft.width - this.scrubBarTrackRight.width;
            this.scrubBarTrackRight.x = this.scrubBarTrack.width + this.scrubBarTrackLeft.width;
            this.scrubBarTrackRight.y = this.scrubBarTrackLeft.y;
            this.scrubberStart = this.scrubBarTrackLeft.x - this.scrubber.width / 2;
            this.scrubberEnd = this.scrubBarTrackRight.x + this.scrubBarTrackRight.width - this.scrubber.width / 2;
            this.scrubBarLoadedTrack.x = this.scrubBarTrack.x;
            this.scrubBarLoadedTrack.y = this.scrubBarTrack.y;
            this.scrubBarLoadedTrack.width = 0;
            this.scrubBarLoadedTrackEnd.x = this.scrubBarTrack.x;
            this.scrubBarLoadedTrackEnd.y = this.scrubBarTrack.y;
            this.scrubBarPlayedTrack.x = this.scrubBarTrack.x;
            this.scrubBarPlayedTrack.y = this.scrubBarTrack.y;
            this.scrubBarPlayedTrack.width = 0;
            this.scrubber.rangeY = 0;
            this.scrubber.rangeX = this.scrubberEnd - this.scrubberStart;
            if(this.dvrTrait && this.dvrTrait.isRecording)
            {
               this.scrubBarDVRLiveInactiveTrack.y = this.scrubBarTrack.y + 2;
               this.scrubBarDVRLiveInactiveTrack.x = this.scrubBarTrack.width + this.scrubBarTrackLeft.width - this.scrubBarLiveTrackWidth;
               this.scrubBarDVRLiveTrack.y = this.scrubBarTrack.y + 2;
               this.scrubBarDVRLiveTrack.x = this.scrubBarTrack.width + this.scrubBarTrackLeft.width - this.scrubBarLiveTrackWidth;
               if(this._live)
               {
                  this.scrubBarDVRLiveTrack.visible = true;
                  this.scrubBarDVRLiveInactiveTrack.visible = false;
               }
               else
               {
                  this.scrubBarDVRLiveTrack.visible = false;
                  this.scrubBarDVRLiveInactiveTrack.visible = true;
               }
               this.scrubberEnd = this.scrubberEnd - this.scrubBarLiveTrackWidth;
            }
            else
            {
               this.scrubBarDVRLiveTrack.visible = false;
               this.scrubBarDVRLiveInactiveTrack.visible = false;
               if(media && this.streamType != StreamType.LIVE)
               {
                  _loc4_ = !!media?media.getMetadata(ChromeMetadata.CHROME_METADATA_KEY):null;
                  if(_loc4_ != null)
                  {
                     _loc4_.removeValue(ChromeMetadata.LIVE);
                  }
               }
            }
            this.scrubber.y = this.scrubBarTrack.y;
            this.scrubber.origin = this.scrubberStart;
            this.scrubBarClickArea.x = this.scrubBarTrack.x;
            this.scrubBarClickArea.y = this.scrubBarTrack.y;
            this.scrubBarClickArea.graphics.clear();
            this.scrubBarClickArea.graphics.beginFill(16777215,0);
            this.scrubBarClickArea.graphics.drawRect(0,0,this.scrubBarTrack.width,Math.max(this.scrubBarTrack.height,this.scrubber.height));
            this.scrubBarClickArea.graphics.endFill();
            this.updateScrubberPosition();
            this.updateState();
         }
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         super.configure(param1,param2);
         this.scrubBarTrack = param2.getDisplayObject(this.track) || new Sprite();
         addChild(this.scrubBarTrack);
         this.scrubBarLiveOnlyTrack = param2.getDisplayObject(this.liveOnlyTrack) || new Sprite();
         this.scrubBarLiveOnlyTrack.visible = false;
         addChild(this.scrubBarLiveOnlyTrack);
         this.scrubBarLiveOnlyInactiveTrack = param2.getDisplayObject(this.liveOnlyInactiveTrack) || new Sprite();
         this.scrubBarLiveOnlyInactiveTrack.visible = false;
         addChild(this.scrubBarLiveOnlyInactiveTrack);
         this.scrubBarLoadedTrack = param2.getDisplayObject(this.loadedTrack) || new Sprite();
         addChild(this.scrubBarLoadedTrack);
         this.scrubBarLoadedTrackEnd = param2.getDisplayObject(this.loadedTrackEnd) || new Sprite();
         addChild(this.scrubBarLoadedTrackEnd);
         this.scrubBarPlayedTrack = param2.getDisplayObject(this.playedTrack) || new Sprite();
         addChild(this.scrubBarPlayedTrack);
         this.scrubBarDVRLiveTrack = param2.getDisplayObject(this.dvrLiveTrack) || new Sprite();
         this.scrubBarDVRLiveInactiveTrack = param2.getDisplayObject(this.dvrLiveInactiveTrack) || new Sprite();
         this.scrubBarDVRLiveInactiveTrack.visible = false;
         addChild(this.scrubBarDVRLiveInactiveTrack);
         this.scrubBarLiveTrackWidth = this.scrubBarDVRLiveTrack.width;
         this.scrubBarDVRLiveInactiveTrack.addEventListener(MouseEvent.CLICK,this.goToLive);
         this.scrubBarDVRLiveTrack.addEventListener(MouseEvent.MOUSE_MOVE,this.onTrackMouseMove);
         this.scrubBarDVRLiveTrack.addEventListener(MouseEvent.MOUSE_OUT,this.onTrackMouseOut);
         this.scrubBarDVRLiveInactiveTrack.addEventListener(MouseEvent.MOUSE_MOVE,this.onTrackMouseMove);
         this.scrubBarDVRLiveInactiveTrack.addEventListener(MouseEvent.MOUSE_OUT,this.onTrackMouseOut);
         this.scrubBarDVRLiveTrack.visible = false;
         this.scrubBarDVRLiveInactiveTrack.visible = false;
         addChild(this.scrubBarDVRLiveTrack);
         this.scrubBarTrackLeft = param2.getDisplayObject(this.trackLeft) || new Sprite();
         addChild(this.scrubBarTrackLeft);
         this.scrubBarTrackRight = param2.getDisplayObject(this.trackRight) || new Sprite();
         addChild(this.scrubBarTrackRight);
         this.scrubber = new Slider(param2.getDisplayObject(this.scrubberUp),param2.getDisplayObject(this.scrubberDown),param2.getDisplayObject(this.scrubberDisabled));
         this.scrubber.addEventListener(MouseEvent.MOUSE_MOVE,this.onTrackMouseMove);
         this.scrubber.addEventListener(MouseEvent.MOUSE_OUT,this.onTrackMouseOut);
         this.scrubber.enabled = false;
         this.scrubber.addEventListener(ScrubberEvent.SCRUB_START,this.onScrubberStart);
         this.scrubber.addEventListener(ScrubberEvent.SCRUB_UPDATE,this.onScrubberUpdate);
         this.scrubber.addEventListener(ScrubberEvent.SCRUB_END,this.onScrubberEnd);
         addChild(this.scrubber);
         measure();
         this.updateState();
         this.scrubBarHint = new TimeHintWidget();
         this.scrubBarHint.face = this.timeHint;
         this.scrubBarHint.autoSize = true;
         this.scrubBarHint.tintColor = tintColor;
         this.scrubBarHint.configure(<default/>,param2);
      }
      
      override protected function get requiredTraits() : Vector.<String>
      {
         return _requiredTraits;
      }
      
      override protected function processRequiredTraitsAvailable(param1:MediaElement) : void
      {
         this.updateState();
      }
      
      override protected function processRequiredTraitsUnavailable(param1:MediaElement) : void
      {
         this.updateState();
      }
      
      override protected function onMediaElementTraitAdd(param1:MediaElementEvent) : void
      {
         var _loc2_:PlayTrait = null;
         var _loc3_:Metadata = null;
         if(param1.traitType == MediaTraitType.PLAY)
         {
            _loc2_ = media.getTrait(MediaTraitType.PLAY) as PlayTrait;
            if(_loc2_.playState != PlayState.PLAYING)
            {
               this.started = false;
               _loc2_.addEventListener(PlayEvent.PLAY_STATE_CHANGE,this.onFirstPlayStateChange);
            }
            else
            {
               this.started = true;
               this.goToLive();
            }
            _loc2_.addEventListener(PlayEvent.PLAY_STATE_CHANGE,this.onPlayStateChange);
            if(media)
            {
               if(this.streamType == StreamType.LIVE)
               {
                  this.updateLiveBar(_loc2_.playState == PlayState.PLAYING);
                  _loc3_ = new Metadata();
                  _loc3_.addValue(ChromeMetadata.LIVE,true);
                  media.addMetadata(ChromeMetadata.CHROME_METADATA_KEY,_loc3_);
               }
            }
         }
         if(param1.traitType == MediaTraitType.SEEK)
         {
            _loc2_ = media.getTrait(MediaTraitType.PLAY) as PlayTrait;
            if(_loc2_ && _loc2_.playState == PlayState.PLAYING)
            {
               this.goToLive();
            }
         }
         this.updateState();
      }
      
      override protected function onMediaElementTraitRemove(param1:MediaElementEvent) : void
      {
         this.updateState();
      }
      
      override public function set media(param1:MediaElement) : void
      {
         var _loc2_:String = null;
         var _loc3_:MediaElementEvent = null;
         super.media = param1;
         if(media == null)
         {
            return;
         }
         for each(_loc2_ in param1.traitTypes)
         {
            _loc3_ = new MediaElementEvent(MediaElementEvent.TRAIT_ADD,false,false,_loc2_);
            this.onMediaElementTraitAdd(_loc3_);
         }
         media.metadata.addEventListener(MetadataEvent.VALUE_CHANGE,this.onMetadataValueChange);
      }
      
      private function onMetadataValueChange(param1:MetadataEvent) : void
      {
         var _loc3_:PlayerMetadata = null;
         var _loc2_:Metadata = param1.target as Metadata;
         _loc3_ = _loc2_.getValue(PlayerMetadata.ID) as PlayerMetadata;
         this.mediaPlayer = _loc3_.mediaPlayer;
         this.updateLiveBar(this.mediaPlayer.playing);
      }
      
      private function onFirstPlayStateChange(param1:PlayEvent) : void
      {
         var _loc2_:PlayTrait = null;
         if(param1.playState == PlayState.PLAYING)
         {
            this.started = true;
            this.updateState();
            _loc2_ = media.getTrait(MediaTraitType.PLAY) as PlayTrait;
            _loc2_.removeEventListener(PlayEvent.PLAY_STATE_CHANGE,this.onFirstPlayStateChange);
            if(this.dvrTrait && this.dvrTrait.isRecording)
            {
               this.goToLive();
            }
         }
         this.updateLiveBar(param1.playState == PlayState.PLAYING);
      }
      
      private function onPlayStateChange(param1:PlayEvent) : void
      {
         this.updateTimerState();
         if(param1.playState != PlayState.PLAYING)
         {
            if(this.dvrTrait)
            {
               this.live = false;
            }
         }
         this.updateLiveBar(param1.playState == PlayState.PLAYING);
      }
      
      private function updateLiveBar(param1:Boolean) : void
      {
         if(this.streamType == StreamType.LIVE)
         {
            this.scrubBarPlayedTrack.visible = false;
            this.scrubBarLoadedTrackEnd.visible = false;
            this.scrubber.visible = false;
            this.scrubber.enabled = false;
            if(param1)
            {
               setChildIndex(this.scrubBarLiveOnlyTrack,10);
               this.scrubBarLiveOnlyTrack.visible = true;
               this.scrubBarLiveOnlyInactiveTrack.visible = false;
            }
            else
            {
               this.scrubBarLiveOnlyTrack.visible = false;
               this.scrubBarLiveOnlyInactiveTrack.visible = true;
            }
         }
         else
         {
            this.scrubBarLiveOnlyTrack.visible = false;
            this.scrubBarLiveOnlyInactiveTrack.visible = false;
            if(param1)
            {
               this.scrubBarPlayedTrack.visible = true;
               this.scrubBarLoadedTrackEnd.visible = true;
            }
         }
      }
      
      private function updateState() : void
      {
         visible = media != null;
         enabled = !!media?Boolean(media.hasTrait(MediaTraitType.SEEK)):false;
         if(this.streamType == StreamType.LIVE || !this.started)
         {
            this.updateLiveBar(this.started);
         }
         else
         {
            this.scrubBarLoadedTrack.visible = !!media?Boolean(media.hasTrait(MediaTraitType.LOAD)):false;
            this.scrubBarLoadedTrackEnd.visible = !!media?Boolean(media.hasTrait(MediaTraitType.LOAD)):false;
            this.scrubBarPlayedTrack.visible = !!media?Boolean(media.hasTrait(MediaTraitType.PLAY)):false;
            if(this.scrubber)
            {
               this.scrubber.enabled = !!media?Boolean(media.hasTrait(MediaTraitType.SEEK)):false;
               this.scrubber.visible = true;
            }
         }
         this.updateTimerState();
      }
      
      private function updateTimerState() : void
      {
         var _loc2_:PlayTrait = null;
         var _loc1_:TimeTrait = !!media?media.getTrait(MediaTraitType.TIME) as TimeTrait:null;
         if(_loc1_ == null)
         {
            this.currentPositionTimer.stop();
            this.resetUI();
         }
         else
         {
            _loc2_ = !!media?media.getTrait(MediaTraitType.PLAY) as PlayTrait:null;
            if(_loc2_ && !this.currentPositionTimer.running)
            {
               this.currentPositionTimer.start();
            }
         }
      }
      
      private function updateScrubberPosition(param1:Event = null) : void
      {
         var _loc3_:LoadTrait = null;
         var _loc4_:SeekTrait = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:TimeTrait = !!media?media.getTrait(MediaTraitType.TIME) as TimeTrait:null;
         if(_loc2_ != null && _loc2_.duration)
         {
            _loc3_ = !!media?media.getTrait(MediaTraitType.LOAD) as LoadTrait:null;
            _loc4_ = !!media?media.getTrait(MediaTraitType.SEEK) as SeekTrait:null;
            _loc5_ = _loc2_.duration;
            if(!_loc3_)
            {
            }
            _loc6_ = !!isNaN(this.seekToTime)?Number(_loc2_.currentTime):Number(this.seekToTime);
            if(this.dvrTrait && this.live)
            {
               this.scrubber.x = this.scrubBarDVRLiveTrack.x - this.scrubber.width / 2 + this.scrubBarLiveTrackWidth / 2;
            }
            else
            {
               _loc7_ = Number(this.scrubberStart + (this.scrubberEnd - this.scrubberStart) * _loc6_ / _loc5_) || Number(this.scrubberStart);
               this.scrubber.x = Math.min(this.scrubberEnd,Math.max(this.scrubberStart,_loc7_));
               if(_loc3_)
               {
                  this.scrubBarLoadedTrack.width = (this.scrubberEnd - this.scrubberStart - this.scrubBarTrackLeft.width - this.scrubBarTrackRight.width) * (_loc3_.bytesTotal && _loc3_.bytesLoaded?Math.min(1,_loc3_.bytesLoaded / _loc3_.bytesTotal):!!_loc4_?1:0);
                  this.scrubBarLoadedTrackEnd.x = this.scrubBarLoadedTrack.x + this.scrubBarLoadedTrack.width;
               }
            }
            this.scrubBarPlayedTrack.width = Math.max(0,this.scrubber.x);
         }
         else
         {
            this.resetUI();
         }
      }
      
      private function seekToX(param1:Number) : void
      {
         var _loc5_:Number = NaN;
         if(!this.started)
         {
            return;
         }
         var _loc2_:TimeTrait = !!media?media.getTrait(MediaTraitType.TIME) as TimeTrait:null;
         var _loc3_:SeekTrait = !!media?media.getTrait(MediaTraitType.SEEK) as SeekTrait:null;
         var _loc4_:PlayTrait = !!media?media.getTrait(MediaTraitType.PLAY) as PlayTrait:null;
         if(_loc2_ && _loc3_)
         {
            if(this.dvrTrait && this.dvrTrait.isRecording && param1 > this.scrubBarDVRLiveTrack.x)
            {
               this.goToLive();
            }
            else
            {
               this.live = false;
               if(param1 == -4)
               {
                  _loc5_ = 0;
               }
               else
               {
                  _loc5_ = _loc2_.duration * ((param1 - this.scrubberStart) / (this.scrubberEnd - this.scrubberStart));
               }
               if(_loc3_.canSeekTo(_loc5_))
               {
                  if(_loc4_ && _loc4_.playState == PlayState.STOPPED)
                  {
                     if(_loc4_.canPause)
                     {
                        _loc4_.play();
                        _loc4_.pause();
                     }
                  }
                  _loc3_.addEventListener(SeekEvent.SEEKING_CHANGE,this.onSeekingChange);
                  this.seekToTime = _loc5_;
                  _loc3_.seek(_loc5_);
                  this.scrubber.x = Math.max(this.scrubberStart,this.scrubberStart + param1);
                  this.scrubBarPlayedTrack.width = this.scrubber.x;
               }
            }
         }
      }
      
      private function onSeekingChange(param1:SeekEvent) : void
      {
         var _loc2_:SeekTrait = null;
         if(param1.seeking == false)
         {
            _loc2_ = param1.target as SeekTrait;
            _loc2_.removeEventListener(SeekEvent.SEEKING_CHANGE,this.onSeekingChange);
            this.updateScrubberPosition();
            this.seekToTime = NaN;
         }
      }
      
      private function onScrubberUpdate(param1:ScrubberEvent = null) : void
      {
         this.showTimeHint();
         this.seekToX(this.scrubber.x);
      }
      
      private function onScrubberStart(param1:ScrubberEvent) : void
      {
         var _loc2_:PlayTrait = media.getTrait(MediaTraitType.PLAY) as PlayTrait;
         if(_loc2_)
         {
            this.preScrubPlayState = _loc2_.playState;
            if(_loc2_.canPause && _loc2_.playState != PlayState.PAUSED)
            {
               _loc2_.pause();
            }
         }
      }
      
      private function onScrubberEnd(param1:ScrubberEvent) : void
      {
         var _loc2_:PlayTrait = null;
         this.seekToX(this.scrubber.x);
         if(this.preScrubPlayState)
         {
            _loc2_ = media.getTrait(MediaTraitType.PLAY) as PlayTrait;
            if(_loc2_)
            {
               if(_loc2_.playState != this.preScrubPlayState)
               {
                  switch(this.preScrubPlayState)
                  {
                     case PlayState.STOPPED:
                        _loc2_.stop();
                        break;
                     case PlayState.PLAYING:
                        _loc2_.play();
                  }
               }
            }
         }
      }
      
      private function onTrackMouseDown(param1:MouseEvent) : void
      {
         this.seekToX(mouseX - this.scrubber.width / 2);
         this.showTimeHint();
      }
      
      private function onTrackMouseUp(param1:MouseEvent) : void
      {
         this.scrubber.stop();
      }
      
      private function onTrackMouseOver(param1:MouseEvent) : void
      {
         this.showTimeHint();
      }
      
      private function onTrackMouseMove(param1:MouseEvent) : void
      {
         this.showTimeHint();
         if(param1.buttonDown && !this.scrubber.sliding)
         {
            this.scrubber.start();
         }
      }
      
      private function onTrackMouseOut(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            if(event.relatedObject != this.scrubber && event.relatedObject is DisplayObject && !contains(event.relatedObject) || event.relatedObject == this)
            {
               WidgetHint.getInstance(this,true).hide();
            }
            return;
         }
         catch(e:Error)
         {
            WidgetHint.getInstance(this,true).hide();
            return;
         }
      }
      
      private function showTimeHint() : void
      {
         var _loc1_:TimeTrait = null;
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         if(this.streamType == StreamType.LIVE)
         {
            return;
         }
         if(this.scrubBarClickArea.mouseX >= 0 && this.scrubBarClickArea.mouseX <= this.scrubBarClickArea.width)
         {
            _loc1_ = !!media?media.getTrait(MediaTraitType.TIME) as TimeTrait:null;
            if(_loc1_)
            {
               _loc2_ = _loc1_.duration * ((mouseX - this.scrubber.width / 2 - this.scrubberStart) / (this.scrubberEnd - this.scrubberStart));
               _loc3_ = this.dvrTrait && this.dvrTrait.isRecording && mouseX > this.scrubBarDVRLiveTrack.x;
               _loc4_ = FormatUtils.formatTimeStatus(_loc2_,_loc1_.duration)[0];
               this.scrubBarHint.text = !!_loc3_?TIME_LIVE:_loc4_;
               if(WidgetHint.getInstance(this,true).widget)
               {
                  WidgetHint.getInstance(this,true).updatePosition();
               }
               else
               {
                  WidgetHint.getInstance(this,true).widget = this.scrubBarHint;
               }
            }
         }
      }
      
      private function resetUI() : void
      {
         if(this.scrubber)
         {
            this.scrubber.x = this.scrubberStart;
         }
         this.scrubBarPlayedTrack.width = 0;
      }
      
      private function getBufferTime() : Number
      {
         var _loc1_:Number = 0;
         var _loc2_:NetStreamLoadTrait = media.getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
         if(_loc2_ && _loc2_.netStream)
         {
            _loc1_ = _loc2_.netStream.bufferTime;
         }
         return _loc1_;
      }
      
      private function goToLive(param1:Event = null) : void
      {
         var _loc2_:PlayerMetadata = null;
         var _loc3_:StrobeMediaPlayer = null;
         _loc2_ = media.metadata.getValue(PlayerMetadata.ID) as PlayerMetadata;
         _loc3_ = _loc2_.mediaPlayer;
         if(_loc3_.snapToLive())
         {
            this.live = true;
         }
      }
      
      private function get live() : Boolean
      {
         var _loc1_:PlayerMetadata = null;
         var _loc2_:StrobeMediaPlayer = null;
         _loc1_ = media.metadata.getValue(PlayerMetadata.ID) as PlayerMetadata;
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.mediaPlayer;
            return _loc2_.isLive;
         }
         return false;
      }
      
      private function set live(param1:Boolean) : void
      {
         var _loc2_:PlayerMetadata = null;
         var _loc3_:StrobeMediaPlayer = null;
         if(this.dvrTrait == null)
         {
            return;
         }
         if(!this.dvrTrait.isRecording)
         {
            return;
         }
         _loc2_ = media.metadata.getValue(PlayerMetadata.ID) as PlayerMetadata;
         _loc3_ = _loc2_.mediaPlayer;
         _loc3_.isDVRLive = param1;
         this._live = param1;
         if(this._live)
         {
            this.scrubBarDVRLiveTrack.visible = true;
            this.scrubBarDVRLiveInactiveTrack.visible = false;
         }
         else
         {
            this.scrubBarDVRLiveTrack.visible = false;
            this.scrubBarDVRLiveInactiveTrack.visible = true;
         }
         if(getChildIndex(this.scrubBarPlayedTrack) < getChildIndex(this.scrubBarDVRLiveInactiveTrack))
         {
            setChildIndex(this.scrubBarPlayedTrack,getChildIndex(this.scrubBarDVRLiveInactiveTrack));
         }
      }
      
      private function get streamType() : String
      {
         if(media == null)
         {
            return "";
         }
         return MediaElementUtils.getStreamType(media);
      }
      
      private function get dvrTrait() : DVRTrait
      {
         return !!media?media.getTrait(MediaTraitType.DVR) as DVRTrait:null;
      }
   }
}
