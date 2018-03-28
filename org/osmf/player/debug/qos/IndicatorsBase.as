package org.osmf.player.debug.qos
{
   import flash.utils.Dictionary;
   import org.osmf.player.chrome.configuration.ConfigurationUtils;
   
   public class IndicatorsBase
   {
       
      
      public function IndicatorsBase()
      {
         super();
      }
      
      public function getFields() : Array
      {
         var _loc5_:* = null;
         var _loc1_:Array = this.getOrderedFieldList();
         var _loc2_:Array = this.getFilterFieldList();
         var _loc3_:Dictionary = ConfigurationUtils.retrieveFields(this,false);
         var _loc4_:Array = new Array();
         for(_loc5_ in _loc3_)
         {
            if(_loc2_.indexOf(_loc5_) < 0 && _loc1_.indexOf(_loc5_) < 0)
            {
               _loc4_.push(_loc5_);
            }
         }
         _loc4_.sort();
         _loc1_ = _loc1_.concat(_loc4_);
         return _loc1_;
      }
      
      protected function getOrderedFieldList() : Array
      {
         return [];
      }
      
      protected function getFilterFieldList() : Array
      {
         return [];
      }
   }
}
