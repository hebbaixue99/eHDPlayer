package org.osmf.player.elements
{
   import org.osmf.layout.LayoutMetadata;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.ChromeProvider;
   import org.osmf.player.chrome.ControlBar;
   import org.osmf.traits.DisplayObjectTrait;
   import org.osmf.traits.MediaTraitType;
   
   public class ControlBarElement extends MediaElement
   {
       
      
      private var _target:MediaElement;
      
      private var controlBar:ControlBar;
      
      private var chromeProvider:ChromeProvider;
      
      public function ControlBarElement()
      {
         super();
      }
      
      public function set autoHide(param1:Boolean) : void
      {
         this.controlBar.autoHide = param1;
      }
      
      public function get autoHide() : Boolean
      {
         return this.controlBar.autoHide;
      }
      
      public function set autoHideTimeout(param1:int) : void
      {
         this.controlBar.autoHideTimeout = param1;
      }
      
      public function set target(param1:MediaElement) : void
      {
         this._target = param1;
         this.controlBar.media = this._target;
      }
      
      public function set tintColor(param1:uint) : void
      {
         this.controlBar.tintColor = param1;
      }
      
      public function set width(param1:int) : void
      {
         this.controlBar.width = param1;
         this.controlBar.measure();
         this.controlBar.layout(param1,this.height);
      }
      
      public function get width() : int
      {
         return this.controlBar.width;
      }
      
      public function get height() : int
      {
         return this.controlBar.height;
      }
      
      override protected function setupTraits() : void
      {
         this.chromeProvider = ChromeProvider.getInstance();
         this.controlBar = this.chromeProvider.createControlBar();
         addMetadata(LayoutMetadata.LAYOUT_NAMESPACE,this.controlBar.layoutMetadata);
         var _loc1_:DisplayObjectTrait = new DisplayObjectTrait(this.controlBar);
         addTrait(MediaTraitType.DISPLAY_OBJECT,_loc1_);
         super.setupTraits();
      }
   }
}
