package org.osmf.player.elements
{
   import flash.events.Event;
   import org.osmf.elements.LoadFromDocumentElement;
   import org.osmf.events.MetadataEvent;
   import org.osmf.metadata.Metadata;
   import org.osmf.player.elements.playlistClasses.PlaylistLoader;
   import org.osmf.player.elements.playlistClasses.PlaylistMetadata;
   import org.osmf.player.elements.playlistClasses.ProxyMetadataEx;
   
   public class PlaylistElement extends LoadFromDocumentElement
   {
       
      
      private var loader:PlaylistLoader;
      
      private var playlistMetadata:PlaylistMetadata;
      
      public function PlaylistElement(param1:PlaylistLoader = null)
      {
         this.loader = param1 || new PlaylistLoader();
         param1.addEventListener(Event.COMPLETE,this.onLoaderComplete);
         super(null,param1);
      }
      
      override protected function createMetadata() : Metadata
      {
         return new ProxyMetadataEx();
      }
      
      private function onLoaderComplete(param1:Event) : void
      {
         this.playlistMetadata = this.loader.playlistMetadata;
         this.playlistMetadata.addEventListener(MetadataEvent.VALUE_CHANGE,this.onMetadataValueChange);
         metadata.addValue(PlaylistMetadata.NAMESPACE,this.playlistMetadata);
      }
      
      private function onMetadataValueChange(param1:MetadataEvent) : void
      {
         if(param1.key == PlaylistMetadata.GOTO_NEXT && param1.value == true)
         {
            this.playlistMetadata.addValue(PlaylistMetadata.GOTO_NEXT,false);
            this.loader.playlistElement.activateNextElement();
         }
         else if(param1.key == PlaylistMetadata.GOTO_PREVIOUS && param1.value == true)
         {
            this.playlistMetadata.addValue(PlaylistMetadata.GOTO_PREVIOUS,false);
            this.loader.playlistElement.activatePreviousElement();
         }
      }
   }
}
