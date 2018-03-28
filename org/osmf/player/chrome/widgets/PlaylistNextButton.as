package org.osmf.player.chrome.widgets
{
   import flash.events.MouseEvent;
   import org.osmf.events.MediaElementEvent;
   import org.osmf.events.MetadataEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.metadata.Metadata;
   import org.osmf.player.chrome.assets.AssetIDs;
   
   public class PlaylistNextButton extends ButtonWidget
   {
       
      
      public function PlaylistNextButton()
      {
         super();
         upFace = AssetIDs.NEXT_BUTTON_NORMAL;
         downFace = AssetIDs.NEXT_BUTTON_DOWN;
         overFace = AssetIDs.NEXT_BUTTON_OVER;
         disabledFace = AssetIDs.NEXT_BUTTON_DISABLED;
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
         var _loc2_:Metadata = !!media?media.getMetadata("http://www.osmf.org.player/1.0/playlist"):null;
         if(_loc2_)
         {
            _loc2_.addValue("gotoNext",true);
         }
      }
      
      private function onPlaylistMetadataChange(param1:MediaElementEvent = null) : void
      {
         var _loc2_:Metadata = !!media?media.getMetadata("http://www.osmf.org.player/1.0/playlist"):null;
         visible = _loc2_ != null;
         if(_loc2_)
         {
            _loc2_.addEventListener(MetadataEvent.VALUE_CHANGE,this.onPlaylistMetadataValueChange);
            enabled = _loc2_.getValue("nextElement") != null;
         }
      }
      
      private function onPlaylistMetadataValueChange(param1:MetadataEvent) : void
      {
         var _loc2_:Metadata = param1.target as Metadata;
         enabled = _loc2_.getValue("nextElement") != null && !_loc2_.getValue("switching");
      }
   }
}
