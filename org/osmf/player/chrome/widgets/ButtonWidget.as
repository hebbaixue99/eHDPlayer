package org.osmf.player.chrome.widgets
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import org.osmf.player.chrome.assets.AssetsManager;
   
   public class ButtonWidget extends Widget
   {
       
      
      public var upFace:String = "buttonUp";
      
      public var downFace:String = "buttonDown";
      
      public var overFace:String = "buttonOver";
      
      public var disabledFace:String = "buttonDisabled";
      
      protected var currentFace:DisplayObject;
      
      protected var mouseOver:Boolean;
      
      protected var up:DisplayObject;
      
      protected var down:DisplayObject;
      
      protected var over:DisplayObject;
      
      protected var disabled:DisplayObject;
      
      public function ButtonWidget()
      {
         super();
         mouseEnabled = true;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.CLICK,this.onMouseClick_internal);
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         super.configure(param1,param2);
         this.up = param2.getDisplayObject(this.upFace);
         this.down = param2.getDisplayObject(this.downFace);
         this.over = param2.getDisplayObject(this.overFace);
         this.disabled = param2.getDisplayObject(this.disabledFace);
         this.setFace(this.up);
      }
      
      public function onMouseOut(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this.mouseOver = false;
         this.setFace(!!enabled?this.up:this.disabled);
      }
      
      public function onMouseOver(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this.mouseOver = true;
         this.setFace(!!enabled?this.over:this.disabled);
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this.mouseOver = false;
         this.setFace(!!enabled?this.down:this.disabled);
      }
      
      private function onMouseClick_internal(param1:MouseEvent) : void
      {
         if(enabled == false)
         {
            param1.stopImmediatePropagation();
         }
         else
         {
            this.onMouseClick(param1);
         }
      }
      
      override protected function processEnabledChange() : void
      {
         this.setFace(!!enabled?!!this.mouseOver?this.over:this.up:this.disabled);
         super.processEnabledChange();
      }
      
      protected function setFace(param1:DisplayObject) : void
      {
         if(this.currentFace != param1)
         {
            if(this.currentFace != null)
            {
               removeChild(this.currentFace);
            }
            this.currentFace = param1;
            if(this.currentFace != null)
            {
               addChildAt(this.currentFace,0);
               width = this.currentFace.width;
               height = this.currentFace.height;
            }
         }
      }
      
      protected function onMouseClick(param1:MouseEvent) : void
      {
      }
   }
}
