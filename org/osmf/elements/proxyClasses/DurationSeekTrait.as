package org.osmf.elements.proxyClasses
{
   import org.osmf.traits.SeekTrait;
   import org.osmf.traits.TimeTrait;
   
   public class DurationSeekTrait extends SeekTrait
   {
       
      
      public function DurationSeekTrait(param1:TimeTrait)
      {
         super(param1);
      }
      
      override protected function seekingChangeEnd(param1:Number) : void
      {
         super.seekingChangeEnd(param1);
         if(seeking == true)
         {
            setSeeking(false,param1);
         }
      }
   }
}
