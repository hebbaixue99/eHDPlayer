package org.osmf.net
{
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import org.osmf.net.rtmpstreaming.DroppedFramesRule;
   import org.osmf.net.rtmpstreaming.InsufficientBandwidthRule;
   import org.osmf.net.rtmpstreaming.InsufficientBufferRule;
   import org.osmf.net.rtmpstreaming.RTMPDynamicStreamingNetLoader;
   import org.osmf.net.rtmpstreaming.RTMPNetStreamMetrics;
   import org.osmf.net.rtmpstreaming.SufficientBandwidthRule;
   
   public class RTMPDynamicStreamingNetLoaderAdapter extends RTMPDynamicStreamingNetLoader
   {
       
      
      private var playbackOptimizationManager:PlaybackOptimizationManager;
      
      public function RTMPDynamicStreamingNetLoaderAdapter(param1:PlaybackOptimizationManager)
      {
         this.playbackOptimizationManager = param1;
         super();
      }
      
      override protected function createNetStreamSwitchManager(param1:NetConnection, param2:NetStream, param3:DynamicStreamingResource) : NetStreamSwitchManagerBase
      {
         var _loc4_:RTMPNetStreamMetrics = null;
         var _loc5_:String = null;
         this.playbackOptimizationManager.optimizePlayback(param2,param3);
         if(param3 != null)
         {
            _loc4_ = new RTMPNetStreamMetrics(param2);
            _loc5_ = param3.getMetadataValue("streamType") as String;
            return new StrobeNetStreamSwitchManager(param1,param2,param3,_loc4_,this.getDefaultSwitchingRules(_loc4_,_loc5_));
         }
         return null;
      }
      
      private function getDefaultSwitchingRules(param1:RTMPNetStreamMetrics, param2:String) : Vector.<SwitchingRuleBase>
      {
         var _loc3_:Vector.<SwitchingRuleBase> = new Vector.<SwitchingRuleBase>();
         _loc3_.push(new SufficientBandwidthRule(param1));
         _loc3_.push(new InsufficientBandwidthRule(param1));
         _loc3_.push(new DroppedFramesRule(param1));
         if(param2 != StreamType.LIVE && param2 != StreamType.DVR)
         {
            _loc3_.push(new InsufficientBufferRule(param1));
         }
         return _loc3_;
      }
   }
}
