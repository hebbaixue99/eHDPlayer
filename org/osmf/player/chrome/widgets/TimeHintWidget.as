package org.osmf.player.chrome.widgets
{
   public class TimeHintWidget extends LabelWidget
   {
       
      
      private var textFieldSpacing:uint = 3;
      
      public function TimeHintWidget()
      {
         super();
      }
      
      override public function set text(param1:String) : void
      {
         if(param1 != text)
         {
            super.text = param1;
            textField.width = textField.textWidth;
            textField.x = getChildAt(0).width / 2 - textField.width / 2;
            textField.y = this.textFieldSpacing;
         }
      }
   }
}
