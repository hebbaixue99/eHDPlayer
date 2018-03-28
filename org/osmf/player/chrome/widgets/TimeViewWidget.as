package org.osmf.player.chrome.widgets
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import org.osmf.events.MediaElementEvent;
   import org.osmf.events.SeekEvent;
   import org.osmf.layout.HorizontalAlign;
   import org.osmf.layout.LayoutMode;
   import org.osmf.layout.VerticalAlign;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.utils.FormatUtils;
   import org.osmf.player.media.StrobeMediaPlayer;
   import org.osmf.player.metadata.PlayerMetadata;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.SeekTrait;
   import org.osmf.traits.TimeTrait;
   
   public class TimeViewWidget extends Widget
   {
      
      private static const _requiredTraits:Vector.<String> = new Vector.<String>();
      
      private static const LIVE:String = "Live";
      
      private static const TIME_ZERO:String = " 0:00 ";
      
      {
         _requiredTraits[0] = MediaTraitType.TIME;
      }
      
      private var currentTimeLabel:LabelWidget;
      
      private var timeSeparatorLabel:LabelWidget;
      
      private var totalTimeLabel:LabelWidget;
      
      private var seekTrait:SeekTrait;
      
      private var timer:Timer;
      
      private var maxLength:uint = 0;
      
      private var maxWidth:Number = 100;
      
      public function TimeViewWidget()
      {
         this.timer = new Timer(1000);
         super();
      }
      
      function get text() : String
      {
         return this.currentTimeLabel.text + (!!this.timeSeparatorLabel.visible?this.timeSeparatorLabel.text:"") + (!!this.totalTimeLabel.visible?this.totalTimeLabel.text:"");
      }
      
      function updateNow() : void
      {
         var _loc1_:TimeTrait = null;
         _loc1_ = media.getTrait(MediaTraitType.TIME) as TimeTrait;
         this.updateValues(_loc1_.currentTime,_loc1_.duration,this.live);
      }
      
      function updateValues(param1:Number, param2:Number, param3:Boolean) : void
      {
         var _loc4_:Vector.<String> = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         if(isNaN(param2) || param2 == 0)
         {
            if(param3)
            {
               this.currentTimeLabel.text = LIVE + "   ";
               this.currentTimeLabel.autoSize = false;
               this.currentTimeLabel.width = this.currentTimeLabel.measuredWidth;
               this.currentTimeLabel.align = TextFormatAlign.RIGHT;
            }
            if(param1 > 0 || param3)
            {
               this.totalTimeLabel.visible = false;
               this.timeSeparatorLabel.visible = false;
            }
         }
         else
         {
            this.totalTimeLabel.visible = true;
            this.timeSeparatorLabel.visible = true;
            _loc4_ = FormatUtils.formatTimeStatus(param1,param2,param3,LIVE);
            _loc5_ = " " + _loc4_[0] + " ";
            _loc6_ = " " + _loc4_[1] + " ";
            this.totalTimeLabel.text = _loc6_;
            if(this.currentTimeLabel.autoSize)
            {
               this.currentTimeLabel.text = _loc6_;
               this.currentTimeLabel.autoSize = false;
               this.currentTimeLabel.width = this.currentTimeLabel.measuredWidth;
               this.currentTimeLabel.align = TextFormatAlign.RIGHT;
            }
            this.currentTimeLabel.text = _loc5_;
         }
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         setSuperVisible(false);
         var _loc3_:SharedObject = SharedObject.getLocal("randomvalue");
         var _loc4_:String = _loc3_.data.skinpath;
         layoutMetadata.percentHeight = 100;
         layoutMetadata.layoutMode = LayoutMode.HORIZONTAL;
         layoutMetadata.horizontalAlign = HorizontalAlign.RIGHT;
         layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         this.currentTimeLabel = new LabelWidget();
         this.currentTimeLabel.fontSize = 10;
         this.currentTimeLabel.autoSize = true;
         var _loc5_:int = _loc4_.lastIndexOf("/");
         if(_loc4_ != null && _loc4_.substr(_loc5_ + 1,5) == "black")
         {
            this.currentTimeLabel.textColor = "0xffffff";
         }
         else
         {
            this.currentTimeLabel.textColor = "0x000000";
         }
         this.currentTimeLabel.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         this.currentTimeLabel.layoutMetadata.horizontalAlign = HorizontalAlign.RIGHT;
         addChildWidget(this.currentTimeLabel);
         this.timeSeparatorLabel = new LabelWidget();
         this.timeSeparatorLabel.fontSize = 10;
         this.timeSeparatorLabel.autoSize = true;
         if(_loc4_ != null && _loc4_.substr(_loc5_ + 1,5) == "black")
         {
            this.timeSeparatorLabel.textColor = "0xffffff";
         }
         else
         {
            this.timeSeparatorLabel.textColor = "0x000000";
         }
         this.timeSeparatorLabel.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         this.timeSeparatorLabel.layoutMetadata.horizontalAlign = HorizontalAlign.RIGHT;
         addChildWidget(this.timeSeparatorLabel);
         this.totalTimeLabel = new LabelWidget();
         this.totalTimeLabel.fontSize = 10;
         this.totalTimeLabel.autoSize = true;
         if(_loc4_ != null && _loc4_.substr(_loc5_ + 1,5) == "black")
         {
            this.totalTimeLabel.textColor = "0xffffff";
         }
         else
         {
            this.totalTimeLabel.textColor = "0x000000";
         }
         this.totalTimeLabel.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         this.totalTimeLabel.layoutMetadata.horizontalAlign = HorizontalAlign.RIGHT;
         addChildWidget(this.totalTimeLabel);
         this.currentTimeLabel.configure(param1,param2);
         this.totalTimeLabel.configure(param1,param2);
         this.timeSeparatorLabel.configure(param1,param2);
         super.configure(param1,param2);
         this.currentTimeLabel.text = TIME_ZERO;
         this.timeSeparatorLabel.text = "/";
         this.totalTimeLabel.text = TIME_ZERO;
         measure();
      }
      
      override protected function processRequiredTraitsAvailable(param1:MediaElement) : void
      {
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimerEvent);
         this.timer.start();
         setSuperVisible(true);
      }
      
      override protected function processRequiredTraitsUnavailable(param1:MediaElement) : void
      {
         this.timer.stop();
         setSuperVisible(false);
      }
      
      override protected function get requiredTraits() : Vector.<String>
      {
         return _requiredTraits;
      }
      
      override protected function onMediaElementTraitAdd(param1:MediaElementEvent) : void
      {
         this.currentTimeLabel.autoSize = true;
         if(param1.traitType == MediaTraitType.SEEK)
         {
            this.seekTrait = media.getTrait(MediaTraitType.SEEK) as SeekTrait;
            this.seekTrait.addEventListener(SeekEvent.SEEKING_CHANGE,this.onSeekingChange);
         }
      }
      
      override protected function onMediaElementTraitRemove(param1:MediaElementEvent) : void
      {
         if(param1.traitType == MediaTraitType.SEEK && this.seekTrait != null)
         {
            this.seekTrait.removeEventListener(SeekEvent.SEEKING_CHANGE,this.onSeekingChange);
            this.seekTrait = null;
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
      
      private function onTimerEvent(param1:Event) : void
      {
         this.updateNow();
      }
      
      private function onSeekingChange(param1:SeekEvent) : void
      {
         var _loc2_:TimeTrait = null;
         _loc2_ = media.getTrait(MediaTraitType.TIME) as TimeTrait;
         if(param1.seeking)
         {
            this.updateValues(param1.time,_loc2_.duration,this.live);
            this.timer.stop();
         }
         else
         {
            this.updateValues(param1.time,_loc2_.duration,this.live);
            this.timer.start();
         }
      }
   }
}
