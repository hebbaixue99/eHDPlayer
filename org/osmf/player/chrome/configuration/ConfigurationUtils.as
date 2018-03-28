package org.osmf.player.chrome.configuration
{
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class ConfigurationUtils
   {
       
      
      public function ConfigurationUtils()
      {
         super();
      }
      
      public static function retrieveFields(param1:*, param2:Boolean = true) : Dictionary
      {
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         if(!(param1 is Class))
         {
            param1 = getDefinitionByName(getQualifiedClassName(param1));
         }
         var _loc3_:XML = describeType(param1);
         var _loc4_:Dictionary = new Dictionary();
         for each(_loc5_ in _loc3_.factory.variable)
         {
            _loc4_[_loc5_.@name.toString()] = _loc5_.@type.toString();
         }
         for each(_loc6_ in _loc3_.factory.accessor)
         {
            if(!(param2 && _loc6_.@access == "readonly"))
            {
               _loc4_[_loc6_.@name.toString()] = _loc6_.@type.toString();
            }
         }
         return _loc4_;
      }
   }
}
