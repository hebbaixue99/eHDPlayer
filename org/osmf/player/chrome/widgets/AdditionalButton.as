package org.osmf.player.chrome.widgets
{
   import flash.events.MouseEvent;
   import org.osmf.layout.HorizontalAlign;
   import org.osmf.layout.LayoutMode;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.hint.WidgetHint;
   
   public class AdditionalButton extends ButtonWidget
   {
       
      
      protected var widgetHint:WidgetHint;
      
      protected var volumeWidget:AdditionalWidget;
      
      public function AdditionalButton()
      {
         super();
         upFace = AssetIDs.ADDITIONAL_BUTTON_NORMAL;
         downFace = AssetIDs.ADDITIONAL_BUTTON_DOWN;
         overFace = AssetIDs.ADDITIONAL_BUTTON_OVER;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         super.configure(param1,param2);
         this.volumeWidget = new AdditionalWidget();
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
      
      override protected function processRequiredTraitsAvailable(param1:MediaElement) : void
      {
         this.volumeWidget.media = this.media;
         visible = true;
      }
      
      override protected function processRequiredTraitsUnavailable(param1:MediaElement) : void
      {
         WidgetHint.getInstance(this).hide();
         visible = false;
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         if(!(param1.localY >= 0 && (param1.localY <= height || isNaN(height))))
         {
            this.volumeWidget.dispatchEvent(param1);
         }
      }
      
      override public function onMouseOut(param1:MouseEvent) : void
      {
         if(this.volumeWidget)
         {
            WidgetHint.getInstance(this).hide();
            super.onMouseOut(param1);
         }
      }
      
      override public function onMouseOver(param1:MouseEvent) : void
      {
         WidgetHint.getInstance(this).horizontalAlign = HorizontalAlign.CENTER;
         WidgetHint.getInstance(this).widget = this.volumeWidget;
         if(this.volumeWidget)
         {
            setFace(over);
         }
         else
         {
            super.onMouseOver(param1);
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
         setFace(over);
      }
   }
}
