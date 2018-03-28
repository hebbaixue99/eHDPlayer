package org.osmf.player.chrome.widgets
{
   import flash.display.DisplayObject;
   import flash.net.SharedObject;
   import org.osmf.events.MediaElementEvent;
   import org.osmf.layout.HorizontalAlign;
   import org.osmf.layout.LayoutMode;
   import org.osmf.layout.VerticalAlign;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.traits.MediaTraitType;
   
   public class CouldInfo extends Widget
   {
       
      
      public var COULDOFF:String = "offcould";
      
      public var COULDON:String = "oncould";
      
      public var currentState:String = "";
      
      protected var onStateObj:DisplayObject;
      
      protected var offStateObj:DisplayObject;
      
      protected var onCloudObj:DisplayObject;
      
      protected var currentObj:DisplayObject;
      
      protected var infoObj:LabelWidget;
      
      protected var bmpObj:Widget;
      
      private var _assetsManager:AssetsManager;
      
      public function CouldInfo()
      {
         super();
         layoutMetadata.verticalAlign = VerticalAlign.TOP;
         layoutMetadata.layoutMode = LayoutMode.HORIZONTAL;
         layoutMetadata.horizontalAlign = HorizontalAlign.LEFT;
         layoutMetadata.percentHeight = 100;
         this.bmpObj = new Widget();
         this.bmpObj.layoutMetadata.horizontalAlign = HorizontalAlign.RIGHT;
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         var _loc3_:SharedObject = SharedObject.getLocal("randomvalue");
         var _loc4_:String = _loc3_.data.skinpath;
         super.configure(param1,param2);
         this._assetsManager = param2;
         this.infoObj = new LabelWidget();
         this.infoObj.autoSize = true;
         var _loc5_:int = _loc4_.lastIndexOf("/");
         if(_loc4_ != null && _loc4_.substr(_loc5_ + 1,5) == "black")
         {
            this.infoObj.textColor = "0xffffff";
         }
         else
         {
            this.infoObj.textColor = "0x000000";
         }
         this.infoObj.layoutMetadata.verticalAlign = VerticalAlign.TOP;
         this.infoObj.layoutMetadata.horizontalAlign = HorizontalAlign.RIGHT;
         this.infoObj.configure(param1,param2);
         this.currentObj = param2.getDisplayObject(this.COULDOFF);
         this.setUpFace(this.COULDOFF,"正在接入云平台");
      }
      
      override protected function processRequiredTraitsAvailable(param1:MediaElement) : void
      {
         setSuperVisible(true);
      }
      
      override protected function processRequiredTraitsUnavailable(param1:MediaElement) : void
      {
         setSuperVisible(false);
      }
      
      override protected function onMediaElementTraitAdd(param1:MediaElementEvent) : void
      {
         if(param1.traitType == MediaTraitType.LOAD)
         {
            this.setUpFace(this.COULDON,"云平台已接入");
         }
      }
      
      public function setUpFace(param1:String, param2:String) : void
      {
         if(this.currentState != param1)
         {
            if(this.currentState != "")
            {
               this.removeChildWidget(this.infoObj);
               this.removeChildWidget(this.bmpObj);
               this.bmpObj.removeChild(this.currentObj);
            }
            if(this.infoObj)
            {
               this.infoObj.text = param2;
            }
            this.currentState = param1;
            if(this.currentState != "")
            {
               this.currentObj = assetManager.getDisplayObject(this.currentState);
               this.currentObj.y = 2;
               this.bmpObj.addChild(this.currentObj);
               this.addChildWidget(this.bmpObj);
               this.addChildWidget(this.infoObj);
            }
         }
      }
   }
}
