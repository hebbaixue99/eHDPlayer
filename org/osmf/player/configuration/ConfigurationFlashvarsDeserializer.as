package org.osmf.player.configuration
{
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import org.osmf.layout.ScaleMode;
   import org.osmf.media.MediaResourceBase;
   import org.osmf.media.PluginInfoResource;
   import org.osmf.media.URLResource;
   import org.osmf.metadata.Metadata;
   import org.osmf.player.chrome.configuration.ConfigurationUtils;
   import org.osmf.player.metadata.StrobeDynamicMetadata;
   import org.osmf.utils.URL;
   
   public class ConfigurationFlashvarsDeserializer
   {
      
      private static const PLUGIN_PREFIX:String = "plugin";
      
      private static const NAMESPACE_PREFIX:String = "namespace";
      
      private static const PLUGIN_SEPARATOR:String = "_";
      
      private static const NAMESPACE_SEPARATOR:String = "_";
      
      private static const DEFAULT_NAMESPACE_NAME:String = "defaultNamespace";
      
      private static const ROOT:String = "roooooooooooot";
      
      private static const VALIDATION_PATTERN:RegExp = /[a-zA-Z][0-9a-zA-Z]*/;
       
      
      private const enumerationValues:Object = {
         "scaleMode":[ScaleMode.LETTERBOX,ScaleMode.NONE,ScaleMode.STRETCH,ScaleMode.ZOOM],
         "controlBarMode":ControlBarMode.values,
         "videoRenderingMode":VideoRenderingMode.values
      };
      
      private const validators:Object = {
         "src": validateURLProperty,
         "scaleMode":validateEnumProperty,
         "controlBarMode":validateEnumProperty,
         "videoRenderingMode":validateEnumProperty
      };
      
      public function ConfigurationFlashvarsDeserializer()
      {
         super();
      }
      
      public function deserialize(param1:Object, param2:PlayerConfiguration) : void
      {
         var _loc4_:* = null;
         var _loc5_:Vector.<MediaResourceBase> = null;
         var _loc6_:MediaResourceBase = null;
         var _loc7_:RegExp = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc12_:Number = NaN;
         var _loc13_:String = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:String = null;
         if(param1.hasOwnProperty("src") && param1.src != null)
         {
            _loc7_ = /^(rtmp|rtmp[tse]|rtmpte|rtmfp)(:\/[^\/])/i;
            _loc8_ = param1.src.match(_loc7_);
            _loc9_ = param1.src;
            if(_loc8_ != null)
            {
               _loc9_ = param1.src.replace(/:\//,"://localhost/");
            }
            param1.src = _loc9_;
         }
         if(param1.hasOwnProperty("controlserver") && param1.controlserver != null)
         {
            param2.ctrlserver = param1.controlserver;
         }
         if(param1.hasOwnProperty("controlrights") && param1.controlrights != null)
         {
            param2.ctrlrights = param1.controlrights;
         }
         if(param1.hasOwnProperty("tipinfo") && param1.tipinfo != null)
         {
            param2.usrinfo = param1.tipinfo;
         }
         if(param1.hasOwnProperty("tipcolor") && param1.tipcolor != null)
         {
            param2.viewColor = param1.tipcolor;
         }
         else
         {
            param2.viewColor = 16711680;
         }
         if(param1.hasOwnProperty("tiptime") && param1.tiptime != null)
         {
            param2.viewInterval = param1.tiptime;
         }
         else
         {
            param2.viewInterval = 60;
         }
         if(param1.hasOwnProperty("modifystudyrec") && param1.modifystudyrec != null)
         {
            param2.modifystudyrec = param1.modifystudyrec;
         }
         if(param1.hasOwnProperty("logoScope") && param1.logoScope != null)
         {
            param2.logoScope = param1.logoScope;
         }
         var _loc3_:Dictionary = ConfigurationUtils.retrieveFields(PlayerConfiguration,false);
         for(_loc4_ in _loc3_)
         {
            _loc10_ = param1[_loc4_];
            if(param1.hasOwnProperty(_loc4_))
            {
               if(_loc10_ != null && _loc10_.length > 0)
               {
                  _loc11_ = param2[_loc4_];
                  if(_loc4_.indexOf("Color") > 0)
                  {
                     _loc10_ = this.stripColorCode(_loc10_);
                     _loc12_ = parseInt("0x" + _loc10_);
                     if(!isNaN(_loc12_) && _loc12_ <= 16777215)
                     {
                        _loc11_ = _loc12_;
                     }
                  }
                  else
                  {
                     switch(getDefinitionByName(_loc3_[_loc4_]))
                     {
                        case Boolean:
                           _loc13_ = _loc10_.toLowerCase();
                           if(_loc13_ == "true")
                           {
                              _loc11_ = true;
                           }
                           else if(_loc13_ == "false")
                           {
                              _loc11_ = false;
                           }
                           break;
                        case int:
                        case uint:
                           _loc14_ = parseInt(_loc10_);
                           if(!isNaN(_loc14_) && _loc14_ >= 0)
                           {
                              if(this.validators.hasOwnProperty(_loc4_))
                              {
                                 if(this.validators[_loc4_](_loc4_,_loc14_))
                                 {
                                    _loc11_ = _loc10_;
                                 }
                              }
                              else
                              {
                                 _loc11_ = _loc14_;
                              }
                           }
                           break;
                        case Number:
                           _loc15_ = parseFloat(_loc10_);
                           if(!isNaN(_loc15_) && _loc15_ >= 0)
                           {
                              _loc11_ = _loc15_;
                           }
                           break;
                        case String:
                           if(this.validators.hasOwnProperty(_loc4_))
                           {
                              if(this.validators[_loc4_](_loc4_,_loc10_))
                              {
                                 _loc11_ = _loc10_;
                              }
                           }
                           else
                           {
                              _loc11_ = _loc10_;
                           }
                     }
                  }
                  param2[_loc4_] = _loc11_;
               }
            }
         }
         param1["plugin_src"] = "http://osmf.org/metadata.swf";
         _loc5_ = new Vector.<MediaResourceBase>();
         this.deserializePluginConfigurations(param1,_loc5_);
         for each(_loc6_ in _loc5_)
         {
            if(_loc6_ is URLResource && (_loc6_ as URLResource).url == "http://osmf.org/metadata.swf")
            {
               for each(_loc16_ in _loc6_.metadataNamespaceURLs)
               {
                  param2.assetMetadata[_loc16_] = _loc6_.getMetadataValue(_loc16_);
               }
            }
            else
            {
               param2.pluginConfigurations.push(_loc6_);
            }
         }
      }
      
      public function deserializePluginConfigurations(param1:Object, param2:Vector.<MediaResourceBase>) : void
      {
         var _loc5_:* = null;
         var _loc6_:String = null;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = null;
         var _loc12_:MediaResourceBase = null;
         var _loc13_:Class = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:MediaResourceBase = null;
         var _loc17_:Metadata = null;
         var _loc3_:Object = new Object();
         var _loc4_:Object = new Object();
         for(_loc5_ in param1)
         {
            _loc6_ = param1[_loc5_];
            if(_loc5_.indexOf(PLUGIN_PREFIX + PLUGIN_SEPARATOR) == 0)
            {
               _loc7_ = _loc5_.substring(PLUGIN_PREFIX.length + PLUGIN_SEPARATOR.length);
               if(_loc7_ != PLUGIN_PREFIX && this.validateAgainstPatterns(_loc7_,VALIDATION_PATTERN))
               {
                  if((_loc6_.substr(0,4) == "http" || _loc6_.substr(0,4) == "file" || _loc6_.substr(_loc6_.length - 4,4) == ".swf") && this.validateURLProperty(_loc5_,_loc6_,true))
                  {
                     _loc12_ = new URLResource(_loc6_);
                  }
                  else if(ApplicationDomain.currentDomain.hasDefinition(_loc6_))
                  {
                     _loc13_ = getDefinitionByName(_loc6_) as Class;
                     _loc12_ = new PluginInfoResource(new _loc13_());
                  }
                  if(_loc12_)
                  {
                     _loc3_[_loc7_] = _loc12_;
                     _loc4_[_loc7_] = new Object();
                     param2.push(_loc12_);
                  }
               }
            }
         }
         for(_loc5_ in param1)
         {
            _loc6_ = param1[_loc5_];
            _loc9_ = _loc5_.indexOf(PLUGIN_SEPARATOR);
            if(_loc9_ > 0)
            {
               _loc7_ = _loc5_.substring(0,_loc9_);
               _loc8_ = _loc5_.substring(_loc9_ + 1);
               if(_loc4_.hasOwnProperty(_loc7_))
               {
                  if(_loc8_.indexOf(NAMESPACE_PREFIX) == 0)
                  {
                     _loc10_ = _loc8_.indexOf(NAMESPACE_SEPARATOR);
                     _loc11_ = DEFAULT_NAMESPACE_NAME;
                     if(_loc10_ > 0)
                     {
                        _loc11_ = _loc8_.substring(_loc10_ + 1);
                     }
                     if(_loc11_ != NAMESPACE_PREFIX && this.validateAgainstPatterns(_loc11_,VALIDATION_PATTERN))
                     {
                        _loc4_[_loc7_][_loc11_] = new Object();
                        _loc4_[_loc7_][_loc11_][NAMESPACE_PREFIX] = _loc6_;
                     }
                  }
               }
            }
         }
         for(_loc5_ in param1)
         {
            _loc6_ = param1[_loc5_];
            _loc9_ = _loc5_.indexOf(PLUGIN_SEPARATOR);
            if(_loc9_ > 0)
            {
               _loc7_ = _loc5_.substring(0,_loc9_);
               _loc8_ = _loc5_.substring(_loc9_ + 1);
               if(_loc3_.hasOwnProperty(_loc7_) && _loc8_ != PLUGIN_PREFIX)
               {
                  _loc10_ = _loc8_.indexOf(NAMESPACE_SEPARATOR);
                  _loc11_ = DEFAULT_NAMESPACE_NAME;
                  if(_loc10_ > 0)
                  {
                     _loc14_ = _loc8_.substring(0,_loc10_);
                     if(_loc4_[_loc7_].hasOwnProperty(_loc14_))
                     {
                        _loc11_ = _loc14_;
                        _loc8_ = _loc8_.substring(_loc10_ + 1);
                     }
                  }
                  if(_loc4_[_loc7_].hasOwnProperty(_loc11_))
                  {
                     _loc4_[_loc7_][_loc11_][_loc8_] = _loc6_;
                  }
                  else
                  {
                     if(!_loc4_[_loc7_].hasOwnProperty(ROOT))
                     {
                        _loc4_[_loc7_][ROOT] = new Object();
                     }
                     _loc4_[_loc7_][ROOT][_loc8_] = _loc6_;
                  }
               }
            }
         }
         for(_loc7_ in _loc4_)
         {
            for(_loc11_ in _loc4_[_loc7_])
            {
               _loc15_ = _loc4_[_loc7_][_loc11_][NAMESPACE_PREFIX];
               _loc16_ = _loc3_[_loc7_] as MediaResourceBase;
               if(_loc11_ == ROOT)
               {
                  for(_loc8_ in _loc4_[_loc7_][_loc11_])
                  {
                     _loc16_.addMetadataValue(_loc8_,_loc4_[_loc7_][_loc11_][_loc8_]);
                  }
               }
               else
               {
                  _loc17_ = _loc16_.getMetadataValue(_loc15_) as Metadata;
                  if(_loc17_ == null)
                  {
                     _loc17_ = new StrobeDynamicMetadata();
                  }
                  for(_loc8_ in _loc4_[_loc7_][_loc11_])
                  {
                     if(_loc8_ != NAMESPACE_PREFIX)
                     {
                        _loc17_.addValue(_loc8_,_loc4_[_loc7_][_loc11_][_loc8_]);
                        _loc17_[_loc8_] = _loc4_[_loc7_][_loc11_][_loc8_];
                     }
                  }
                  _loc16_.addMetadataValue(_loc15_,_loc17_);
               }
            }
         }
      }
      
      private function validateAgainstPatterns(param1:String, param2:RegExp) : Boolean
      {
         var _loc3_:Array = param1.match(param2);
         return _loc3_ != null && _loc3_[0] == param1;
      }
      
      public function validateURLProperty(param1:String, param2:String, param3:Boolean = false) : Boolean
      {
         var _loc4_:URL = new URL(param2);
         if(_loc4_.absolute && _loc4_.host.length > 0 || (!!param3?Boolean(param2.match(/^[^:]+swf$/)):Boolean(_loc4_.path == _loc4_.rawUrl && param2.search("javascript") != 0)))
         {
            return true;
         }
         return false;
      }
      
      private function validatePluginURLProperty(param1:String, param2:String, param3:Boolean = false) : Boolean
      {
         var _loc4_:URL = new URL(param2);
         if(_loc4_.absolute && _loc4_.host.length > 0 || (!!param3?Boolean(param2.match(/^[^:]+swf$/)):Boolean(_loc4_.path == _loc4_.rawUrl && param2.search("javascript") != 0)))
         {
            return true;
         }
         return false;
      }
      
      public function validateEnumProperty(param1:String, param2:Object) : Boolean
      {
         var _loc3_:Array = this.enumerationValues[param1];
         if(_loc3_.indexOf(param2) >= 0)
         {
            return true;
         }
         return false;
      }
      
      private function stripColorCode(param1:String) : String
      {
         var _loc2_:String = param1;
         if(param1.substring(0,1) == "_")
         {
            _loc2_ = param1.substring(1);
         }
         else if(param1.substring(0,2) == "0x")
         {
            _loc2_ = param1.substring(2);
         }
         return _loc2_;
      }
   }
}
