package org.osmf.player.chrome.widgets
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.osmf.player.chrome.assets.AssetIDs;
   import org.osmf.traits.MediaTraitType;
   import org.osmf.traits.PlayState;
   import org.osmf.traits.PlayTrait;
   
   public class PlayButton extends PlayableButton
   {
       
      
      public function PlayButton()
      {
         super();
         upFace = AssetIDs.PLAY_BUTTON_NORMAL;
         downFace = AssetIDs.PLAY_BUTTON_DOWN;
         overFace = AssetIDs.PLAY_BUTTON_OVER;
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:PlayTrait = media.getTrait(MediaTraitType.PLAY) as PlayTrait;
         _loc2_.play();
      }
      
      override protected function visibilityDeterminingEventHandler(param1:Event = null) : void
      {
         visible = playable && playable.playState != PlayState.PLAYING;
      }
   }
}
