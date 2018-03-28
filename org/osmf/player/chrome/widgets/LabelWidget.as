package org.osmf.player.chrome.widgets
{
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.assets.FontAsset;
   
   public class LabelWidget extends Widget
   {
       
      
      public var font:String = "defaultFont";
      
      public var autoSize:Boolean;
      
      public var align:String;
      
      public var fontSize:Number;
      
      public var input:Boolean;
      
      public var selectable:Boolean;
      
      public var password:Boolean;
      
      public var multiline:Boolean;
      
      public var textColor:String;
      
      public var defaultText:String = "";
      
      protected var textField:TextField;
      
      private var dirty:Boolean;
      
      public function LabelWidget()
      {
         this.textField = new TextField();
         this.textField.addEventListener(Event.CHANGE,this.onChange);
         this.textField.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
         this.textField.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         addChild(this.textField);
         super();
      }
      
      public function focus() : void
      {
         stage.focus = this.textField;
      }
      
      public function get text() : String
      {
         return this.textField.text;
      }
      
      public function set text(param1:String) : void
      {
         var _loc2_:String = this.textField.text;
         this.textField.text = param1;
         if(this.autoSize && param1.length != _loc2_.length)
         {
            measure();
         }
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         super.configure(param1,param2);
         var _loc3_:FontAsset = param2.getAsset(this.font) as FontAsset;
         var _loc4_:TextFormat = !!_loc3_?_loc3_.format:new TextFormat();
         if(this.textColor)
         {
            _loc4_.color = parseInt(this.textColor);
         }
         if(this.fontSize)
         {
            _loc4_.size = this.fontSize;
         }
         if(this.align)
         {
            _loc4_.align = this.align;
         }
         this.textField.defaultTextFormat = _loc4_;
         this.textField.type = !!this.input?TextFieldType.INPUT:TextFieldType.DYNAMIC;
         this.textField.selectable = this.textField.type == TextFieldType.INPUT || this.selectable;
         this.textField.background = String(parseAttribute(param1,"background","false")).toLocaleLowerCase() == "true";
         this.textField.displayAsPassword = this.password;
         this.textField.backgroundColor = Number(param1.@backgroundColor || NaN);
         this.textField.alpha = Number(Number(param1.@textAlpha)) || Number(1);
         this.textField.multiline = this.multiline;
         this.textField.wordWrap = this.textField.multiline;
         this.textField.autoSize = !!this.autoSize?TextFieldAutoSize.LEFT:TextFieldAutoSize.NONE;
         this.textField.antiAliasType = AntiAliasType.ADVANCED;
         this.textField.sharpness = 200;
         this.textField.thickness = 0;
         if(this.textField.text == "")
         {
            this.textField.text = this.defaultText;
            this.textField.displayAsPassword = false;
         }
      }
      
      override public function layout(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         this.textField.width = !!this.autoSize?Number(Math.min(param1,this.textField.textWidth)):Number(param1);
         this.textField.height = param2;
      }
      
      private function onChange(param1:Event) : void
      {
         this.dirty = true;
      }
      
      private function onFocusIn(param1:FocusEvent) : void
      {
         if(this.textField.text == this.defaultText && !this.dirty)
         {
            this.textField.text = "";
            this.textField.displayAsPassword = this.password;
         }
      }
      
      private function onFocusOut(param1:FocusEvent) : void
      {
         if(this.textField.text == "" && this.defaultText.length > 0)
         {
            this.textField.text = this.defaultText;
            this.textField.displayAsPassword = false;
            this.dirty = false;
         }
      }
   }
}
