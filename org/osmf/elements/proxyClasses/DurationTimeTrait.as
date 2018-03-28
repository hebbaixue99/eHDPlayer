package org.osmf.elements.proxyClasses
{
   import org.osmf.traits.TimeTrait;
   
   public class DurationTimeTrait extends TimeTrait
   {
       
      
      public function DurationTimeTrait(param1:Number)
      {
         super(param1);
      }
      
      public function set currentTime(param1:Number) : void
      {
         super.setCurrentTime(param1);
      }
   }
}
