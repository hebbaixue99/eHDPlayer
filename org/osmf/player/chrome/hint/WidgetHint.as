package org.osmf.player.chrome.hint
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.osmf.layout.HorizontalAlign;
   import org.osmf.player.chrome.widgets.FadingLayoutTargetSprite;
   import org.osmf.player.chrome.widgets.Widget;
   
   public class WidgetHint extends EventDispatcher
   {
      
      private static var _instance:WidgetHint;
       
      
      public var horizontalAlign:String;
      
      private var face:DisplayObject;
      
      private var parent:Widget;
      
      private var addToStage:Boolean;
      
      private var _widget:Widget;
      
      private var view:FadingLayoutTargetSprite;
      
      public function WidgetHint(param1:Class)
      {
         super();
         if(param1 != ConstructorLock_659)
         {
            throw new IllegalOperationError("WidgetHint is a singleton. Please use the getInstance method");
         }
         this.view = new FadingLayoutTargetSprite();
         this.view.fadeSteps = 4;
         this.view.mouseChildren = false;
         this.view.mouseEnabled = false;
      }
      
      public static function getInstance(param1:Widget, param2:Boolean = false) : WidgetHint
      {
         var parent:Widget = param1;
         var addToStage:Boolean = param2;
         if(parent == null)
         {
            throw new ArgumentError("parent cannot be null");
         }
         if(_instance == null)
         {
            _instance = new WidgetHint(ConstructorLock_659);
         }
         if(_instance.parent != parent)
         {
            _instance.horizontalAlign = null;
         }
         _instance.parent = parent;
         _instance.addToStage = addToStage;
         if(addToStage)
         {
            var onStageMouseOut:Function = function(param1:MouseEvent):void
            {
               if(param1.relatedObject == null)
               {
                  _instance.hide();
               }
            };
            parent.stage.addEventListener(MouseEvent.MOUSE_OUT,onStageMouseOut);
         }
         return _instance;
      }
      
      public function get widget() : Widget
      {
         return this._widget;
      }
      
      public function set widget(param1:Widget) : void
      {
         var _loc2_:DisplayObjectContainer = !!this.addToStage?this.parent.stage:this.parent;
         if(param1 != null)
         {
            if(param1 != this._widget)
            {
               if(_loc2_ && !_loc2_.contains(this.view))
               {
                  if(this.widget != null && this.view.contains(this.widget))
                  {
                     this.view.removeChild(this.widget);
                  }
                  this._widget = param1;
                  this.view.addChild(this._widget);
                  this.view.height = this._widget.height;
                  _loc2_.addChild(this.view);
               }
               this.view.measure();
            }
            this.updatePosition();
         }
         else
         {
            this.hide();
         }
      }
      
      public function hide() : void
      {
         var _loc1_:DisplayObjectContainer = !!this.addToStage?this.parent.stage:this.parent;
         if(_loc1_ && _loc1_.contains(this.view))
         {
            if(this.widget != null && this.view.contains(this.widget))
            {
               this.view.removeChild(this.widget);
            }
            this.view.parent.removeChild(this.view);
            this._widget = null;
         }
      }
      
      public function updatePosition() : void
      {
         var _loc1_:int = !!isNaN(this.parent.width)?this.parent is Widget?int((this.parent as Widget).layoutMetadata.width):int(NaN):int(this.parent.width);
         var _loc2_:Point = this.parent.localToGlobal(new Point(this.parent.x,this.parent.y));
         var _loc3_:Point = this.parent.localToGlobal(new Point(this.parent.mouseX,this.parent.mouseY));
         this.view.y = (!!this.addToStage?_loc2_.y - this.parent.height:0) - this.view.height;
         switch(this.horizontalAlign)
         {
            case HorizontalAlign.LEFT:
               this.view.x = !!this.addToStage?Number(_loc2_.x):Number(0);
               break;
            case HorizontalAlign.RIGHT:
               this.view.x = (!!this.addToStage?_loc2_.x:0) + _loc1_ - this.view.width;
               break;
            case HorizontalAlign.CENTER:
               this.view.x = (!!this.addToStage?_loc2_.x:0) + (_loc1_ - this.view.width) / 2;
               break;
            default:
               this.view.x = (!!this.addToStage?_loc3_.x:this.parent.mouseX) - this.view.width / 2;
         }
      }
   }
}

class ConstructorLock_659
{
    
   
   function ConstructorLock_659()
   {
      super();
   }
}
