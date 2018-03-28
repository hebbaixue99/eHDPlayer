package org.osmf.player.errors
{
   import org.osmf.events.MediaError;
   import org.osmf.events.MediaErrorCodes;
   
   public class ErrorTranslator
   {
      
      static const UNKNOWN_ERROR:String = "An unknown error occured. We apologize for the inconvenience.";
      
      static const GENERIC_ERROR:String = "We are having problems with playback. We apologize for the inconvenience.";
      
      static const NETWORK_ERROR:String = "We are unable to connect to the network. We apologize for the inconvenience.";
      
      static const NOT_FOUND_ERROR:String = "We are unable to connect to the content you’ve requested. We apologize for the inconvenience.";
      
      static const PLUGIN_FAILURE_ERROR:String = "We are unable to initialize the player. We apologize for the inconvenience.";
      
      private static const NETWORK:int = 1;
      
      private static const NOT_FOUND:int = 2;
      
      private static const PLUGIN_FAILURE:int = 3;
      
      private static const GENERIC:int = 4;
       
      
      public function ErrorTranslator()
      {
         super();
      }
      
      public static function translate(param1:Error) : Error
      {
         var _loc5_:MediaError = null;
         var _loc2_:String = UNKNOWN_ERROR;
         var _loc3_:int = 0;
         if(param1 != null)
         {
            _loc5_ = param1 as MediaError;
            if(_loc5_)
            {
               _loc2_ = _loc5_.message;
               if(_loc5_.detail && _loc5_.detail != "")
               {
                  _loc2_ = _loc2_ + ("\n" + _loc5_.detail);
               }
            }
            else
            {
               _loc2_ = param1.message;
            }
            if(_loc5_)
            {
               switch(_loc5_.errorID)
               {
                  case 0:
                  case MediaErrorCodes.ARGUMENT_ERROR:
                  case MediaErrorCodes.SOUND_PLAY_FAILED:
                  case MediaErrorCodes.NETSTREAM_PLAY_FAILED:
                  case MediaErrorCodes.NETSTREAM_NO_SUPPORTED_TRACK_FOUND:
                  case MediaErrorCodes.DRM_SYSTEM_UPDATE_ERROR:
                     _loc3_ = GENERIC;
                     break;
                  case MediaErrorCodes.IO_ERROR:
                  case MediaErrorCodes.SECURITY_ERROR:
                  case MediaErrorCodes.ASYNC_ERROR:
                  case MediaErrorCodes.HTTP_GET_FAILED:
                  case MediaErrorCodes.NETCONNECTION_REJECTED:
                  case MediaErrorCodes.NETCONNECTION_APPLICATION_INVALID:
                  case MediaErrorCodes.NETCONNECTION_TIMEOUT:
                  case MediaErrorCodes.NETCONNECTION_FAILED:
                  case MediaErrorCodes.DVRCAST_SUBSCRIBE_FAILED:
                  case MediaErrorCodes.DVRCAST_STREAM_INFO_RETRIEVAL_FAILED:
                     _loc3_ = NETWORK;
                     break;
                  case MediaErrorCodes.URL_SCHEME_INVALID:
                  case MediaErrorCodes.MEDIA_LOAD_FAILED:
                  case MediaErrorCodes.NETSTREAM_STREAM_NOT_FOUND:
                  case MediaErrorCodes.NETSTREAM_FILE_STRUCTURE_INVALID:
                  case MediaErrorCodes.DVRCAST_CONTENT_OFFLINE:
                  case StrobePlayerErrorCodes.CONFIGURATION_LOAD_ERROR:
                     _loc3_ = NOT_FOUND;
                     break;
                  case MediaErrorCodes.PLUGIN_VERSION_INVALID:
                  case MediaErrorCodes.PLUGIN_IMPLEMENTATION_INVALID:
                     _loc3_ = PLUGIN_FAILURE;
               }
            }
            switch(_loc3_)
            {
               case GENERIC:
                  _loc2_ = GENERIC_ERROR;
                  break;
               case NETWORK:
                  _loc2_ = NETWORK_ERROR;
                  break;
               case NOT_FOUND:
                  _loc2_ = NOT_FOUND_ERROR;
                  break;
               case PLUGIN_FAILURE:
                  _loc2_ = PLUGIN_FAILURE_ERROR;
            }
         }
         var _loc4_:Error = new Error(_loc2_);
         return _loc4_;
      }
   }
}
