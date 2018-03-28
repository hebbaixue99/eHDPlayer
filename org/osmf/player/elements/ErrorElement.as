package org.osmf.player.elements
{
   import org.osmf.layout.LayoutMetadata;
   import org.osmf.media.MediaElement;
   import org.osmf.player.chrome.ChromeProvider;
   import org.osmf.traits.DisplayObjectTrait;
   
   public class ErrorElement extends MediaElement
   {
       
      
      private var errorMessage:String;
      
      public function ErrorElement(param1:String)
      {
         this.errorMessage = param1;
         super();
      }
      
      override protected function setupTraits() : void
      {
         super.setupTraits();
         var _loc1_:ChromeProvider = ChromeProvider.getInstance();
         _loc1_.createErrorWidget();
         var _loc2_:ErrorWidget = _loc1_.getWidget("error") as ErrorWidget;
         _loc2_.errorMessage = this.errorMessage;
         _loc2_.measure();
         addMetadata(LayoutMetadata.LAYOUT_NAMESPACE,_loc2_.layoutMetadata);
         var _loc3_:DisplayObjectTrait = new DisplayObjectTrait(_loc2_,_loc2_.measuredWidth,_loc2_.measuredHeight);
         addTrait(_loc3_.traitType,_loc3_);
      }
   }
}
