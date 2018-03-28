package org.osmf.player.chrome
{
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   import org.osmf.layout.HorizontalAlign;
   import org.osmf.layout.LayoutMode;
   import org.osmf.layout.VerticalAlign;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.widgets.AlertDialog;
   import org.osmf.player.chrome.widgets.AuthenticationDialog;
   import org.osmf.player.chrome.widgets.ButtonWidget;
   import org.osmf.player.chrome.widgets.LabelWidget;
   import org.osmf.player.chrome.widgets.Widget;
   import org.osmf.player.chrome.widgets.WidgetIDs;
   import org.osmf.player.elements.ErrorWidget;
   
   public class ChromeProvider extends EventDispatcher
   {
      
      private static var assetsProvider:AssetsProvider;
      
      private static var instance:ChromeProvider;
       
      
      private var _widgets:Dictionary;
      
      private var _loaded:Boolean;
      
      private var _loading:Boolean;
      
      public function ChromeProvider(param1:Class = null)
      {
         super();
         if(param1 != ConstructorLock_154)
         {
            throw new IllegalOperationError("ChromeProvider is a singleton: use getInstance to obtain a reference.");
         }
         this._widgets = new Dictionary();
      }
      
      public static function getInstance() : ChromeProvider
      {
         instance = instance || new ChromeProvider(ConstructorLock_154);
         return instance;
      }
      
      public function load(param1:AssetsManager) : void
      {
         if(this._loaded == false && this._loading == false)
         {
			 ExternalInterface.call("msg","load(param1:AssetsManager)");
            this._loading = true;
            assetsProvider = new AssetsProvider(param1);
            assetsProvider.addEventListener(Event.COMPLETE,this.onAssetsProviderComplete);
            assetsProvider.load();
            return;
         }
         throw new IllegalOperationError("ChromeProvider is either loading, or already loaded.");
      }
      
      public function get loading() : Boolean
      {
         return this._loading;
      }
      
      public function get loaded() : Boolean
      {
         return this._loaded;
      }
      
      public function get assetManager() : AssetsManager
      {
         return assetsProvider.assetsManager;
      }
      
      public function createAuthenticationDialog() : AuthenticationDialog
      {
         var _loc1_:AuthenticationDialog = null;
         _loc1_ = new AuthenticationDialog();
         _loc1_.id = WidgetIDs.LOGIN;
         _loc1_.fadeSteps = 6;
         _loc1_.face = AssetIDs.AUTH_BACKDROP;
         _loc1_.playAfterAuthentication = true;
         _loc1_.width = 279;
         _loc1_.height = 228;
         _loc1_.layoutMetadata.layoutMode = LayoutMode.NONE;
         _loc1_.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
         _loc1_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         var _loc2_:Widget = new Widget();
         _loc2_.id = WidgetIDs.ERROR_ICON;
         _loc2_.face = AssetIDs.AUTH_WARNING;
         _loc2_.layoutMetadata.left = 47;
         _loc2_.layoutMetadata.top = 150;
         _loc2_.layoutMetadata.width = 11;
         _loc2_.layoutMetadata.height = 9;
         _loc1_.addChildWidget(_loc2_);
         var _loc3_:LabelWidget = new LabelWidget();
         _loc3_.id = WidgetIDs.ERROR_LABEL;
         _loc3_.fontSize = 12;
         _loc3_.multiline = true;
         _loc3_.layoutMetadata.left = 49;
         _loc3_.layoutMetadata.top = 138;
         _loc3_.layoutMetadata.width = 190;
         _loc3_.layoutMetadata.height = 80;
         _loc1_.addChildWidget(_loc3_);
         var _loc4_:LabelWidget = new LabelWidget();
         _loc4_.fontSize = 18;
         _loc4_.layoutMetadata.left = 34;
         _loc4_.layoutMetadata.top = 25;
         _loc1_.addChildWidget(_loc4_);
         var _loc5_:LabelWidget = new LabelWidget();
         _loc5_.id = WidgetIDs.USERNAME;
         _loc5_.input = true;
         _loc5_.fontSize = 14;
         _loc5_.textColor = "0x999999";
         _loc5_.layoutMetadata.left = 36;
         _loc5_.layoutMetadata.top = 63;
         _loc5_.layoutMetadata.width = 208;
         _loc5_.layoutMetadata.height = 20;
         _loc5_.defaultText = "User Name";
         _loc1_.addChildWidget(_loc5_);
         var _loc6_:LabelWidget = new LabelWidget();
         _loc6_.id = WidgetIDs.PASSWORD;
         _loc6_.fontSize = 14;
         _loc6_.textColor = "0x999999";
         _loc6_.layoutMetadata.left = 36;
         _loc6_.layoutMetadata.top = 110;
         _loc6_.layoutMetadata.width = 208;
         _loc6_.layoutMetadata.height = 20;
         _loc6_.input = true;
         _loc6_.password = true;
         _loc6_.defaultText = "Password";
         _loc1_.addChildWidget(_loc6_);
         var _loc7_:ButtonWidget = new ButtonWidget();
         _loc7_.id = WidgetIDs.SUBMIT_BUTTON;
         _loc7_.upFace = AssetIDs.AUTH_SUBMIT_BUTTON_NORMAL;
         _loc7_.downFace = AssetIDs.AUTH_SUBMIT_BUTTON_DOWN;
         _loc7_.overFace = AssetIDs.AUTH_SUBMIT_BUTTON_OVER;
         _loc7_.layoutMetadata.left = 140;
         _loc7_.layoutMetadata.top = 160;
         var _loc8_:LabelWidget = new LabelWidget();
         _loc8_.autoSize = true;
         _loc8_.fontSize = 14;
         _loc8_.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
         _loc8_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         _loc7_.addChildWidget(_loc8_);
         _loc1_.addChildWidget(_loc7_);
         var _loc9_:ButtonWidget = new ButtonWidget();
         _loc9_.id = WidgetIDs.CANCEL_BUTTON;
         _loc9_.upFace = AssetIDs.AUTH_CANCEL_BUTTON_NORMAL;
         _loc9_.downFace = AssetIDs.AUTH_CANCEL_BUTTON_DOWN;
         _loc9_.overFace = AssetIDs.AUTH_CANCEL_BUTTON_OVER;
         _loc9_.layoutMetadata.left = 235;
         _loc9_.layoutMetadata.top = 25;
         _loc1_.addChildWidget(_loc9_);
         this.configureWidgets([_loc4_,_loc5_,_loc6_,_loc8_,_loc7_,_loc9_,_loc3_,_loc2_,_loc1_]);
         _loc4_.text = "Sign in";
         _loc8_.text = "Sign in";
         return _loc1_;
      }
      
      public function createAlertDialog() : AlertDialog
      {
         var _loc1_:AlertDialog = new AlertDialog();
         _loc1_.id = WidgetIDs.ALERT;
         _loc1_.layoutMetadata.percentWidth = 100;
         _loc1_.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
         _loc1_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         var _loc2_:ButtonWidget = new ButtonWidget();
         _loc2_.id = WidgetIDs.CLOSE_BUTTON;
         _loc1_.addChildWidget(_loc2_);
         var _loc3_:LabelWidget = new LabelWidget();
         _loc3_.id = WidgetIDs.CAPTION_LABEL;
         _loc3_.height = 0;
         _loc1_.addChildWidget(_loc3_);
         var _loc4_:LabelWidget = new LabelWidget();
         _loc4_.id = WidgetIDs.MESSAGE_LABEL;
         _loc4_.multiline = true;
         _loc4_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         _loc4_.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
         _loc4_.layoutMetadata.percentWidth = 100;
         _loc4_.fontSize = 16;
         _loc4_.align = TextFormatAlign.CENTER;
         _loc1_.addChildWidget(_loc4_);
         this.configureWidgets([_loc2_,_loc3_,_loc4_,_loc1_]);
         return _loc1_;
      }
      
      public function createErrorWidget() : ErrorWidget
      {
         var _loc1_:ErrorWidget = new ErrorWidget();
         _loc1_.id = WidgetIDs.ERROR;
         _loc1_.layoutMetadata.percentWidth = 100;
         _loc1_.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
         _loc1_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         var _loc2_:LabelWidget = new LabelWidget();
         _loc2_.id = WidgetIDs.ERROR_LABEL;
         _loc2_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         _loc2_.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
         _loc2_.layoutMetadata.percentWidth = 100;
         _loc2_.multiline = true;
         _loc2_.fontSize = 16;
         _loc2_.align = TextFormatAlign.CENTER;
         _loc1_.addChildWidget(_loc2_);
         this.configureWidgets([_loc2_,_loc1_]);
         return _loc1_;
      }
      
      public function createControlBar() : ControlBar
      {
         var _loc1_:ControlBar = new ControlBar();
         _loc1_.configure(<default/>,assetsProvider.assetsManager);
         return _loc1_;
      }
      
      public function getWidget(param1:String) : Widget
      {
         return this._widgets[param1];
      }
      
      private function configureWidgets(param1:Array) : void
      {
         var _loc2_:Widget = null;
         var _loc3_:String = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_)
            {
               _loc3_ = !!_loc2_.id?_loc2_.id:getQualifiedClassName(_loc2_) + new Date().time;
               this._widgets[_loc3_] = _loc2_;
               _loc2_.configure(<default/>,assetsProvider.assetsManager);
            }
         }
      }
      
      private function onAssetsProviderComplete(param1:Event) : void
      {
		  ExternalInterface.call("msg","onAssetsProviderComplete(param1:Event)");
         this._loaded = true;
         this._loading = false;
         dispatchEvent(param1.clone());
      }
   }
}

class ConstructorLock_154
{
    
   
   function ConstructorLock_154()
   {
      super();
   }
}
