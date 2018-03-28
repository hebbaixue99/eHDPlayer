package org.osmf.player.elements.playlistClasses
{
   import org.osmf.media.MediaResourceBase;
   import org.osmf.media.URLResource;
   import org.osmf.net.StreamType;
   import org.osmf.net.StreamingURLResource;
   
   class PlaylistParser
   {
       
      
      private var resourceConstructorFunction:Function;
      
      function PlaylistParser(param1:Function = null)
      {
         this.resourceConstructorFunction = this.constructResource;
         super();
         this.resourceConstructorFunction = param1 || this.resourceConstructorFunction;
      }
      
      public function parse(param1:String) : Vector.<MediaResourceBase>
      {
         var _loc2_:Vector.<MediaResourceBase> = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:StreamingURLResource = null;
         if(param1)
         {
            _loc3_ = param1.split("\n");
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_ && _loc4_.length)
               {
                  if(_loc4_.charAt(0) != "_")
                  {
                     _loc2_ = _loc2_ || new Vector.<MediaResourceBase>();
                     _loc5_ = this.resourceConstructorFunction(_loc4_);
                     _loc2_.push(new URLResource(_loc4_));
                  }
               }
            }
         }
         if(_loc2_ == null || _loc2_.length == 0)
         {
            throw new Error("Playlist contains no resources");
         }
         return _loc2_;
      }
      
      private function constructResource(param1:String) : MediaResourceBase
      {
         return new StreamingURLResource(param1,StreamType.LIVE_OR_RECORDED);
      }
   }
}
