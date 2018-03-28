package org.osmf.player.chrome.widgets
{
   import flash.events.MouseEvent;
   import org.osmf.events.MediaElementEvent;
   import org.osmf.events.MetadataEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.metadata.Metadata;
   import org.osmf.player.chrome.assets.AssetIDs;
   
   public class PlaylistPreviousButton extends ButtonWidget
   {
      
      private static const PLAYLIST_METADATA_NS:String = "http://www.osmf.org.player/1.0/playlist";
      
      private static const PREVIOUS_ELEMENT:String = "previousElement";
      
      private static const GOTO_PREVIOUS:String = "gotoPrevious";
      
      public static const SWITCHING:String = "switching";
       
      
      public function PlaylistPreviousButton()
      {
         super();
         upFace = AssetIDs.PREVIOUS_BUTTON_NORMAL;
         downFace = AssetIDs.PREVIOUS_BUTTON_DOWN;
         overFace = AssetIDs.PREVIOUS_BUTTON_OVER;
         disabledFace = AssetIDs.PREVIOUS_BUTTON_DISABLED;
         visible = false;
      }
      
      override protected function processMediaElementChange(param1:MediaElement) : void
      {
         if(param1 != null)
         {
            param1.removeEventListener(MediaElementEvent.METADATA_ADD,this.onPlaylistMetadataChange);
            param1.removeEventListener(MediaElementEvent.METADATA_REMOVE,this.onPlaylistMetadataChange);
         }
         if(media != null)
         {
            media.addEventListener(MediaElementEvent.METADATA_ADD,this.onPlaylistMetadataChange);
            media.addEventListener(MediaElementEvent.METADATA_REMOVE,this.onPlaylistMetadataChange);
         }
         this.onPlaylistMetadataChange();
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Metadata = !!media?media.getMetadata(PLAYLIST_METADATA_NS):null;
         if(_loc2_)
         {
            _loc2_.addValue(GOTO_PREVIOUS,true);
         }
      }
      
      private function onPlaylistMetadataChange(param1:MediaElementEvent = null) : void
      {
         var _loc2_:Metadata = null;
         _loc2_ = !!media?media.getMetadata(PLAYLIST_METADATA_NS):null;
         visible = _loc2_ != null;
         if(_loc2_)
         {
            _loc2_.addEventListener(MetadataEvent.VALUE_CHANGE,this.onPlaylistMetadataValueChange);
            enabled = _loc2_.getValue(PREVIOUS_ELEMENT) != null && !_loc2_.getValue(SWITCHING);
         }
      }
      
      private function onPlaylistMetadataValueChange(param1:MetadataEvent) : void
      {
         var _loc2_:Metadata = param1.target as Metadata;
         enabled = _loc2_.getValue(PREVIOUS_ELEMENT) != null && !_loc2_.getValue(SWITCHING);
      }
   }
}
