package org.osmf.player.chrome.hint
{
   import flash.display.Stage;
   import flash.errors.IllegalOperationError;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.assets.FontAsset;
   import org.osmf.player.chrome.widgets.FadingLayoutTargetSprite;
   
   public class Hint
   {
      
      private static var _instance:Hint;
      
      private static const OPENING_DELAY:Number = 1200;
       
      
      private var stage:Stage;
      
      private var view:FadingLayoutTargetSprite;
      
      private var _text:String;
      
      private var label:TextField;
      
      private var openingTimer:Timer;
      
      public function Hint(param1:Class, param2:AssetsManager)
      {
         super();
         if(param1 != ConstructorLock_226)
         {
            throw new IllegalOperationError("Hint is a singleton. Please use the getInstance method");
         }
         this.view = new FadingLayoutTargetSprite();
         this.view.fadeSteps = 10;
         this.view.mouseChildren = false;
         this.view.mouseEnabled = false;
         var _loc3_:FontAsset = (param2.getAsset("hintFont") || param2.getAsset("defaultFont")) as FontAsset;
         this.label = new TextField();
         this.label.embedFonts = true;
         this.label.defaultTextFormat = _loc3_.format;
         this.label.height = 12;
         this.label.multiline = true;
         this.label.wordWrap = true;
         this.label.width = 100;
         this.label.alpha = 0.8;
         this.label.autoSize = TextFieldAutoSize.LEFT;
         this.label.background = true;
         this.label.backgroundColor = 0;
         this.view.addChild(this.label);
      }
      
      public static function getInstance(param1:Stage, param2:AssetsManager) : Hint
      {
         if(param1 == null)
         {
            throw new ArgumentError("Stage cannot be null");
         }
         if(_instance == null)
         {
            _instance = new Hint(ConstructorLock_226,param2);
            _instance.stage = param1;
            param1.addEventListener(MouseEvent.MOUSE_MOVE,_instance.onStageMouseMove);
         }
         return _instance;
      }
      
      public function set text(param1:String) : void
      {
         if(param1 != this._text)
         {
            if(this.openingTimer != null)
            {
               this.openingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onOpeningTimerComplete);
               this.openingTimer.stop();
               this.openingTimer = null;
            }
            if(this.stage.contains(this.view))
            {
               this.stage.removeChild(this.view);
            }
            this._text = param1;
            this.label.text = this._text || "";
            if(param1 != null && param1 != "")
            {
               this.openingTimer = new Timer(OPENING_DELAY,1);
               this.openingTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onOpeningTimerComplete);
               this.openingTimer.start();
            }
            this.view.measure();
         }
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      private function onStageMouseMove(param1:MouseEvent) : void
      {
         if(this._text != null && this._text != "")
         {
            if(this.openingTimer && this.openingTimer.running)
            {
               this.openingTimer.reset();
               this.openingTimer.start();
            }
            else
            {
               this.text = null;
            }
         }
      }
      
      private function onOpeningTimerComplete(param1:TimerEvent) : void
      {
         this.openingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onOpeningTimerComplete);
         this.openingTimer.stop();
         this.openingTimer = null;
         this.stage.addChild(this.view);
         this.view.x = this.stage.mouseX - 13;
         this.view.y = this.stage.mouseY - this.view.height - 2;
      }
   }
}

class ConstructorLock_226
{
    
   
   function ConstructorLock_226()
   {
      super();
   }
}
