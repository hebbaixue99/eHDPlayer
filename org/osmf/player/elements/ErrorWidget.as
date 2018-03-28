package org.osmf.player.elements
{
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.widgets.LabelWidget;
   import org.osmf.player.chrome.widgets.Widget;
   
   public class ErrorWidget extends Widget
   {
       
      
      private var errorLabel:LabelWidget;
      
      public function ErrorWidget()
      {
         super();
      }
      
      public function set errorMessage(param1:String) : void
      {
         this.errorLabel.text = param1;
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         super.configure(param1,param2);
         this.errorLabel = getChildWidget("errorLabel") as LabelWidget;
      }
   }
}
