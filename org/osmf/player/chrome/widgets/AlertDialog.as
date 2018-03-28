package org.osmf.player.chrome.widgets
{
   import flash.events.MouseEvent;
   import org.osmf.player.chrome.assets.AssetsManager;
   
   public class AlertDialog extends Widget
   {
       
      
      private var closeButton:ButtonWidget;
      
      private var captionLabel:LabelWidget;
      
      private var messageLabel:LabelWidget;
      
      private var queue:Vector.<Object>;
      
      private var currentAlert:Object;
      
      public function AlertDialog()
      {
         super();
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         this.queue = new Vector.<Object>();
         this.update();
         super.configure(param1,param2);
         this.closeButton = getChildWidget("closeButton") as ButtonWidget;
         this.closeButton.addEventListener(MouseEvent.CLICK,this.onCloseButtonClick);
         this.captionLabel = getChildWidget("captionLabel") as LabelWidget;
         this.messageLabel = getChildWidget("messageLabel") as LabelWidget;
      }
      
      public function alert(param1:String, param2:String) : void
      {
         var _loc3_:Object = {
            "caption":param1,
            "message":param2
         };
         if(this.currentAlert != null)
         {
            this.queue.unshift(_loc3_);
         }
         else
         {
            this.currentAlert = _loc3_;
         }
         this.update();
      }
      
      public function close(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.queue = new Vector.<Object>();
         }
         this.onCloseButtonClick();
      }
      
      private function onCloseButtonClick(param1:MouseEvent = null) : void
      {
         this.currentAlert = !!this.queue.length?this.queue.pop():null;
         this.update();
      }
      
      private function update() : void
      {
         if(this.currentAlert == null)
         {
            visible = false;
         }
         else
         {
            this.captionLabel.text = this.currentAlert.caption;
            this.messageLabel.text = this.currentAlert.message;
            visible = true;
         }
      }
   }
}
