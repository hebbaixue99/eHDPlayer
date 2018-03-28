package org.osmf.player.chrome.widgets
{
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.MouseEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.traits.MediaTraitType;
   
   public class FullScreenLeaveButton extends ButtonWidget
   {
      
      private static const _requiredTraits:Vector.<String> = new Vector.<String>();
      
      {
         _requiredTraits[0] = MediaTraitType.DISPLAY_OBJECT;
      }
      
      public function FullScreenLeaveButton()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         upFace = AssetIDs.FULL_SCREEN_LEAVE_NORMAL;
         downFace = AssetIDs.FULL_SCREEN_LEAVE_DOWN;
         overFace = AssetIDs.FULL_SCREEN_LEAVE_OVER;
      }
      
      override protected function get requiredTraits() : Vector.<String>
      {
         return _requiredTraits;
      }
      
      override protected function processRequiredTraitsUnavailable(param1:MediaElement) : void
      {
         visible = false;
      }
      
      override protected function processRequiredTraitsAvailable(param1:MediaElement) : void
      {
         visible = param1 != null && stage != null && stage.displayState != StageDisplayState.NORMAL;
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         stage.displayState = StageDisplayState.NORMAL;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreenEvent);
         this.processRequiredTraitsAvailable(media);
      }
      
      private function onFullScreenEvent(param1:FullScreenEvent) : void
      {
         this.processRequiredTraitsAvailable(media);
      }
   }
}
