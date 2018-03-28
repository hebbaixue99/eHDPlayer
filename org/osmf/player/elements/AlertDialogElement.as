package org.osmf.player.elements
{
   import org.osmf.layout.LayoutMetadata;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.ChromeProvider;
   import org.osmf.player.chrome.widgets.AlertDialog;
   import org.osmf.traits.DisplayObjectTrait;
   import org.osmf.traits.MediaTraitType;
   
   public class AlertDialogElement extends MediaElement
   {
       
      
      private var chromeProvider:ChromeProvider;
      
      private var _target:MediaElement;
      
      private var alertDialog:AlertDialog;
      
      public function AlertDialogElement()
      {
         super();
      }
      
      public function alert(param1:String, param2:String) : void
      {
         this.alertDialog.alert(param1,param2);
      }
      
      public function set tintColor(param1:uint) : void
      {
         this.alertDialog.tintColor = param1;
      }
      
      override protected function setupTraits() : void
      {
         this.chromeProvider = ChromeProvider.getInstance();
         this.chromeProvider.createAlertDialog();
         this.alertDialog = this.chromeProvider.getWidget("alert") as AlertDialog;
         this.alertDialog.measure();
         addMetadata(LayoutMetadata.LAYOUT_NAMESPACE,this.alertDialog.layoutMetadata);
         var _loc1_:DisplayObjectTrait = new DisplayObjectTrait(this.alertDialog,this.alertDialog.measuredWidth,this.alertDialog.measuredHeight);
         addTrait(MediaTraitType.DISPLAY_OBJECT,_loc1_);
         super.setupTraits();
      }
   }
}
