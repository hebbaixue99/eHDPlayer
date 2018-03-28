package org.osmf.player.media
{
   import flash.errors.IllegalOperationError;
   import flash.net.NetStream;
   import flash.utils.Dictionary;
   import org.osmf.elements.VideoElement;
   import org.osmf.net.NetStreamLoadTrait;
   import org.osmf.traits.MediaTraitType;
   
   public class VideoElementRegistry
   {
      
      private static var instance:VideoElementRegistry;
       
      
      private var _videoElements:Dictionary;
      
      public function VideoElementRegistry(param1:Class = null)
      {
         super();
         if(param1 != ConstructorLock_320)
         {
            throw new IllegalOperationError("VideoElementRegistry is a singleton: use getInstance to obtain a reference.");
         }
         this._videoElements = new Dictionary(true);
      }
      
      public static function getInstance() : VideoElementRegistry
      {
         instance = instance || new VideoElementRegistry(ConstructorLock_320);
         return instance;
      }
      
      public function register(param1:VideoElement) : void
      {
         this._videoElements[param1] = true;
      }
      
      public function retriveMediaElementByNetStream(param1:NetStream) : VideoElement
      {
         var _loc2_:VideoElement = null;
         var _loc3_:* = null;
         var _loc4_:VideoElement = null;
         var _loc5_:NetStreamLoadTrait = null;
         for(_loc3_ in this._videoElements)
         {
            _loc4_ = _loc3_ as VideoElement;
            _loc5_ = _loc4_.getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
            if(_loc5_.netStream == param1)
            {
               return _loc4_;
            }
         }
         return _loc2_;
      }
   }
}

class ConstructorLock_320
{
    
   
   function ConstructorLock_320()
   {
      super();
   }
}
