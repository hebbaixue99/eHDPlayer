package org.osmf.player.chrome.utils
{
   import org.osmf.media.MediaElement;
   import org.osmf.media.MediaResourceBase;
   import org.osmf.net.StreamingURLResource;
   
   public class MediaElementUtils
   {
       
      
      public function MediaElementUtils()
      {
         super();
      }
      
      public static function getMediaElementParentOfType(param1:MediaElement, param2:Class) : MediaElement
      {
         if(param1 is param2)
         {
            return param1;
         }
         if(param1.hasOwnProperty("proxiedElement") && param1["proxiedElement"] != null)
         {
            return getMediaElementParentOfType(param1["proxiedElement"],param2);
         }
         return null;
      }
      
      public static function getResourceFromParentOfType(param1:MediaElement, param2:Class) : MediaResourceBase
      {
         var _loc3_:MediaResourceBase = null;
         if(param1.hasOwnProperty("proxiedElement") && param1["proxiedElement"] != null)
         {
            _loc3_ = getResourceFromParentOfType(param1["proxiedElement"],param2);
         }
         if(_loc3_ == null && param1.resource is param2)
         {
            _loc3_ = param1.resource;
         }
         return _loc3_;
      }
      
      public static function getStreamType(param1:MediaElement) : String
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:StreamingURLResource = getResourceFromParentOfType(param1,StreamingURLResource) as StreamingURLResource;
         if(_loc2_ != null)
         {
            return _loc2_.streamType;
         }
         return null;
      }
   }
}
