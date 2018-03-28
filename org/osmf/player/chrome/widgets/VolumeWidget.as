package org.osmf.player.chrome.widgets
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.osmf.events.AudioEvent;
   import org.osmf.layout.LayoutMode;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.events.ScrubberEvent;
   import org.osmf.traits.AudioTrait;
   import org.osmf.traits.MediaTraitType;
   
   public class VolumeWidget extends Widget
   {
      
      private static const _requiredTraits:Vector.<String> = new Vector.<String>();
      
      {
         _requiredTraits[0] = MediaTraitType.AUDIO;
      }
      
      public var track:String = "volumeBarTrack";
      
      public var trackBottom:String = "volumeBarTrackEnd";
      
      public var sliderUpFace:String = "volumeBarSliderNormal";
      
      public var sliderDownFace:String = "volumeBarSliderDown";
      
      public var sliderStart:Number = 15.0;
      
      public var sliderEnd:Number = 91.0;
      
      private var _slider:Slider;
      
      private var volumeClickArea:Sprite;
      
      private var volumeTrack:DisplayObject;
      
      private var volumeTrackBottom:DisplayObject;
      
      private var sliderFace:DisplayObject;
      
      private var audible:AudioTrait;
      
      public function VolumeWidget()
      {
         super();
         mouseEnabled = true;
         face = AssetIDs.VOLUME_BAR_BACKDROP;
         layoutMetadata.layoutMode = LayoutMode.HORIZONTAL;
         this.volumeClickArea = new Sprite();
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         addChild(this.volumeClickArea);
      }
      
      public function get slider() : Slider
      {
         return this._slider;
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         super.configure(param1,param2);
         this.volumeTrack = param2.getDisplayObject(this.track) || new Sprite();
         this.volumeTrackBottom = param2.getDisplayObject(this.trackBottom) || new Sprite();
         this.sliderFace = param2.getDisplayObject(this.sliderUpFace) || new Sprite();
         this.volumeTrack.height = 0;
         this._slider = new Slider(this.sliderFace,this.sliderFace,this.sliderFace);
         this._slider.enabled = true;
         this._slider.y = this.sliderStart;
         this._slider.origin = this.sliderStart;
         this._slider.rangeY = this.sliderEnd - this.sliderStart - this._slider.height / 2;
         this._slider.rangeX = 0;
         this._slider.addEventListener(ScrubberEvent.SCRUB_UPDATE,this.onSliderUpdate);
         this._slider.addEventListener(ScrubberEvent.SCRUB_END,this.onSliderEnd);
         this._slider.mouseEnabled = true;
         this.volumeClickArea.x = width / 2 - this._slider.width / 2;
         this.volumeClickArea.graphics.clear();
         this.volumeClickArea.graphics.beginFill(16777215,0);
         this.volumeClickArea.graphics.drawRect(0,this.sliderStart,this._slider.width,this.sliderEnd - this.sliderStart + this._slider.height / 2);
         this.volumeClickArea.graphics.endFill();
         this.volumeClickArea.height = this.sliderEnd - this.sliderStart + this._slider.height / 2;
         this.volumeTrackBottom.x = this.volumeClickArea.width / 2 - this.volumeTrackBottom.width / 2;
         this.volumeTrackBottom.y = this.sliderEnd;
         this.volumeTrack.x = this.volumeTrackBottom.x;
         this.volumeClickArea.addChild(this.volumeTrackBottom);
         this.volumeClickArea.addChild(this.volumeTrack);
         this.volumeClickArea.addChild(this._slider);
      }
      
      override protected function get requiredTraits() : Vector.<String>
      {
         return _requiredTraits;
      }
      
      override protected function processRequiredTraitsAvailable(param1:MediaElement) : void
      {
         visible = true;
         this.audible = !!media?media.getTrait(MediaTraitType.AUDIO) as AudioTrait:null;
         this.audible.addEventListener(AudioEvent.MUTED_CHANGE,this.onMutedChange);
         this.onMutedChange();
      }
      
      override protected function processRequiredTraitsUnavailable(param1:MediaElement) : void
      {
         visible = false;
      }
      
      private function onMutedChange(param1:AudioEvent = null) : void
      {
         this.updateSliderPosition(!!this.audible.muted?Number(0):Number(this.audible.volume));
      }
      
      private function onSliderUpdate(param1:ScrubberEvent = null) : void
      {
         var _loc2_:Number = NaN;
         if(this.audible)
         {
            _loc2_ = 1 - (this.slider.y - this.sliderStart) / (this.sliderEnd - this.sliderStart - this.slider.height);
            this.audible.volume = _loc2_;
            this.audible.muted = _loc2_ <= 0;
            if(!this.audible.muted)
            {
               this.volumeTrack.height = Math.max(0,this.sliderEnd - this._slider.y - this._slider.height / 2);
               this.volumeTrack.y = this._slider.y + this._slider.height / 2;
            }
         }
      }
      
      private function updateSliderPosition(param1:Number) : void
      {
         if(param1 <= 0)
         {
            this._slider.y = this.sliderEnd - this.slider.height / 2;
            this.volumeTrack.height = 0;
            this.volumeTrack.y = this.sliderEnd;
         }
         else
         {
            this._slider.y = this.sliderEnd - this.slider.height - param1 * (this.sliderEnd - this.sliderStart - this.slider.height);
            this.volumeTrack.height = Math.max(0,this.sliderEnd - this._slider.y - this._slider.height / 2);
            this.volumeTrack.y = this._slider.y + this._slider.height / 2;
         }
      }
      
      private function onSliderEnd(param1:ScrubberEvent) : void
      {
         this.onSliderUpdate();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(mouseY > this.sliderStart - this._slider.height / 2 && this._slider.y + this._slider.mouseY < this.sliderEnd + this._slider.height / 2)
         {
            this._slider.y = this.volumeClickArea.mouseY - this._slider.height / 2;
            this.slider.start(false);
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(mouseY > this.sliderStart - this._slider.height / 2 && this._slider.y + this._slider.mouseY < this.sliderEnd + this._slider.height / 2)
         {
            this._slider.y = this.volumeClickArea.mouseY - this._slider.height / 2;
            this.onSliderUpdate();
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(mouseY > this.sliderStart - this._slider.height / 2 && this._slider.y + this._slider.mouseY < this.sliderEnd + this._slider.height / 2)
         {
            if(this._slider.sliding)
            {
               this.onSliderUpdate();
            }
            else if(param1.buttonDown)
            {
               this.updateSliderPosition(this.audible.volume);
               this._slider.start(false);
            }
         }
      }
   }
}
