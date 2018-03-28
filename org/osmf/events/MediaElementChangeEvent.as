package org.osmf.events
{
   import flash.events.Event;
   
   public class MediaElementChangeEvent extends Event
   {
      
      public static const MEDIA_ELEMENT_CHANGE:String = "mediaElementChange";
      
      public static const MEDIA_URL_CHANGE:String = "mediaUrlChange";
       
      
      private var _urlid:Number;
      
      public function MediaElementChangeEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Number = NaN)
      {
         super(param1,param2,param3);
         this._urlid = param4;
      }
      
      override public function clone() : Event
      {
         return new MediaElementChangeEvent(type,bubbles,cancelable,this._urlid);
      }
      
      public function get uid() : Number
      {
         return this._urlid;
      }
   }
}
