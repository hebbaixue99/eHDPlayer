package org.osmf.player.debug
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import org.osmf.logging.TraceLogger;
   import org.osmf.media.MediaResourceBase;
   import org.osmf.metadata.Metadata;
   import org.osmf.player.chrome.configuration.ConfigurationUtils;
   import org.osmf.player.debug.qos.QoSDashboard;
   
   public class StrobeLogger extends TraceLogger
   {
       
      
      private var logHandler:LogHandler;
      
      public function StrobeLogger(param1:String, param2:LogHandler)
      {
         super(param1);
         this.logHandler = param2;
      }
      
      public function get qos() : QoSDashboard
      {
         return this.logHandler.qos;
      }
      
      public function trackProperty(param1:String, param2:String, param3:Object) : void
      {
         this.logHandler.handleProperty(param1 + "__" + param2,param3);
      }
      
      public function trackObject(param1:String, param2:Object, param3:String = "") : void
      {
         var key:String = null;
         var value:Object = null;
         var fields:Dictionary = null;
         var f:String = null;
         var id:String = param1;
         var object:Object = param2;
         var prefix:String = param3;
         var dyn:Boolean = false;
         for(key in object)
         {
            dyn = true;
            value = object[key];
            if(!(value is Array || getQualifiedClassName(value).indexOf("::") > 0))
            {
               if(getQualifiedClassName(value) == "Object")
               {
                  this.trackObject(id,value,prefix + key + ".");
               }
               else
               {
                  this.trackProperty(id,prefix + key,value);
               }
            }
         }
         if(!dyn)
         {
            fields = ConfigurationUtils.retrieveFields(object,false);
            for(f in fields)
            {
               try
               {
                  if(fields[f].indexOf("::") < 0 && fields[f].indexOf("Object") < 0 && fields[f].indexOf("Array") < 0)
                  {
                     this.trackProperty(id,f,object[f]);
                  }
               }
               catch(ignore:Error)
               {
                  continue;
               }
            }
            if(object is MediaResourceBase)
            {
               this.trackResource(id,object as MediaResourceBase);
            }
         }
      }
      
      public function trackResource(param1:String, param2:MediaResourceBase) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         for each(_loc3_ in param2.metadataNamespaceURLs)
         {
            _loc4_ = param2.getMetadataValue(_loc3_);
            if(this.isPrimitive(_loc4_))
            {
               this.trackProperty(param1,"metadata[" + _loc3_ + "]",_loc4_);
            }
            else if(_loc4_ is Metadata)
            {
               this.trackMetadata(param1,"metadata[" + _loc3_ + "]",_loc4_ as Metadata);
            }
            else
            {
               this.trackObject(param1,_loc4_,"metadata[" + _loc3_ + "]");
            }
         }
      }
      
      public function event(param1:Event) : void
      {
         var f:String = null;
         var event:Event = param1;
         this.trackObject("StrobeMediaPlayer",event.target);
         var msg:String = getQualifiedClassName(event);
         msg = msg + " (";
         var fields:Dictionary = ConfigurationUtils.retrieveFields(event,false);
         for(f in fields)
         {
            try
            {
               if(f != "cancelable" && f != "bubbles" && f != "eventPhase")
               {
                  if(fields[f].indexOf("::") < 0 && fields[f].indexOf("Object") < 0 && fields[f].indexOf("Array") < 0)
                  {
                     msg = msg + (f + ":" + event[f] + "  ");
                  }
               }
            }
            catch(ignore:Error)
            {
               continue;
            }
         }
         msg = msg + ")";
         this.logMessage("EVENT",msg,new Array());
      }
      
      override protected function logMessage(param1:String, param2:String, param3:Array) : void
      {
         var _loc4_:LogMessage = new LogMessage(param1,category,param2,param3);
         this.logHandler.handleLogMessage(_loc4_);
      }
      
      private function trackMetadata(param1:String, param2:String, param3:Metadata) : void
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         for each(_loc4_ in param3.keys)
         {
            _loc5_ = param3.getValue(_loc4_);
            if(this.isPrimitive(_loc5_))
            {
               this.trackProperty(param1,param2 + "." + _loc4_,_loc5_);
            }
            else
            {
               this.trackObject(param1,_loc5_,param2 + ".");
            }
         }
      }
      
      private function isPrimitive(param1:Object) : Boolean
      {
         return param1 is String || param1 is Number || param1 is Boolean || param1 is uint || param1 is int;
      }
   }
}
