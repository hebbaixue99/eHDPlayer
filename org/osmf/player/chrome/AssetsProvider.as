package org.osmf.player.chrome
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.player.chrome.assets.AssetLoader;
   import org.osmf.player.chrome.assets.AssetsManager;
   import org.osmf.player.chrome.assets.BitmapResource;
   import org.osmf.player.chrome.assets.FontResource;
   import org.osmf.player.chrome.assets.SymbolResource;
   
   public class AssetsProvider extends EventDispatcher
   {
       
      
      private var _assetsManager:AssetsManager;
      
      public function AssetsProvider(param1:AssetsManager = null)
      {
         super();
         this._assetsManager = param1 || new AssetsManager();
         this.addDefaultAssets();
      }
      
      public function load() : void
      {
         this._assetsManager.addEventListener(Event.COMPLETE,this.onAssetsManagerComplete);
         this._assetsManager.load();
      }
      
      public function get assetsManager() : AssetsManager
      {
         return this._assetsManager;
      }
      
      private function addEmbeddedBitmap(param1:String, param2:Class) : void
      {
         var _loc3_:BitmapResource = new BitmapResource(param1,getQualifiedClassName(param2),true,null);
         this._assetsManager.addAsset(_loc3_,new AssetLoader());
      }
      
      private function addEmbeddedSymbol(param1:String, param2:Class) : void
      {
         var _loc3_:SymbolResource = new SymbolResource(param1,getQualifiedClassName(param2),true,null);
         this._assetsManager.addAsset(_loc3_,new AssetLoader());
      }
      
      private function addDefaultAssets() : void
      {
         this._assetsManager.addAsset(new FontResource(AssetIDs.DEFAULT_FONT,getQualifiedClassName(ASSET_DefaultFont),true,AssetIDs.DEFAULT_FONT,12,14540253),new AssetLoader());
         this.addEmbeddedSymbol(AssetIDs.CONTROL_BAR_BACKDROP,ASSET_backDrop_center);
         this.addEmbeddedSymbol(AssetIDs.CONTROL_BAR_BACKDROP_LEFT,ASSET_backDrop_left);
         this.addEmbeddedSymbol(AssetIDs.CONTROL_BAR_BACKDROP_RIGHT,ASSET_backDrop_right);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_TRACK,ASSET_scrub_no_load);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_TRACK_LEFT,ASSET_scrub_left);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_TRACK_RIGHT,ASSET_scrub_right);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_LOADED_TRACK,ASSET_scrub_loaded);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_LOADED_TRACK_END,ASSET_scrub_loaded_end);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_PLAYED_TRACK,ASSET_scrub_loaded_played);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_DVR_LIVE_TRACK,ASSET_ScrubDvrLive);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_DVR_LIVE_INACTIVE_TRACK,ASSET_ScrubDvrLiveInactive);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_LIVE_ONLY_TRACK,ASSET_ScrubLive);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_LIVE_ONLY_INACTIVE_TRACK,ASSET_ScrubLiveInactive);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_SCRUBBER_NORMAL,ASSET_scrub_tab);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_SCRUBBER_DOWN,ASSET_scrub_tab);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_SCRUBBER_OVER,ASSET_scrub_tab);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_SCRUBBER_OVER,ASSET_scrub_tab);
         this.addEmbeddedSymbol(AssetIDs.SCRUB_BAR_TIME_HINT,ASSET_time_hint);
         this.addEmbeddedSymbol(AssetIDs.PLAY_BUTTON_NORMAL,ASSET_play_normal);
         this.addEmbeddedSymbol(AssetIDs.PLAY_BUTTON_DOWN,ASSET_play_selected);
         this.addEmbeddedSymbol(AssetIDs.PLAY_BUTTON_OVER,ASSET_play_over);
         this.addEmbeddedSymbol(AssetIDs.PLAY_BUTTON_OVERLAY_NORMAL,ASSET_play_overlayed_normal);
         this.addEmbeddedSymbol(AssetIDs.PLAY_BUTTON_OVERLAY_DOWN,ASSET_play_overlayed_normal);
         this.addEmbeddedSymbol(AssetIDs.PLAY_BUTTON_OVERLAY_OVER,ASSET_play_overlayed_over);
         this.addEmbeddedSymbol(AssetIDs.PAUSE_BUTTON_NORMAL,ASSET_pause_normal);
         this.addEmbeddedSymbol(AssetIDs.PAUSE_BUTTON_DOWN,ASSET_pause_selected);
         this.addEmbeddedSymbol(AssetIDs.PAUSE_BUTTON_OVER,ASSET_pause_over);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BUTTON_NORMAL,ASSET_volume_low_normal);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BUTTON_DOWN,ASSET_volume_low_selected);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BUTTON_OVER,ASSET_volume_low_over);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BUTTON_LOW_NORMAL,ASSET_volume_low_normal);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BUTTON_LOW_DOWN,ASSET_volume_low_selected);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BUTTON_LOW_OVER,ASSET_volume_low_over);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BUTTON_MED_NORMAL,ASSET_volume_med_normal);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BUTTON_MED_DOWN,ASSET_volume_med_selected);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BUTTON_MED_OVER,ASSET_volume_med_over);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BUTTON_HIGH_NORMAL,ASSET_volume_high_normal);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BUTTON_HIGH_DOWN,ASSET_volume_high_selected);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BUTTON_HIGH_OVER,ASSET_volume_high_over);
         this.addEmbeddedSymbol(AssetIDs.ADDITIONAL_BUTTON_NORMAL,ASSET_add_normal);
         this.addEmbeddedSymbol(AssetIDs.ADDITIONAL_BUTTON_OVER,ASSET_add_over);
         this.addEmbeddedSymbol(AssetIDs.ADDITIONAL_BUTTON_DOWN,ASSET_add_down);
         this.addEmbeddedSymbol(AssetIDs.ADDITIONAL_BACK,ASSET_add_dropback);
         this.addEmbeddedSymbol(AssetIDs.SKIN_CHANGE_BUTTON_BLUE,ASSET_skin_blue);
         this.addEmbeddedSymbol(AssetIDs.SKIN_CHANGE_BUTTON_ORANGE,ASSET_skin_orange);
         this.addEmbeddedSymbol(AssetIDs.SKIN_CHANGE_BUTTON_GRAY,ASSET_skin_gray);
         this.addEmbeddedSymbol(AssetIDs.SKIN_CHANGE_BUTTON_BLUEOVER,ASSET_skin_blueOver);
         this.addEmbeddedSymbol(AssetIDs.SKIN_CHANGE_BUTTON_ORANGEOVER,ASSET_skin_orangeOver);
         this.addEmbeddedSymbol(AssetIDs.SKIN_CHANGE_BUTTON_GRAYOVER,ASSET_skin_grayOver);
         this.addEmbeddedSymbol(AssetIDs.UNMUTE_BUTTON_NORMAL,ASSET_volume_mute_normal);
         this.addEmbeddedSymbol(AssetIDs.UNMUTE_BUTTON_DOWN,ASSET_volume_mute_selected);
         this.addEmbeddedSymbol(AssetIDs.UNMUTE_BUTTON_OVER,ASSET_volume_mute_over);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BAR_BACKDROP,ASSET_volume_back);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BAR_TRACK,ASSET_volume_scrub);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BAR_TRACK_END,ASSET_volume_scrub_bottom);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BAR_SLIDER_NORMAL,ASSET_volume_slider);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BAR_SLIDER_DOWN,ASSET_volume_slider);
         this.addEmbeddedSymbol(AssetIDs.VOLUME_BAR_SLIDER_OVER,ASSET_volume_slider);
         this.addEmbeddedSymbol(AssetIDs.FULL_SCREEN_ENTER_NORMAL,ASSET_fullscreen_on_normal);
         this.addEmbeddedSymbol(AssetIDs.FULL_SCREEN_ENTER_DOWN,ASSET_fullscreen_on_selected);
         this.addEmbeddedSymbol(AssetIDs.FULL_SCREEN_ENTER_OVER,ASSET_fullscreen_on_over);
         this.addEmbeddedSymbol(AssetIDs.FULL_SCREEN_LEAVE_NORMAL,ASSET_fullscreen_off_normal);
         this.addEmbeddedSymbol(AssetIDs.FULL_SCREEN_LEAVE_DOWN,ASSET_fullscreen_off_selected);
         this.addEmbeddedSymbol(AssetIDs.FULL_SCREEN_LEAVE_OVER,ASSET_fullscreen_off_over);
         this.addEmbeddedSymbol(AssetIDs.AUTH_BACKDROP,ASSET_auth_backdrop);
         this.addEmbeddedSymbol(AssetIDs.AUTH_SUBMIT_BUTTON_NORMAL,ASSET_button_normal);
         this.addEmbeddedSymbol(AssetIDs.AUTH_SUBMIT_BUTTON_DOWN,ASSET_button_selected);
         this.addEmbeddedSymbol(AssetIDs.AUTH_SUBMIT_BUTTON_OVER,ASSET_button_over);
         this.addEmbeddedSymbol(AssetIDs.AUTH_CANCEL_BUTTON_NORMAL,ASSET_close_normal);
         this.addEmbeddedSymbol(AssetIDs.AUTH_CANCEL_BUTTON_OVER,ASSET_close_over);
         this.addEmbeddedSymbol(AssetIDs.AUTH_CANCEL_BUTTON_DOWN,ASSET_close_selected);
         this.addEmbeddedSymbol(AssetIDs.AUTH_WARNING,ASSET_warning);
         this.addEmbeddedSymbol(AssetIDs.PREVIOUS_BUTTON_NORMAL,ASSET_previous_normal);
         this.addEmbeddedSymbol(AssetIDs.PREVIOUS_BUTTON_DOWN,ASSET_previous_selected);
         this.addEmbeddedSymbol(AssetIDs.PREVIOUS_BUTTON_OVER,ASSET_previous_rollover);
         this.addEmbeddedSymbol(AssetIDs.PREVIOUS_BUTTON_DISABLED,ASSET_previous_disabled);
         this.addEmbeddedSymbol(AssetIDs.NEXT_BUTTON_NORMAL,ASSET_next_normal);
         this.addEmbeddedSymbol(AssetIDs.NEXT_BUTTON_DOWN,ASSET_next_selected);
         this.addEmbeddedSymbol(AssetIDs.NEXT_BUTTON_OVER,ASSET_next_rollover);
         this.addEmbeddedSymbol(AssetIDs.NEXT_BUTTON_DISABLED,ASSET_next_disabled);
         this.addEmbeddedSymbol(AssetIDs.HD_ON,ASSET_hd_on);
         this.addEmbeddedSymbol(AssetIDs.HD_OFF,ASSET_hd_off);
         this.addEmbeddedSymbol(AssetIDs.BUFFERING_OVERLAY,ASSET_BufferingOverlay);
         this.addEmbeddedSymbol(AssetIDs.QL_BACKGROUND,ASSET_QL_BG);
         this.addEmbeddedSymbol(AssetIDs.QL_BK_BUTTON_BQ,ASSET_QL_BQ_BGNL);
         this.addEmbeddedSymbol(AssetIDs.QL_BK_BUTTON_BQOVER,ASSET_QL_BQ_BGOVER);
         this.addEmbeddedSymbol(AssetIDs.QL_BQ_BUTTON_NORMAL,ASSET_QL_BQ_NL);
         this.addEmbeddedSymbol(AssetIDs.QL_BQ_BUTTON_OVER,ASSET_QL_BQ_OVER);
         this.addEmbeddedSymbol(AssetIDs.QL_BQ_BUTTON_DOWN,ASSET_QL_BQ_OVER);
         this.addEmbeddedSymbol(AssetIDs.QL_BQ_BUTTON_DISABLE,ASSET_QL_BQ_DIS);
         this.addEmbeddedSymbol(AssetIDs.QL_BK_BUTTON_GQ,ASSET_QL_GQ_BGNL);
         this.addEmbeddedSymbol(AssetIDs.QL_BK_BUTTON_GQOVER,ASSET_QL_GQ_BGOVER);
         this.addEmbeddedSymbol(AssetIDs.QL_GQ_BUTTON_NORMAL,ASSET_QL_GQ_NL);
         this.addEmbeddedSymbol(AssetIDs.QL_GQ_BUTTON_OVER,ASSET_QL_GQ_OVER);
         this.addEmbeddedSymbol(AssetIDs.QL_GQ_BUTTON_DOWN,ASSET_QL_GQ_OVER);
         this.addEmbeddedSymbol(AssetIDs.QL_GQ_BUTTON_DISABLE,ASSET_QL_GQ_DIS);
         this.addEmbeddedSymbol(AssetIDs.QL_BK_BUTTON_LC,ASSET_QL_LC_BGNL);
         this.addEmbeddedSymbol(AssetIDs.QL_BK_BUTTON_LCOVER,ASSET_QL_LC_BGOVER);
         this.addEmbeddedSymbol(AssetIDs.QL_LC_BUTTON_NORMAL,ASSET_QL_LC_NL);
         this.addEmbeddedSymbol(AssetIDs.QL_LC_BUTTON_OVER,ASSET_QL_LC_OVER);
         this.addEmbeddedSymbol(AssetIDs.QL_LC_BUTTON_DOWN,ASSET_QL_LC_OVER);
         this.addEmbeddedSymbol(AssetIDs.QL_LC_BUTTON_DISABLE,ASSET_QL_LC_DIS);
      }
      
      private function onAssetsManagerComplete(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
   }
}
