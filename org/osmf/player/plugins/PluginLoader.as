package org.osmf.player.plugins
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.osmf.events.MediaFactoryEvent;
   import org.osmf.media.MediaFactory;
   import org.osmf.media.MediaResourceBase;
   
   public class PluginLoader extends EventDispatcher
   {
       
      
      private var pluginConfigurations:Vector.<MediaResourceBase>;
      
      private var mediaFactory:MediaFactory;
      
      private var loadedCount:int = 0;
      
      public function PluginLoader(param1:Vector.<MediaResourceBase>, param2:MediaFactory)
      {
         super();
         this.pluginConfigurations = param1;
         this.mediaFactory = param2;
      }
      
      public function loadPlugins() : void
      {
         var _loc1_:MediaResourceBase = null;
         if(this.pluginConfigurations.length > 0)
         {
            this.mediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD,this.onPluginLoad);
            this.mediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR,this.onPluginLoadError);
            for each(_loc1_ in this.pluginConfigurations)
            {
               this.mediaFactory.loadPlugin(_loc1_);
            }
         }
         else
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function onPluginLoad(param1:MediaFactoryEvent) : void
      {
         this.loadedCount++;
         if(this.loadedCount == this.pluginConfigurations.length)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function onPluginLoadError(param1:MediaFactoryEvent) : void
      {
         this.loadedCount++;
         if(this.loadedCount == this.pluginConfigurations.length)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
   }
}
