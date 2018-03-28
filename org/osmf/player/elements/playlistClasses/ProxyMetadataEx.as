package org.osmf.player.elements.playlistClasses
{
   import flash.events.Event;
   import org.osmf.elements.proxyClasses.ProxyMetadata;
   import org.osmf.events.MetadataEvent;
   import org.osmf.metadata.Metadata;
   
   public class ProxyMetadataEx extends ProxyMetadata
   {
       
      
      private var proxiedMetadata:Metadata;
      
      public function ProxyMetadataEx()
      {
         super();
         this.proxiedMetadata = new Metadata();
         this.proxiedMetadata.addEventListener(MetadataEvent.VALUE_ADD,this.redispatchEvent);
         this.proxiedMetadata.addEventListener(MetadataEvent.VALUE_CHANGE,this.redispatchEvent);
         this.proxiedMetadata.addEventListener(MetadataEvent.VALUE_REMOVE,this.redispatchEvent);
      }
      
      override public function set metadata(param1:Metadata) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.proxiedMetadata.keys)
         {
            param1.addValue(_loc2_,this.proxiedMetadata.getValue(_loc2_));
         }
         this.proxiedMetadata = param1;
         this.proxiedMetadata.addEventListener(MetadataEvent.VALUE_ADD,this.redispatchEvent);
         this.proxiedMetadata.addEventListener(MetadataEvent.VALUE_CHANGE,this.redispatchEvent);
         this.proxiedMetadata.addEventListener(MetadataEvent.VALUE_REMOVE,this.redispatchEvent);
      }
      
      override public function getValue(param1:String) : *
      {
         return this.proxiedMetadata.getValue(param1);
      }
      
      override public function addValue(param1:String, param2:Object) : void
      {
         this.proxiedMetadata.addValue(param1,param2);
      }
      
      override public function removeValue(param1:String) : *
      {
         return this.proxiedMetadata.removeValue(param1);
      }
      
      override public function get keys() : Vector.<String>
      {
         return this.proxiedMetadata.keys;
      }
      
      private function redispatchEvent(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
   }
}
