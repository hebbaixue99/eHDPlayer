package org.osmf.player.debug.qos
{
   public class RenderingIndicators extends IndicatorsBase
   {
       
      
      public var width:uint;
      
      public var height:uint;
      
      public var aspectRatio:Number;
      
      public var HD:Boolean;
      
      public var smoothing:Boolean;
      
      public var deblocking:String;
      
      public var fullScreenSourceRect:String;
      
      public var fullScreenSourceRectAspectRatio:Number;
      
      public var screenWidth:Number;
      
      public var screenHeight:Number;
      
      public var screenAspectRatio:Number;
      
      public function RenderingIndicators()
      {
         super();
      }
      
      override protected function getOrderedFieldList() : Array
      {
         return ["width","height","aspectRatio","HD","smoothing","deblocking","fullScreenSourceRect","fullScreenSourceRectAspectRatio","screenWidth","screenHeight","screenAspectRatio"];
      }
   }
}
