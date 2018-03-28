package org.osmf.player.chrome.widgets
{
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.MouseEvent;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.player.chrome.events.WidgetEvent;
   import org.osmf.traits.MediaTraitType;
   
   public class FullScreenEnterButton extends ButtonWidget
   {
      
      private static const _requiredTraits:Vector.<String> = new Vector.<String>();
      
      {
         _requiredTraits[0] = MediaTraitType.DISPLAY_OBJECT;
      }
      
      public function FullScreenEnterButton()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         upFace = AssetIDs.FULL_SCREEN_ENTER_NORMAL;
         downFace = AssetIDs.FULL_SCREEN_ENTER_DOWN;
         overFace = AssetIDs.FULL_SCREEN_ENTER_OVER;
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
         visible = param1 != null && (stage != null && stage.displayState == StageDisplayState.NORMAL || stage == null);
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         dispatchEvent(new WidgetEvent(WidgetEvent.REQUEST_FULL_SCREEN));
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
