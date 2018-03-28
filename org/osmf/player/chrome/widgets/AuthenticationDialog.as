package org.osmf.player.chrome.widgets
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.StageDisplayState;
   import flash.events.MouseEvent;
   import org.osmf.events.DRMEvent;
   import org.osmf.events.LoadEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.traits.DRMState;
   import org.osmf.traits.DRMTrait;
   import org.osmf.traits.LoadState;
   import org.osmf.traits.LoadTrait;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.PlayTrait;
   
   public class AuthenticationDialog extends Widget
   {
      
      private static const AUTHENTICATION_ERROR_MESSAGE:String = "Please enter a valid user name and password";
      
      private static const _requiredTraits:Vector.<String> = new Vector.<String>();
      
      {
         _requiredTraits[0] = MediaTraitType.DRM;
      }
      
      public var playAfterAuthentication:Boolean;
      
      private var userName:LabelWidget;
      
      private var password:LabelWidget;
      
      private var errorMessage:LabelWidget;
      
      private var errorIcon:Widget;
      
      private var errorIconFace:DisplayObject;
      
      private var submit:ButtonWidget;
      
      private var cancel:ButtonWidget;
      
      private var _open:Boolean;
      
      private var drm:DRMTrait;
      
      private var authenticating:Boolean;
      
      public function AuthenticationDialog()
      {
         super();
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         super.configure(param1,param2);
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.submit = getChildWidget("submitButton") as ButtonWidget;
         this.submit.addEventListener(MouseEvent.CLICK,this.onSubmitClick);
         this.cancel = getChildWidget("cancelButton") as ButtonWidget;
         this.cancel.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         this.userName = getChildWidget("username") as LabelWidget;
         this.password = getChildWidget("password") as LabelWidget;
         this.errorMessage = getChildWidget("errorLabel") as LabelWidget || new LabelWidget();
         this.errorIcon = getChildWidget("errorIcon") as Widget || new Widget();
         this._open = false;
         this.updateVisibility();
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            if(stage && stage.displayState == StageDisplayState.FULL_SCREEN)
            {
               stage.displayState = StageDisplayState.NORMAL;
               stage.focus = event.target as InteractiveObject;
            }
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      private function onSubmitClick(param1:MouseEvent) : void
      {
         this._open = false;
         this.updateVisibility();
         this.authenticating = true;
         this.drm.authenticate(this.userName.text,this.password.text);
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         this._open = false;
         this.updateVisibility();
         this.userName.text = this.userName.defaultText;
         this.password.text = this.password.defaultText;
         this.authenticating = true;
         this.drm.authenticate();
      }
      
      private function updateVisibility() : void
      {
         if(this.drm && this.drm.drmState == DRMState.AUTHENTICATION_ERROR)
         {
            this.errorIcon.visible = true;
            this.errorMessage.text = AUTHENTICATION_ERROR_MESSAGE;
         }
         else
         {
            this.errorIcon.visible = false;
            this.errorMessage.text = "";
         }
         visible = this._open;
      }
      
      override protected function get requiredTraits() : Vector.<String>
      {
         return _requiredTraits;
      }
      
      override protected function processRequiredTraitsAvailable(param1:MediaElement) : void
      {
         this.drm = param1.getTrait(MediaTraitType.DRM) as DRMTrait;
         this.drm.addEventListener(DRMEvent.DRM_STATE_CHANGE,this.onDRMStateChange);
         this.onDRMStateChange();
      }
      
      override protected function processRequiredTraitsUnavailable(param1:MediaElement) : void
      {
         if(this.drm)
         {
            this.drm.removeEventListener(DRMEvent.DRM_STATE_CHANGE,this.onDRMStateChange);
            this.drm = null;
            this.authenticating = false;
         }
         this.updateVisibility();
      }
      
      private function onDRMStateChange(param1:DRMEvent = null) : void
      {
         if(this.drm)
         {
            this._open = this.drm.drmState == DRMState.AUTHENTICATION_NEEDED;
            if(this._open == false && this.authenticating == true)
            {
               if(this.drm.drmState == DRMState.AUTHENTICATION_COMPLETE)
               {
                  this.authenticating = false;
                  if(this.playAfterAuthentication)
                  {
                     this.resumePlayback();
                  }
               }
               else if(this.drm.drmState == DRMState.AUTHENTICATION_ERROR)
               {
                  this.authenticating = false;
                  this._open = true;
               }
            }
         }
         else
         {
            this._open = false;
         }
         this.updateVisibility();
      }
      
      private function resumePlayback() : void
      {
         var loadable:LoadTrait = null;
         var onLoadStateChange:Function = null;
         onLoadStateChange = function(param1:LoadEvent):void
         {
            var _loc2_:PlayTrait = !!media?media.getTrait(MediaTraitType.PLAY) as PlayTrait:null;
            if(param1.loadState == LoadState.READY && _loc2_)
            {
               loadable.removeEventListener(LoadEvent.LOAD_STATE_CHANGE,onLoadStateChange);
               _loc2_.play();
            }
         };
         loadable = !!media?media.getTrait(MediaTraitType.LOAD) as LoadTrait:null;
         if(loadable)
         {
            loadable.addEventListener(LoadEvent.LOAD_STATE_CHANGE,onLoadStateChange);
         }
      }
   }
}
