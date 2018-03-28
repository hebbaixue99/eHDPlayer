package org.osmf.player.configuration
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class XMLFileLoader extends EventDispatcher
   {
       
      
      private var loader:URLLoader;
      
      private var url:String;
      
      public function XMLFileLoader()
      {
         super();
      }
      
      public function load(param1:String) : void
      {
         this.url = param1;
         this.loader = new URLLoader();
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandler);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         this.loader.addEventListener(Event.COMPLETE,this.completionSignalingHandler);
         this.loader.load(new URLRequest(param1));
      }
      
      public function get xml() : XML
      {
         var xml:XML = null;
         try
         {
            xml = !!this.loader?this.loader.data != null?new XML(this.loader.data):null:null;
         }
         catch(error:Error)
         {
         }
         return xml;
      }
      
      private function completionSignalingHandler(param1:Event) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function errorHandler(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
   }
}
