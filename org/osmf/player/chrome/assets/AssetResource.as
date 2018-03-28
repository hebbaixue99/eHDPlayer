package org.osmf.player.chrome.assets
{
   public class AssetResource
   {
       
      
      private var _id:String;
      
      private var _url:String;
      
      private var _local:Boolean;
      
      public function AssetResource(param1:String, param2:String, param3:Boolean)
      {
         super();
         this._id = param1;
         this._url = param2;
         this._local = param3;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get local() : Boolean
      {
         return this._local;
      }
   }
}
