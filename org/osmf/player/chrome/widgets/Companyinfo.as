package org.osmf.player.chrome.widgets
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.osmf.layout.HorizontalAlign;
   import org.osmf.layout.LayoutMode;
   import org.osmf.layout.VerticalAlign;
   import org.osmf.media.MediaElement;
   import org.osmf.net.NetStreamLoadTrait;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.traits.MediaTraitType;
   
   public class Companyinfo extends Widget
   {
       
      
      public var currentState:String = "";
      
      private var currentTimeLabel:LabelWidget;
      
      private var timer:Timer;
      
      private var lastLoadedBytes:Number = 0;
      
      public function Companyinfo()
      {
         this.timer = new Timer(1000);
         super();
         layoutMetadata.verticalAlign = VerticalAlign.TOP;
         layoutMetadata.layoutMode = LayoutMode.HORIZONTAL;
         layoutMetadata.horizontalAlign = HorizontalAlign.LEFT;
         layoutMetadata.percentHeight = 100;
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         super.configure(param1,param2);
         this.currentTimeLabel = new LabelWidget();
         this.currentTimeLabel.autoSize = true;
         this.currentTimeLabel.textColor = "0x000000";
         this.currentTimeLabel.layoutMetadata.verticalAlign = VerticalAlign.TOP;
         this.currentTimeLabel.layoutMetadata.horizontalAlign = HorizontalAlign.RIGHT;
         addChildWidget(this.currentTimeLabel);
         this.currentTimeLabel.configure(param1,param2);
         this.currentTimeLabel.text = "下载速率：0KB/s";
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
      
      private function onTimerEvent(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:NetStreamLoadTrait = media.getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
         if(_loc2_ && _loc2_.netStream)
         {
            _loc3_ = (_loc2_.downDataBytes - this.lastLoadedBytes) / 1024;
            if(_loc3_ < 0 || _loc3_ > 1000)
            {
               _loc3_ = 0;
            }
            trace("loadbytes=" + _loc3_ + "KB/s");
            this.currentTimeLabel.text = "下载速率：" + _loc3_ + "KB/s";
            this.lastLoadedBytes = _loc2_.downDataBytes;
         }
      }
   }
}
