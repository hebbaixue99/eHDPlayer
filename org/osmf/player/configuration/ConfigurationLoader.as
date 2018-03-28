package org.osmf.player.configuration
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   
   public class ConfigurationLoader extends EventDispatcher
   {
       
      
      private var loader:XMLFileLoader;
      
      public function ConfigurationLoader(param1:XMLFileLoader)
      {
         super();
         this.loader = param1;
      }
      
      public function load(param1:Object, param2:PlayerConfiguration) : void
      {
         var configurationDeserializer:ConfigurationFlashvarsDeserializer = null;
         var xmlDeserializer:ConfigurationXMLDeserializer = null;
         var loadXMLConfiguration:Function = null;
         var parameters:Object = param1;
         var configuration:PlayerConfiguration = param2;
         configurationDeserializer = new ConfigurationFlashvarsDeserializer();
         if(parameters.hasOwnProperty("configuration"))
         {
            loadXMLConfiguration = function(param1:Event):void
            {
               loader.removeEventListener(Event.COMPLETE,loadXMLConfiguration);
               loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,loadXMLConfiguration);
               loader.removeEventListener(IOErrorEvent.IO_ERROR,loadXMLConfiguration);
               if(loader.xml != null)
               {
                  xmlDeserializer.deserialize(loader.xml,configuration);
               }
               configurationDeserializer.deserialize(parameters,configuration);
               dispatchEvent(new Event(Event.COMPLETE));
            };
            xmlDeserializer = new ConfigurationXMLDeserializer();
            this.loader.addEventListener(Event.COMPLETE,loadXMLConfiguration);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,loadXMLConfiguration);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR,loadXMLConfiguration);
            this.loader.load(parameters.configuration);
         }
         else
         {
			 ExternalInterface.call("msg","load");
            configurationDeserializer.deserialize(parameters,configuration);
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
   }
}
