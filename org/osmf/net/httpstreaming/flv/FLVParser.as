package org.osmf.net.httpstreaming.flv
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class FLVParser
   {
       
      
      private var state:String;
      
      private var savedBytes:ByteArray;
      
      private var currentTag:FLVTag = null;
      
      private var flvHeader:FLVHeader;
      
      public function FLVParser(param1:Boolean)
      {
         super();
         this.savedBytes = new ByteArray();
         if(param1)
         {
            this.state = FLVParserState.FILE_HEADER;
         }
         else
         {
            this.state = FLVParserState.TYPE;
         }
      }
      
      public function flush(param1:IDataOutput) : void
      {
         param1.writeBytes(this.savedBytes);
      }
      
      public function parse(param1:IDataInput, param2:Boolean, param3:Function) : void
      {
         var _loc5_:IDataInput = null;
         var _loc6_:int = 0;
         var _loc4_:Boolean = true;
         loop0:
         while(true)
         {
            if(!_loc4_)
            {
               if(param2)
               {
                  param1.readBytes(this.savedBytes,this.savedBytes.length);
               }
               return;
            }
            switch(this.state)
            {
               case FLVParserState.FILE_HEADER:
                  _loc5_ = this.byteSource(param1,FLVHeader.MIN_FILE_HEADER_BYTE_COUNT);
                  if(_loc5_ != null)
                  {
                     this.flvHeader = new FLVHeader();
                     this.flvHeader.readHeader(_loc5_);
                     this.state = FLVParserState.FILE_HEADER_REST;
                  }
                  else
                  {
                     _loc4_ = false;
                  }
                  continue;
               case FLVParserState.FILE_HEADER_REST:
                  _loc5_ = this.byteSource(param1,this.flvHeader.restBytesNeeded);
                  if(_loc5_ != null)
                  {
                     this.flvHeader.readRest(_loc5_);
                     this.state = FLVParserState.TYPE;
                  }
                  else
                  {
                     _loc4_ = false;
                  }
                  continue;
               case FLVParserState.TYPE:
                  _loc5_ = this.byteSource(param1,1);
                  if(_loc5_ != null)
                  {
                     _loc6_ = _loc5_.readByte();
                     switch(_loc6_)
                     {
                        case FLVTag.TAG_TYPE_AUDIO:
                        case FLVTag.TAG_TYPE_ENCRYPTED_AUDIO:
                           this.currentTag = new FLVTagAudio(_loc6_);
                           break;
                        case FLVTag.TAG_TYPE_VIDEO:
                        case FLVTag.TAG_TYPE_ENCRYPTED_VIDEO:
                           this.currentTag = new FLVTagVideo(_loc6_);
                           break;
                        case FLVTag.TAG_TYPE_SCRIPTDATAOBJECT:
                        case FLVTag.TAG_TYPE_ENCRYPTED_SCRIPTDATAOBJECT:
                           this.currentTag = new FLVTagScriptDataObject(_loc6_);
                           break;
                        default:
                           this.currentTag = new FLVTag(_loc6_);
                     }
                     this.state = FLVParserState.HEADER;
                  }
                  else
                  {
                     _loc4_ = false;
                  }
                  continue;
               case FLVParserState.HEADER:
                  _loc5_ = this.byteSource(param1,FLVTag.TAG_HEADER_BYTE_COUNT - 1);
                  if(_loc5_ != null)
                  {
                     this.currentTag.readRemainingHeader(_loc5_);
                     if(this.currentTag.dataSize)
                     {
                        this.state = FLVParserState.DATA;
                     }
                     else
                     {
                        this.state = FLVParserState.PREV_TAG;
                     }
                  }
                  else
                  {
                     _loc4_ = false;
                  }
                  continue;
               case FLVParserState.DATA:
                  _loc5_ = this.byteSource(param1,this.currentTag.dataSize);
                  if(_loc5_ != null)
                  {
                     this.currentTag.readData(_loc5_);
                     this.state = FLVParserState.PREV_TAG;
                  }
                  else
                  {
                     _loc4_ = false;
                  }
                  continue;
               case FLVParserState.PREV_TAG:
                  _loc5_ = this.byteSource(param1,FLVTag.PREV_TAG_BYTE_COUNT);
                  if(_loc5_ != null)
                  {
                     this.currentTag.readPrevTag(_loc5_);
                     this.state = FLVParserState.TYPE;
                     _loc4_ = param3(this.currentTag);
                  }
                  else
                  {
                     _loc4_ = false;
                  }
                  continue;
               default:
                  break loop0;
            }
         }
         throw new Error("FLVParser state machine in unknown state");
      }
      
      private function byteSource(param1:IDataInput, param2:int) : IDataInput
      {
         var _loc3_:int = 0;
         if(this.savedBytes.bytesAvailable + param1.bytesAvailable < param2)
         {
            return null;
         }
         if(this.savedBytes.bytesAvailable)
         {
            _loc3_ = param2 - this.savedBytes.bytesAvailable;
            if(_loc3_ > 0)
            {
               param1.readBytes(this.savedBytes,this.savedBytes.length,_loc3_);
            }
            return this.savedBytes;
         }
         this.savedBytes.length = 0;
         return param1;
      }
   }
}
