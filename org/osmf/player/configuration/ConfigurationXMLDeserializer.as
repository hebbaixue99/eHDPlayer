package org.osmf.player.configuration
{
   import org.osmf.media.MediaResourceBase;
   import org.osmf.media.URLResource;
   
   public class ConfigurationXMLDeserializer
   {
       
      
      private const METADATA:String = "metadata";
      
      private const PLUGIN:String = "plugin";
      
      private const PARAM:String = "param";
      
      private const NAMESPACE:String = "namespace";
      
      private const ASSET_METADATA_PREFIX:String = "src_";
      
      public function ConfigurationXMLDeserializer()
      {
         super();
      }
      
      public function deserialize(param1:XML, param2:PlayerConfiguration) : void
      {
         var _loc7_:XML = null;
         var _loc8_:String = null;
         var _loc3_:Object = new Object();
         this.addChildKeyValuePairs(param1,_loc3_);
         var _loc4_:XMLList = param1.children();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_.length())
         {
            _loc7_ = _loc4_[_loc5_];
            _loc8_ = _loc7_.name();
            if(_loc8_ == this.PLUGIN)
            {
               this.deserializePluginConfiguration(_loc3_,_loc7_);
            }
            else if(_loc8_ == this.METADATA)
            {
               this.addMetadataValues(_loc7_,_loc3_,this.ASSET_METADATA_PREFIX);
            }
            _loc5_++;
         }
         var _loc6_:ConfigurationFlashvarsDeserializer = new ConfigurationFlashvarsDeserializer();
         _loc6_.deserialize(_loc3_,param2);
      }
      
      public function deserializePluginConfiguration(param1:Object, param2:XML) : void
      {
         var _loc9_:XML = null;
         var _loc10_:String = null;
         var _loc3_:* = this.PLUGIN + "_p";
         var _loc4_:uint = 0;
         while(param1.hasOwnProperty(_loc3_ + _loc4_))
         {
            _loc4_++;
         }
         var _loc5_:String = param2.src || param2.@src;
         param1[_loc3_ + _loc4_] = _loc5_.toString();
         var _loc6_:MediaResourceBase = new URLResource(param2.src || param2.@src);
         var _loc7_:XMLList = param2.children();
         var _loc8_:uint = 0;
         while(_loc8_ < _loc7_.length())
         {
            _loc9_ = _loc7_[_loc8_];
            _loc10_ = _loc9_.name();
            if(_loc10_ == this.METADATA)
            {
               this.addMetadataValues(_loc9_,param1,"p" + _loc4_ + "_");
            }
            _loc8_++;
         }
      }
      
      private function addMetadataValues(param1:XML, param2:Object, param3:String = "") : void
      {
         var _loc5_:uint = 0;
         var _loc4_:String = param1.@id;
         if(_loc4_.length > 0)
         {
            _loc5_ = 0;
            while(param2.hasOwnProperty(param3 + this.NAMESPACE + "_n" + _loc5_))
            {
               _loc5_++;
            }
            param2[param3 + this.NAMESPACE + "_n" + _loc5_] = _loc4_;
            param3 = param3 + ("n" + _loc5_ + "_");
         }
         this.addChildKeyValuePairs(param1,param2,param3);
      }
      
      private function addChildKeyValuePairs(param1:XML, param2:Object, param3:String = "") : void
      {
         var _loc8_:String = null;
         var _loc9_:XML = null;
         var _loc10_:String = null;
         var _loc4_:XMLList = param1.attributes();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_.length())
         {
            _loc8_ = _loc4_[_loc5_].name();
            param2[param3 + _loc8_] = param1.attribute(_loc8_).toString();
            _loc5_++;
         }
         var _loc6_:XMLList = param1.children();
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_.length())
         {
            _loc9_ = _loc6_[_loc7_];
            _loc10_ = _loc9_.name();
            if(_loc9_.children().length() == 1)
            {
               param2[param3 + _loc10_] = _loc9_.children()[0].toXMLString();
            }
            else if(_loc10_ == this.PARAM)
            {
               param2[param3 + _loc9_.@name] = _loc9_.@value.toXMLString();
            }
            _loc7_++;
         }
      }
   }
}
