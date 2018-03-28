package org.osmf.player.chrome
{
   import flash.display.DisplayObject;
   import org.osmf.layout.HorizontalAlign;
   import org.osmf.layout.LayoutMode;
   import org.osmf.layout.VerticalAlign;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.widgets.AdditionalButton;
   import org.osmf.player.chrome.widgets.AutoHideWidget;
   import org.osmf.player.chrome.widgets.Companyinfo;
   import org.osmf.player.chrome.widgets.CouldInfo;
   import org.osmf.player.chrome.widgets.FullScreenEnterButton;
   import org.osmf.player.chrome.widgets.FullScreenLeaveButton;
   import org.osmf.player.chrome.widgets.MuteButton;
   import org.osmf.player.chrome.widgets.PauseButton;
   import org.osmf.player.chrome.widgets.PlayButton;
   import org.osmf.player.chrome.widgets.PlaylistNextButton;
   import org.osmf.player.chrome.widgets.PlaylistPreviousButton;
   import org.osmf.player.chrome.widgets.ScrubBar;
   import org.osmf.player.chrome.widgets.TimeViewWidget;
   import org.osmf.player.chrome.widgets.Widget;
   import org.osmf.player.chrome.widgets.WidgetIDs;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.PlayTrait;
   
   public class ControlBar extends AutoHideWidget
   {
      
      private static const _requiredTraits:Vector.<String> = new Vector.<String>();
      
      {
         _requiredTraits[0] = MediaTraitType.PLAY;
      }
      
      private var fullscreenEnterButton:FullScreenEnterButton;
      
      private var playTrait:PlayTrait;
      
      private var scrubBarLiveTrack:DisplayObject;
      
      private var lastWidth:Number;
      
      private var lastHeight:Number;
      
      public function ControlBar()
      {
         this.fullscreenEnterButton = new FullScreenEnterButton();
         super();
      }
      
      override public function configure(param1:XML, param2:AssetsManager) : void
      {
         var _loc3_:Widget = null;
         var _loc5_:Widget = null;
         id = WidgetIDs.CONTROL_BAR;
         face = AssetIDs.CONTROL_BAR_BACKDROP;
         fadeSteps = 6;
         layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
         layoutMetadata.verticalAlign = VerticalAlign.TOP;
         layoutMetadata.layoutMode = LayoutMode.HORIZONTAL;
         super.configure(param1,param2);
         _loc3_ = new Widget();
         _loc3_.face = AssetIDs.CONTROL_BAR_BACKDROP_LEFT;
         _loc3_.layoutMetadata.horizontalAlign = HorizontalAlign.LEFT;
         addChildWidget(_loc3_);
         var _loc4_:Widget = new Widget();
         _loc4_.width = 6;
         addChildWidget(_loc4_);
         _loc5_ = new Widget();
         _loc5_.layoutMetadata.percentHeight = 100;
         _loc5_.layoutMetadata.layoutMode = LayoutMode.HORIZONTAL;
         _loc5_.layoutMetadata.horizontalAlign = HorizontalAlign.LEFT;
         var _loc6_:PlayButton = new PlayButton();
         _loc6_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         _loc6_.layoutMetadata.horizontalAlign = HorizontalAlign.LEFT;
         _loc5_.addChildWidget(_loc6_);
         var _loc7_:PauseButton = new PauseButton();
         _loc7_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         _loc7_.layoutMetadata.horizontalAlign = HorizontalAlign.LEFT;
         _loc5_.addChildWidget(_loc7_);
         var _loc8_:PlaylistPreviousButton = new PlaylistPreviousButton();
         _loc8_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         _loc8_.layoutMetadata.horizontalAlign = HorizontalAlign.LEFT;
         _loc5_.addChildWidget(_loc8_);
         var _loc9_:PlaylistNextButton = new PlaylistNextButton();
         _loc9_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         _loc9_.layoutMetadata.horizontalAlign = HorizontalAlign.LEFT;
         _loc5_.addChildWidget(_loc9_);
         addChildWidget(_loc5_);
         var _loc10_:Widget = new Widget();
         _loc10_.width = 4;
         addChildWidget(_loc10_);
         var _loc11_:Widget = new Widget();
         _loc11_.layoutMetadata.percentWidth = 100;
         _loc11_.layoutMetadata.percentHeight = 80;
         _loc11_.layoutMetadata.layoutMode = LayoutMode.VERTICAL;
         _loc11_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         var _loc12_:Widget = new Widget();
         _loc12_.layoutMetadata.percentWidth = 100;
         _loc12_.layoutMetadata.percentHeight = 100;
         _loc12_.layoutMetadata.layoutMode = LayoutMode.HORIZONTAL;
         _loc12_.layoutMetadata.horizontalAlign = HorizontalAlign.LEFT;
         var _loc13_:Widget = new Widget();
         _loc13_.layoutMetadata.percentWidth = 100;
         _loc13_.layoutMetadata.percentHeight = 100;
         _loc13_.layoutMetadata.layoutMode = LayoutMode.HORIZONTAL;
         _loc13_.layoutMetadata.horizontalAlign = HorizontalAlign.LEFT;
         var _loc14_:Companyinfo = new Companyinfo();
         _loc14_.layoutMetadata.y = 3;
         var _loc15_:Widget = new Widget();
         _loc15_.width = 5;
         var _loc16_:CouldInfo = new CouldInfo();
         _loc16_.layoutMetadata.y = 4;
         var _loc17_:AdditionalButton = new AdditionalButton();
         _loc17_.layoutMetadata.y = 4;
         _loc12_.addChildWidget(_loc16_);
         _loc12_.addChildWidget(_loc15_);
         _loc12_.addChildWidget(_loc17_);
         _loc12_.addChildWidget(_loc14_);
         _loc11_.addChildWidget(_loc12_);
         var _loc18_:ScrubBar = new ScrubBar();
         _loc18_.id = WidgetIDs.SCRUB_BAR;
         _loc18_.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
         _loc18_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         _loc18_.layoutMetadata.percentWidth = 100;
         _loc13_.addChildWidget(_loc18_);
         var _loc19_:TimeViewWidget = new TimeViewWidget();
         _loc19_.layoutMetadata.verticalAlign = VerticalAlign.BOTTOM;
         _loc19_.layoutMetadata.horizontalAlign = HorizontalAlign.CENTER;
         _loc13_.addChildWidget(_loc19_);
         var _loc20_:Widget = new Widget();
         _loc20_.layoutMetadata.percentWidth = 100;
         _loc12_.addChildWidget(_loc20_);
         var _loc21_:Widget = new Widget();
         _loc21_.width = 4;
         _loc12_.addChildWidget(_loc21_);
         var _loc22_:MuteButton = new MuteButton();
         _loc22_.id = WidgetIDs.MUTE_BUTTON;
         _loc22_.volumeSteps = 3;
         _loc22_.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         _loc22_.layoutMetadata.horizontalAlign = HorizontalAlign.RIGHT;
         _loc12_.addChildWidget(_loc22_);
         var _loc23_:Widget = new Widget();
         _loc23_.width = 1;
         _loc12_.addChildWidget(_loc23_);
         var _loc24_:FullScreenLeaveButton = new FullScreenLeaveButton();
         _loc24_.layoutMetadata.y = 4;
         _loc24_.layoutMetadata.horizontalAlign = HorizontalAlign.RIGHT;
         _loc12_.addChildWidget(_loc24_);
         this.fullscreenEnterButton.id = WidgetIDs.FULL_SCREEN_ENTER_BUTTON;
         this.fullscreenEnterButton.layoutMetadata.verticalAlign = VerticalAlign.MIDDLE;
         this.fullscreenEnterButton.layoutMetadata.horizontalAlign = HorizontalAlign.RIGHT;
         _loc12_.addChildWidget(this.fullscreenEnterButton);
         _loc11_.addChildWidget(_loc13_);
         addChildWidget(_loc11_);
         var _loc25_:Widget = new Widget();
         _loc25_.layoutMetadata.width = 5;
         addChildWidget(_loc25_);
         var _loc26_:Widget = new Widget();
         var _loc27_:Widget = new Widget();
         _loc27_.face = AssetIDs.CONTROL_BAR_BACKDROP_RIGHT;
         _loc27_.layoutMetadata.horizontalAlign = HorizontalAlign.RIGHT;
         addChildWidget(_loc27_);
         this.configureWidgets([_loc3_,_loc4_,_loc7_,_loc6_,_loc8_,_loc9_,_loc10_,_loc5_,_loc16_,_loc15_,_loc17_,_loc14_,_loc20_,_loc22_,_loc23_,this.fullscreenEnterButton,_loc24_,undefined,_loc12_,_loc18_,_loc19_,_loc13_,_loc11_,_loc25_,_loc27_]);
         measure();
      }
      
      private function configureWidgets(param1:Array) : void
      {
         var _loc2_:Widget = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_)
            {
               _loc2_.configure(<default/>,assetManager);
            }
         }
      }
   }
}
