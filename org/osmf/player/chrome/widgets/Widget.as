package org.osmf.player.chrome.widgets
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import org.osmf.events.MediaElementEvent;
   import org.osmf.layout.LayoutRenderer;
   import org.osmf.layout.LayoutRendererBase;
   import org.osmf.layout.LayoutTargetEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.hint.Hint;
   
   public class Widget extends FadingLayoutTargetSprite
   {
       
      
      public var face:String = "";
      
      private var _media:MediaElement;
      
      private var _configuration:XML;
      
      private var _assetManager:AssetsManager;
      
      private var _id:String = "";
      
      private var _enabled:Boolean = true;
      
      private var _hint:String = null;
      
      private var _tintColor:uint = 0;
      
      private var _displayObject:DisplayObject;
      
      private var layoutRenderer:LayoutRendererBase;
      
      private var children:Vector.<Widget>;
      
      private var _requiredTraitsAvailable:Boolean;
      
      public function Widget()
      {
         super();
         super.addChildAt(new Sprite(),0);
         this.children = new Vector.<Widget>();
      }
      
      public function configure(param1:XML, param2:AssetsManager) : void
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         this._configuration = param1;
         this._assetManager = param2;
         for each(_loc3_ in param1.@*)
         {
            _loc4_ = _loc3_.name();
            if(hasOwnProperty(_loc4_))
            {
               this[_loc4_] = this.setValueFromString(this[_loc4_],_loc3_.toString());
            }
            else if(layoutMetadata.hasOwnProperty(_loc4_))
            {
               layoutMetadata[_loc4_] = this.setValueFromString(layoutMetadata[_loc4_],_loc3_.toString());
            }
         }
         this.faceDisplayObject = param2.getDisplayObject(this.face) || new Sprite();
      }
      
      public function get configuration() : XML
      {
         return this._configuration;
      }
      
      public function get assetManager() : AssetsManager
      {
         return this._assetManager;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set id(param1:String) : void
      {
         this._id = param1;
      }
      
      public function set media(param1:MediaElement) : void
      {
         var _loc2_:MediaElement = null;
         var _loc3_:Widget = null;
         if(this._media != param1)
         {
            _loc2_ = this._media;
            this._media = null;
            if(_loc2_)
            {
               _loc2_.removeEventListener(MediaElementEvent.TRAIT_ADD,this.onMediaElementTraitsChange);
               _loc2_.removeEventListener(MediaElementEvent.TRAIT_REMOVE,this.onMediaElementTraitsChange);
               this.onMediaElementTraitsChange(null);
            }
            this._media = param1;
            if(this._media)
            {
               this._media.addEventListener(MediaElementEvent.TRAIT_ADD,this.onMediaElementTraitsChange);
               this._media.addEventListener(MediaElementEvent.TRAIT_REMOVE,this.onMediaElementTraitsChange);
            }
            for each(_loc3_ in this.children)
            {
               _loc3_.media = this._media;
            }
            this.processMediaElementChange(_loc2_);
            this.onMediaElementTraitsChange(null);
         }
      }
      
      public function get media() : MediaElement
      {
         return this._media;
      }
      
      public function set faceDisplayObject(param1:DisplayObject) : void
      {
         if(param1 != this._displayObject)
         {
            if(this._displayObject)
            {
               removeChild(this._displayObject);
            }
            this._displayObject = param1;
            if(this._displayObject)
            {
               addChildAt(this._displayObject,0);
            }
            measure();
         }
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._enabled != param1)
         {
            this._enabled = param1;
            this.processEnabledChange();
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function addChildWidget(param1:Widget) : void
      {
         if(this.layoutRenderer == null)
         {
            this.layoutRenderer = this.constructLayoutRenderer();
            if(this.layoutRenderer)
            {
               this.layoutRenderer.container = this;
            }
         }
         if(this.layoutRenderer != null)
         {
            this.layoutRenderer.addTarget(param1);
            this.children.push(param1);
            param1.media = this._media;
         }
      }
      
      public function removeChildWidget(param1:Widget) : void
      {
         if(this.layoutRenderer && this.layoutRenderer.hasTarget(param1))
         {
            this.layoutRenderer.removeTarget(param1);
            this.children.splice(this.children.indexOf(param1),1);
         }
      }
      
      public function getChildWidget(param1:String) : Widget
      {
         var _loc2_:Widget = null;
         var _loc3_:Widget = null;
         for each(_loc3_ in this.children)
         {
            if(_loc3_.id && _loc3_.id.toLowerCase() == param1.toLocaleLowerCase())
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function set hint(param1:String) : void
      {
         if(param1 != this._hint)
         {
            if(this._hint == null)
            {
               addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
               addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            }
            if(stage && this._hint && this._hint != "" && Hint.getInstance(stage,this._assetManager).text == this._hint)
            {
               Hint.getInstance(stage,this._assetManager).text = param1;
            }
            this._hint = param1;
            if(this._hint == null)
            {
               removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
               removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            }
         }
      }
      
      public function get hint() : String
      {
         return this._hint;
      }
      
      public function set tintColor(param1:uint) : void
      {
         this._tintColor = param1;
         var _loc2_:uint = 1;
         var _loc3_:ColorTransform = new ColorTransform();
         _loc3_.redMultiplier = _loc3_.greenMultiplier = _loc3_.blueMultiplier = _loc2_;
         _loc3_.redOffset = Math.round(((this._tintColor & 16711680) >> 16) * _loc2_);
         _loc3_.greenOffset = Math.round(((this._tintColor & 65280) >> 8) * _loc2_);
         _loc3_.blueOffset = Math.round((this._tintColor & 255) * _loc2_);
         transform.colorTransform = _loc3_;
      }
      
      public function get tintColor() : uint
      {
         return this._tintColor;
      }
      
      override public function layout(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         if(this._displayObject)
         {
            this._displayObject.width = param1 / scaleX;
            this._displayObject.height = param2 / scaleY;
         }
         super.layout(param1,param2,param3);
      }
      
      override public function set width(param1:Number) : void
      {
         if(this._displayObject)
         {
            this._displayObject.width = param1 / scaleX;
         }
         super.width = param1;
      }
      
      override public function set height(param1:Number) : void
      {
         if(this._displayObject)
         {
            this._displayObject.height = param1 / scaleY;
         }
         super.height = param1;
      }
      
      override protected function onAddChildAt(param1:LayoutTargetEvent) : void
      {
         param1 = new LayoutTargetEvent(param1.type,param1.bubbles,param1.cancelable,param1.layoutRenderer,param1.layoutTarget,param1.displayObject,param1.index == -1?-1:int(param1.index + 1));
         super.onAddChildAt(param1);
      }
      
      override protected function onRemoveChild(param1:LayoutTargetEvent) : void
      {
         param1 = new LayoutTargetEvent(param1.type,param1.bubbles,param1.cancelable,param1.layoutRenderer,param1.layoutTarget,param1.displayObject,param1.index == -1?-1:int(param1.index + 1));
         super.onRemoveChild(param1);
      }
      
      override protected function onSetChildIndex(param1:LayoutTargetEvent) : void
      {
         param1 = new LayoutTargetEvent(param1.type,param1.bubbles,param1.cancelable,param1.layoutRenderer,param1.layoutTarget,param1.displayObject,param1.index == -1?-1:int(param1.index + 1));
         super.onSetChildIndex(param1);
      }
      
      override protected function setSuperVisible(param1:Boolean) : void
      {
         super.setSuperVisible(param1);
         layoutMetadata.includeInLayout = param1 && (!!this.configuration?this.configuration.@includeInLayout != "false":true);
      }
      
      protected function constructLayoutRenderer() : LayoutRendererBase
      {
         return new LayoutRenderer();
      }
      
      protected function processEnabledChange() : void
      {
      }
      
      protected function processMediaElementChange(param1:MediaElement) : void
      {
      }
      
      protected function onMediaElementTraitAdd(param1:MediaElementEvent) : void
      {
      }
      
      protected function onMediaElementTraitRemove(param1:MediaElementEvent) : void
      {
      }
      
      protected function processRequiredTraitsAvailable(param1:MediaElement) : void
      {
      }
      
      protected function processRequiredTraitsUnavailable(param1:MediaElement) : void
      {
      }
      
      protected function get requiredTraits() : Vector.<String>
      {
         return null;
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         Hint.getInstance(stage,this.assetManager).text = this._hint;
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         Hint.getInstance(stage,this.assetManager).text = null;
      }
      
      private function onMediaElementTraitsChange(param1:MediaElementEvent = null) : void
      {
         var _loc4_:String = null;
         var _loc2_:MediaElement = !!param1?param1.target as MediaElement:this._media;
         var _loc3_:Boolean = this._requiredTraitsAvailable;
         if(_loc2_)
         {
            this._requiredTraitsAvailable = true;
            for each(_loc4_ in this.requiredTraits)
            {
               if(_loc2_.hasTrait(_loc4_) == false || param1 != null && param1.type == MediaElementEvent.TRAIT_REMOVE && param1.traitType == _loc4_)
               {
                  this._requiredTraitsAvailable = false;
                  break;
               }
            }
         }
         else
         {
            this._requiredTraitsAvailable = false;
         }
         if(param1 == null || this._requiredTraitsAvailable != _loc3_)
         {
            if(this._requiredTraitsAvailable)
            {
               this.processRequiredTraitsAvailable(_loc2_);
            }
            else
            {
               this.processRequiredTraitsUnavailable(_loc2_);
            }
         }
         if(param1)
         {
            if(param1.type == MediaElementEvent.TRAIT_ADD)
            {
               this.onMediaElementTraitAdd(param1);
            }
            else
            {
               this.onMediaElementTraitRemove(param1);
            }
         }
      }
      
      protected function parseAttribute(param1:XML, param2:String, param3:*) : *
      {
         var _loc4_:* = undefined;
         if(param1[param2] == undefined)
         {
            _loc4_ = param3;
         }
         else
         {
            _loc4_ = param1[param2];
         }
         return _loc4_;
      }
      
      private function setValueFromString(param1:*, param2:String) : *
      {
         var _loc3_:* = null;
         if(param1 is Boolean)
         {
            _loc3_ = param2.toLowerCase() == "true";
         }
         else if(param1 is int || param1 is uint)
         {
            _loc3_ = parseInt(param2);
         }
         else if(param1 is Number)
         {
            _loc3_ = parseFloat(param2);
         }
         else
         {
            _loc3_ = param2 as Object;
         }
         return _loc3_;
      }
   }
}
