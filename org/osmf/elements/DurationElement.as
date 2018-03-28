package org.osmf.elements
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import org.osmf.elements.proxyClasses.DurationSeekTrait;
   import org.osmf.elements.proxyClasses.DurationTimeTrait;
   import org.osmf.events.PlayEvent;
   import org.osmf.events.SeekEvent;
   import org.osmf.events.TimeEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.PlayState;
   import org.osmf.traits.PlayTrait;
   
   public class DurationElement extends ProxyElement
   {
      
      private static const DEFAULT_PLAYHEAD_UPDATE_INTERVAL:Number = 250;
      
      private static const NO_TRAITS:Vector.<String> = new Vector.<String>();
      
      private static const ALL_OTHER_TRAITS:Vector.<String> = new Vector.<String>();
      
      {
         ALL_OTHER_TRAITS.push(MediaTraitType.AUDIO);
         ALL_OTHER_TRAITS.push(MediaTraitType.BUFFER);
         ALL_OTHER_TRAITS.push(MediaTraitType.DISPLAY_OBJECT);
         ALL_OTHER_TRAITS.push(MediaTraitType.DRM);
         ALL_OTHER_TRAITS.push(MediaTraitType.DVR);
         ALL_OTHER_TRAITS.push(MediaTraitType.DYNAMIC_STREAM);
      }
      
      private var _currentTime:Number = 0;
      
      private var _duration:Number = 0;
      
      private var absoluteStartTime:Number = 0;
      
      private var playheadTimer:Timer;
      
      private var mediaAtEnd:Boolean = false;
      
      private var timeTrait:DurationTimeTrait;
      
      private var seekTrait:DurationSeekTrait;
      
      private var playTrait:PlayTrait;
      
      public function DurationElement(param1:Number, param2:MediaElement = null)
      {
         this._duration = param1;
         this.playheadTimer = new Timer(DEFAULT_PLAYHEAD_UPDATE_INTERVAL);
         this.playheadTimer.addEventListener(TimerEvent.TIMER,this.onPlayheadTimer,false,0,true);
         super(param2 != null?param2:new MediaElement());
      }
      
      override protected function setupTraits() : void
      {
         super.setupTraits();
         this.timeTrait = new DurationTimeTrait(this._duration);
         this.timeTrait.addEventListener(TimeEvent.COMPLETE,this.onComplete,false,int.MAX_VALUE);
         addTrait(MediaTraitType.TIME,this.timeTrait);
         this.seekTrait = new DurationSeekTrait(this.timeTrait);
         addTrait(MediaTraitType.SEEK,this.seekTrait);
         this.seekTrait.addEventListener(SeekEvent.SEEKING_CHANGE,this.onSeekingChange,false,-1);
         this.playTrait = new PlayTrait();
         this.playTrait.addEventListener(PlayEvent.PLAY_STATE_CHANGE,this.onPlayStateChange);
         addTrait(MediaTraitType.PLAY,this.playTrait);
         blockedTraits = ALL_OTHER_TRAITS;
      }
      
      private function onPlayheadTimer(param1:TimerEvent) : void
      {
         if(this.currentTime >= this._duration)
         {
            this.playheadTimer.stop();
            this.playTrait.stop();
            this.currentTime = this._duration;
         }
         else
         {
            this.currentTime = (getTimer() - this.absoluteStartTime) / 1000;
         }
      }
      
      private function onPlayStateChange(param1:PlayEvent) : void
      {
         if(param1.playState == PlayState.PLAYING)
         {
            if(this.mediaAtEnd)
            {
               this.mediaAtEnd = false;
               this.currentTime = 0;
            }
            this.absoluteStartTime = getTimer() - this.currentTime * 1000;
            this.playheadTimer.start();
         }
         else
         {
            this.playheadTimer.stop();
         }
         if(param1.playState != PlayState.STOPPED && this.currentTime < this._duration)
         {
            blockedTraits = NO_TRAITS;
         }
         else
         {
            blockedTraits = ALL_OTHER_TRAITS;
         }
      }
      
      private function onSeekingChange(param1:SeekEvent) : void
      {
         var _loc2_:Number = NaN;
         this.mediaAtEnd = false;
         if(param1.seeking)
         {
            _loc2_ = param1.time - this.currentTime;
            this.currentTime = param1.time;
            this.absoluteStartTime = this.absoluteStartTime - _loc2_ * 1000;
         }
         else if(this.currentTime < this._duration && (this.currentTime > 0 || this.playTrait.playState == PlayState.PLAYING))
         {
            blockedTraits = NO_TRAITS;
         }
         else
         {
            blockedTraits = ALL_OTHER_TRAITS;
         }
      }
      
      private function onComplete(param1:TimeEvent) : void
      {
         this.playheadTimer.stop();
         this.playTrait.stop();
         this.mediaAtEnd = true;
         blockedTraits = ALL_OTHER_TRAITS;
      }
      
      private function get currentTime() : Number
      {
         return this._currentTime;
      }
      
      private function set currentTime(param1:Number) : void
      {
         this._currentTime = param1;
         this.timeTrait.currentTime = param1;
      }
   }
}
