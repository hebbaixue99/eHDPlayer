package org.osmf.net
{
   import flash.events.NetStatusEvent;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import org.osmf.net.httpstreaming.DownloadRatioRule;
   import org.osmf.net.httpstreaming.HTTPNetStream;
   import org.osmf.net.httpstreaming.HTTPNetStreamMetrics;
   import org.osmf.net.httpstreaming.HTTPStreamingNetLoader;
   import org.osmf.net.rtmpstreaming.DroppedFramesRule;
   
   public class HTTPStreamingNetLoaderAdapter extends HTTPStreamingNetLoader
   {
       
      
      private var playbackOptimizationManager:PlaybackOptimizationManager;
      
      public function HTTPStreamingNetLoaderAdapter(param1:PlaybackOptimizationManager)
      {
         this.playbackOptimizationManager = param1;
         super();
      }
      
      override protected function processFinishLoading(param1:NetStreamLoadTrait) : void
      {
         super.processFinishLoading(param1);
      }
      
      override protected function createNetStreamSwitchManager(param1:NetConnection, param2:NetStream, param3:DynamicStreamingResource) : NetStreamSwitchManagerBase
      {
         var _loc4_:HTTPNetStreamMetrics = null;
         this.playbackOptimizationManager.optimizePlayback(param2,param3);
         param2.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
         if(param3 != null)
         {
            _loc4_ = new HTTPNetStreamMetrics(param2 as HTTPNetStream);
            return new StrobeNetStreamSwitchManager(param1,param2,param3,_loc4_,this.getDefaultSwitchingRules(_loc4_));
         }
         return null;
      }
      
      private function onNetStatus(param1:NetStatusEvent) : void
      {
         var _loc2_:NetStream = param1.currentTarget as NetStream;
         if(param1.info.code == NetStreamCodes.NETSTREAM_BUFFER_EMPTY)
         {
            if(_loc2_.bufferTime >= 2)
            {
               _loc2_.bufferTime = _loc2_.bufferTime + 1;
            }
            else
            {
               _loc2_.bufferTime = 2;
            }
         }
      }
      
      private function getDefaultSwitchingRules(param1:HTTPNetStreamMetrics) : Vector.<SwitchingRuleBase>
      {
         var _loc2_:Vector.<SwitchingRuleBase> = new Vector.<SwitchingRuleBase>();
         _loc2_.push(new DownloadRatioRule(param1));
         _loc2_.push(new DroppedFramesRule(param1));
         return _loc2_;
      }
   }
}
