package org.osmf.player.elements
{
   import org.osmf.layout.LayoutMetadata;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.ChromeProvider;
   import org.osmf.player.chrome.widgets.AuthenticationDialog;
   import org.osmf.traits.DisplayObjectTrait;
   import org.osmf.traits.MediaTraitType;
   
   public class AuthenticationDialogElement extends MediaElement
   {
       
      
      private var chromeProvider:ChromeProvider;
      
      private var _target:MediaElement;
      
      private var authDialog:AuthenticationDialog;
      
      public function AuthenticationDialogElement()
      {
         super();
      }
      
      public function set target(param1:MediaElement) : void
      {
         this.authDialog.media = param1;
      }
      
      public function set tintColor(param1:uint) : void
      {
         this.authDialog.tintColor = param1;
      }
      
      override protected function setupTraits() : void
      {
         this.chromeProvider = ChromeProvider.getInstance();
         this.chromeProvider.createAuthenticationDialog();
         this.authDialog = this.chromeProvider.getWidget("login") as AuthenticationDialog;
         this.authDialog.measure();
         addMetadata(LayoutMetadata.LAYOUT_NAMESPACE,this.authDialog.layoutMetadata);
         var _loc1_:DisplayObjectTrait = new DisplayObjectTrait(this.authDialog,this.authDialog.measuredWidth,this.authDialog.measuredHeight);
         addTrait(MediaTraitType.DISPLAY_OBJECT,_loc1_);
         super.setupTraits();
      }
   }
}
