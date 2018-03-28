package org.osmf.player.chrome.widgets
{
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.SharedObject;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.assets.FontAsset;
   
   public class AdditionalWidget extends Widget
   {
       
      
      public var track:String = "additionalback";
      
      private var skinChangeBlue:ButtonWidget;
      
      private var skinChangeOrange:ButtonWidget;
      
      private var skinChangeGray:ButtonWidget;
      
      private var infoObj:TextField;
      
      private var titleObj:TextField;
      
      public function AdditionalWidget()
      {
         this.skinChangeBlue = new ButtonWidget();
         this.skinChangeOrange = new ButtonWidget();
         this.skinChangeGray = new ButtonWidget();
         super();
         mouseEnabled = true;
         this.layoutMetadata.percentHeight = 100;
         face = AssetIDs.ADDITIONAL_BACK;
         this.skinChangeBlue.upFace = AssetIDs.SKIN_CHANGE_BUTTON_BLUE;
         this.skinChangeBlue.overFace = AssetIDs.SKIN_CHANGE_BUTTON_BLUEOVER;
         this.skinChangeBlue.downFace = AssetIDs.SKIN_CHANGE_BUTTON_BLUE;
         this.skinChangeOrange.upFace = AssetIDs.SKIN_CHANGE_BUTTON_ORANGE;
         this.skinChangeOrange.overFace = AssetIDs.SKIN_CHANGE_BUTTON_ORANGEOVER;
         this.skinChangeOrange.downFace = AssetIDs.SKIN_CHANGE_BUTTON_ORANGE;
         this.skinChangeGray.upFace = AssetIDs.SKIN_CHANGE_BUTTON_GRAY;
         this.skinChangeGray.overFace = AssetIDs.SKIN_CHANGE_BUTTON_GRAYOVER;
         this.skinChangeGray.downFace = AssetIDs.SKIN_CHANGE_BUTTON_GRAY;
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         super.configure(param1,param2);
         this.titleObj = new TextField();
         var _loc3_:FontAsset = param2.getAsset("defaultFont") as FontAsset;
         var _loc4_:TextFormat = !!_loc3_?_loc3_.format:new TextFormat();
         _loc4_.align = "center";
         _loc4_.color = 0;
         this.titleObj.defaultTextFormat = _loc4_;
         this.titleObj.autoSize = TextFieldAutoSize.NONE;
         this.titleObj.wordWrap = true;
         this.titleObj.multiline = true;
         this.titleObj.width = this.width;
         this.titleObj.y = 12;
         this.titleObj.height = 18;
         this.titleObj.text = "尝试以下线路";
         addChild(this.titleObj);
         this.skinChangeBlue.configure(param1,param2);
         addChild(this.skinChangeBlue);
         this.skinChangeBlue.x = 8;
         this.skinChangeBlue.y = 17 + this.titleObj.height;
         this.skinChangeOrange.configure(param1,param2);
         addChild(this.skinChangeOrange);
         this.skinChangeOrange.x = 8;
         this.skinChangeOrange.y = 60 + this.titleObj.height;
         this.skinChangeGray.configure(param1,param2);
         addChild(this.skinChangeGray);
         this.skinChangeGray.x = 8;
         this.skinChangeGray.y = 39 + this.titleObj.height;
         this.infoObj = new TextField();
         var _loc5_:FontAsset = param2.getAsset("defaultFont") as FontAsset;
         var _loc6_:TextFormat = !!_loc3_?_loc3_.format:new TextFormat();
         this.infoObj.defaultTextFormat = _loc6_;
         this.infoObj.autoSize = TextFieldAutoSize.NONE;
         this.infoObj.wordWrap = true;
         this.infoObj.multiline = true;
         this.infoObj.width = this.width;
      }
      
      override protected function processRequiredTraitsAvailable(param1:MediaElement) : void
      {
         visible = true;
      }
      
      override protected function processRequiredTraitsUnavailable(param1:MediaElement) : void
      {
         visible = false;
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var skinAry:Array = null;
         var event:MouseEvent = param1;
         event.stopPropagation();
         var rand_so:SharedObject = SharedObject.getLocal("randomvalue");
         var skinPath:String = rand_so.data.skinpath;
         if(event.localY < -56)
         {
            if(ExternalInterface.available)
            {
               try
               {
                  ExternalInterface.call("OnSwitchLine",5);
               }
               catch(_:Error)
               {
               }
            }
         }
         else if(event.localY < -34)
         {
            if(ExternalInterface.available)
            {
               try
               {
                  ExternalInterface.call("OnSwitchLine",4);
               }
               catch(_:Error)
               {
               }
            }
         }
         else if(event.localY < -11)
         {
            if(ExternalInterface.available)
            {
               try
               {
                  ExternalInterface.call("OnSwitchLine",3);
                  return;
               }
               catch(_:Error)
               {
                  return;
               }
            }
         }
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(param1.localY < -56)
         {
            this.skinChangeGray.onMouseOut(param1);
            this.skinChangeOrange.onMouseOut(param1);
            this.skinChangeBlue.onMouseOver(param1);
         }
         else if(param1.localY < -34)
         {
            this.skinChangeBlue.onMouseOut(param1);
            this.skinChangeOrange.onMouseOut(param1);
            this.skinChangeGray.onMouseOver(param1);
         }
         else if(param1.localY < -11)
         {
            this.skinChangeGray.onMouseOut(param1);
            this.skinChangeBlue.onMouseOut(param1);
            this.skinChangeOrange.onMouseOver(param1);
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
   }
}
