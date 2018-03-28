package org.osmf.player.chrome.widgets
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import org.osmf.events.AudioEvent;
   import org.osmf.layout.HorizontalAlign;
   import org.osmf.layout.LayoutMode;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.hint.WidgetHint;
   import org.osmf.traits.AudioTrait;
   import org.osmf.traits.MediaTraitType;
   
   public class MuteButton extends ButtonWidget
   {
      
      private static const _requiredTraits:Vector.<String> = new Vector.<String>();
      
      {
         _requiredTraits[0] = MediaTraitType.AUDIO;
      }
      
      public var volumeWidgetFace:String = "volumeBarBackdrop";
      
      public var sliderUpFace:String = "volumeBarSliderNormal";
      
      public var sliderDownFace:String = "volumeBarSliderDown";
      
      public var sliderOverFace:String = "volumeBarSliderOver";
      
      public var upMuteFace:String = "unmuteButtonNormal";
      
      public var downMuteFace:String = "unmuteButtonDown";
      
      public var overMuteFace:String = "unmuteButtonOver";
      
      public var steppedButtonFaces:Array;
      
      public var volumeSteps:uint = 0;
      
      protected var audible:AudioTrait;
      
      protected var widgetHint:WidgetHint;
      
      protected var volumeWidget:VolumeWidget;
      
      private var currentFaceIndex:int;
      
      public function MuteButton()
      {
         this.steppedButtonFaces = [{
            "up":AssetIDs.VOLUME_BUTTON_LOW_NORMAL,
            "down":AssetIDs.VOLUME_BUTTON_LOW_DOWN,
            "over":AssetIDs.VOLUME_BUTTON_LOW_OVER
         },{
            "up":AssetIDs.VOLUME_BUTTON_MED_NORMAL,
            "down":AssetIDs.VOLUME_BUTTON_MED_DOWN,
            "over":AssetIDs.VOLUME_BUTTON_MED_OVER
         },{
            "up":AssetIDs.VOLUME_BUTTON_HIGH_NORMAL,
            "down":AssetIDs.VOLUME_BUTTON_HIGH_DOWN,
            "over":AssetIDs.VOLUME_BUTTON_HIGH_OVER
         }];
         super();
         upFace = AssetIDs.VOLUME_BUTTON_NORMAL;
         downFace = AssetIDs.VOLUME_BUTTON_DOWN;
         overFace = AssetIDs.VOLUME_BUTTON_OVER;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         super.configure(param1,param2);
         this.volumeWidget = new VolumeWidget();
         this.volumeWidget.configure(param1,param2);
         this.volumeWidget.layoutMetadata.layoutMode = LayoutMode.VERTICAL;
         this.volumeWidget.layoutMetadata.width = layoutMetadata.width;
      }
      
      override public function layout(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         WidgetHint.getInstance(this).hide();
         measure();
         super.layout(Math.max(measuredWidth,param1),Math.max(measuredHeight,param2));
      }
      
      override public function set media(param1:MediaElement) : void
      {
         if(param1 != null)
         {
            super.media = param1;
            if(this.volumeWidget)
            {
               this.volumeWidget.media = media;
            }
         }
      }
      
      override protected function get requiredTraits() : Vector.<String>
      {
         return _requiredTraits;
      }
      
      override protected function processRequiredTraitsAvailable(param1:MediaElement) : void
      {
         visible = true;
         this.audible = param1.getTrait(MediaTraitType.AUDIO) as AudioTrait;
         if(this.audible)
         {
            this.audible.addEventListener(AudioEvent.MUTED_CHANGE,this.onMutedChange);
            this.audible.addEventListener(AudioEvent.VOLUME_CHANGE,this.onVolumeChange);
         }
         this.onMutedChange();
      }
      
      override protected function processRequiredTraitsUnavailable(param1:MediaElement) : void
      {
         WidgetHint.getInstance(this).hide();
         visible = false;
         if(this.audible)
         {
            this.audible.removeEventListener(AudioEvent.MUTED_CHANGE,this.onMutedChange);
            this.audible = null;
         }
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         if(param1.localY >= 0 && (param1.localY <= height || isNaN(height)))
         {
            this.audible.muted = !this.audible.muted;
         }
         else
         {
            this.volumeWidget.dispatchEvent(param1);
         }
      }
      
      override public function onMouseOut(param1:MouseEvent) : void
      {
         if(this.volumeWidget && !this.volumeWidget.slider.sliding)
         {
            WidgetHint.getInstance(this).hide();
            super.onMouseOut(param1);
         }
      }
      
      override protected function setFace(param1:DisplayObject) : void
      {
         if(param1)
         {
            super.setFace(param1);
         }
      }
      
      override public function onMouseOver(param1:MouseEvent) : void
      {
         WidgetHint.getInstance(this).horizontalAlign = HorizontalAlign.CENTER;
         WidgetHint.getInstance(this).widget = this.volumeWidget;
         if(this.volumeWidget && this.volumeWidget.slider.sliding)
         {
            this.setFace(down);
         }
         else
         {
            super.onMouseOver(param1);
         }
      }
      
      protected function onMutedChange(param1:AudioEvent = null) : void
      {
         if(this.audible.muted)
         {
            this.currentFaceIndex = -1;
            up = assetManager.getDisplayObject(this.upMuteFace);
            down = assetManager.getDisplayObject(this.downMuteFace);
            over = assetManager.getDisplayObject(this.overMuteFace);
            this.setFace(!!this.volumeWidget.slider.sliding?down:!!param1?over:up);
         }
         else
         {
            this.onVolumeChange();
         }
      }
      
      protected function onVolumeChange(param1:AudioEvent = null) : void
      {
         var _loc2_:uint = 0;
         if(this.volumeSteps > 0)
         {
            _loc2_ = Math.min(this.volumeSteps,Math.ceil(this.audible.volume / this.volumeSteps * 10));
            if(_loc2_ - 1 != this.currentFaceIndex && _loc2_ > 0 && _loc2_ <= this.steppedButtonFaces.length)
            {
               this.currentFaceIndex = _loc2_ - 1;
               up = assetManager.getDisplayObject(this.steppedButtonFaces[this.currentFaceIndex].up);
               down = assetManager.getDisplayObject(this.steppedButtonFaces[this.currentFaceIndex].down);
               over = assetManager.getDisplayObject(this.steppedButtonFaces[this.currentFaceIndex].over);
               this.setFace(!!this.volumeWidget.slider.sliding?down:!!param1?over:up);
            }
         }
      }
      
      protected function onMouseMove(param1:MouseEvent) : void
      {
         if(WidgetHint.getInstance(this).widget)
         {
            WidgetHint.getInstance(this).updatePosition();
         }
         else
         {
            WidgetHint.getInstance(this).horizontalAlign = HorizontalAlign.CENTER;
            WidgetHint.getInstance(this).widget = this.volumeWidget;
         }
         if(param1.localY < 0)
         {
            this.volumeWidget.dispatchEvent(param1.clone());
         }
         else
         {
            this.volumeWidget.slider.stop();
         }
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         if(param1.localY < 0)
         {
            this.volumeWidget.dispatchEvent(param1);
         }
      }
      
      protected function onMouseUp(param1:MouseEvent) : void
      {
         this.setFace(over);
      }
   }
}
