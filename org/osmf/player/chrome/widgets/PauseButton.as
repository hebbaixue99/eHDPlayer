package org.osmf.player.chrome.widgets
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.PlayState;
   import org.osmf.traits.PlayTrait;
   
   public class PauseButton extends PlayableButton
   {
       
      
      public function PauseButton()
      {
         super();
         upFace = AssetIDs.PAUSE_BUTTON_NORMAL;
         downFace = AssetIDs.PAUSE_BUTTON_DOWN;
         overFace = AssetIDs.PAUSE_BUTTON_OVER;
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:PlayTrait = media.getTrait(MediaTraitType.PLAY) as PlayTrait;
         if(_loc2_.canPause)
         {
            _loc2_.pause();
         }
         else
         {
            _loc2_.stop();
         }
      }
      
      override protected function visibilityDeterminingEventHandler(param1:Event = null) : void
      {
         visible = playable && playable.playState == PlayState.PLAYING;
      }
   }
}
