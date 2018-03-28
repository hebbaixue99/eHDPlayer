package org.osmf.layout
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import org.osmf.metadata.MetadataNamespaces;
   import org.osmf.metadata.MetadataWatcher;
   
   public class LayoutRenderer extends LayoutRendererBase
   {
      
      private static const USED_METADATAS:Vector.<String> = new Vector.<String>(5,true);
      
      private static const X:int = 1;
      
      private static const Y:int = 2;
      
      private static const WIDTH:int = 4;
      
      private static const HEIGHT:int = 8;
      
      private static const POSITION:int = X + Y;
      
      private static const DIMENSIONS:int = WIDTH + HEIGHT;
      
      private static const ALL:int = POSITION + DIMENSIONS;
      
      {
         USED_METADATAS[0] = MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS;
         USED_METADATAS[1] = MetadataNamespaces.RELATIVE_LAYOUT_PARAMETERS;
         USED_METADATAS[2] = MetadataNamespaces.ANCHOR_LAYOUT_PARAMETERS;
         USED_METADATAS[3] = MetadataNamespaces.PADDING_LAYOUT_PARAMETERS;
         USED_METADATAS[4] = MetadataNamespaces.LAYOUT_ATTRIBUTES;
      }
      
      private var layoutMode:String = "none";
      
      private var lastCalculatedBounds:Rectangle;
      
      private var targetMetadataWatchers:Dictionary;
      
      private var containerAbsoluteWatcher:MetadataWatcher;
      
      private var containerAttributesWatcher:MetadataWatcher;
      
      public function LayoutRenderer()
      {
         this.targetMetadataWatchers = new Dictionary();
         super();
      }
      
      override protected function get usedMetadatas() : Vector.<String>
      {
         return USED_METADATAS;
      }
      
      override protected function processContainerChange(param1:ILayoutTarget, param2:ILayoutTarget) : void
      {
         var oldContainer:ILayoutTarget = param1;
         var newContainer:ILayoutTarget = param2;
         if(oldContainer)
         {
            this.containerAbsoluteWatcher.unwatch();
            this.containerAttributesWatcher.unwatch();
         }
         if(newContainer)
         {
            this.containerAbsoluteWatcher = new MetadataWatcher(newContainer.layoutMetadata,MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS,null,function(... rest):void
            {
               invalidate();
            });
            this.containerAbsoluteWatcher.watch();
            this.containerAttributesWatcher = new MetadataWatcher(newContainer.layoutMetadata,MetadataNamespaces.LAYOUT_ATTRIBUTES,null,function(param1:LayoutAttributesMetadata):void
            {
               layoutMode = !!param1?param1.layoutMode:LayoutMode.NONE;
               invalidate();
            });
            this.containerAttributesWatcher.watch();
         }
         invalidate();
      }
      
      override protected function processUpdateMediaDisplayBegin(param1:Vector.<ILayoutTarget>) : void
      {
         this.lastCalculatedBounds = null;
      }
      
      override protected function processUpdateMediaDisplayEnd() : void
      {
         this.lastCalculatedBounds = null;
      }
      
      override protected function processTargetAdded(param1:ILayoutTarget) : void
      {
         var target:ILayoutTarget = param1;
         var attributes:LayoutAttributesMetadata = target.layoutMetadata.getValue(MetadataNamespaces.LAYOUT_ATTRIBUTES) as LayoutAttributesMetadata;
         var relative:RelativeLayoutMetadata = target.layoutMetadata.getValue(MetadataNamespaces.RELATIVE_LAYOUT_PARAMETERS) as RelativeLayoutMetadata;
         if(this.layoutMode == LayoutMode.NONE && relative == null && attributes == null && target.layoutMetadata.getValue(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS) == null && target.layoutMetadata.getValue(MetadataNamespaces.ANCHOR_LAYOUT_PARAMETERS) == null)
         {
            relative = new RelativeLayoutMetadata();
            relative.width = 100;
            relative.height = 100;
            target.layoutMetadata.addValue(MetadataNamespaces.RELATIVE_LAYOUT_PARAMETERS,relative);
            attributes = new LayoutAttributesMetadata();
            attributes.scaleMode = attributes.scaleMode || ScaleMode.LETTERBOX;
            attributes.verticalAlign = attributes.verticalAlign || VerticalAlign.MIDDLE;
            attributes.horizontalAlign = attributes.horizontalAlign || HorizontalAlign.CENTER;
            target.layoutMetadata.addValue(MetadataNamespaces.LAYOUT_ATTRIBUTES,attributes);
         }
         var watcher:MetadataWatcher = new MetadataWatcher(target.layoutMetadata,MetadataNamespaces.LAYOUT_ATTRIBUTES,LayoutAttributesMetadata.INDEX,function(... rest):void
         {
            updateTargetOrder(target);
         });
         watcher.watch();
         this.targetMetadataWatchers[target] = watcher;
      }
      
      override protected function processTargetRemoved(param1:ILayoutTarget) : void
      {
         var _loc2_:MetadataWatcher = this.targetMetadataWatchers[param1];
         delete this.targetMetadataWatchers[param1];
         _loc2_.unwatch();
         _loc2_ = null;
      }
      
      override protected function compareTargets(param1:ILayoutTarget, param2:ILayoutTarget) : Number
      {
         var _loc3_:LayoutAttributesMetadata = param1.layoutMetadata.getValue(MetadataNamespaces.LAYOUT_ATTRIBUTES) as LayoutAttributesMetadata;
         var _loc4_:LayoutAttributesMetadata = param2.layoutMetadata.getValue(MetadataNamespaces.LAYOUT_ATTRIBUTES) as LayoutAttributesMetadata;
         var _loc5_:Number = !!_loc3_?Number(_loc3_.index):Number(NaN);
         var _loc6_:Number = !!_loc4_?Number(_loc4_.index):Number(NaN);
         if(isNaN(_loc5_) && isNaN(_loc6_))
         {
            return 1;
         }
         _loc5_ = Number(_loc5_) || Number(0);
         _loc6_ = Number(_loc6_) || Number(0);
         return _loc5_ < _loc6_?Number(-1):_loc5_ > _loc6_?Number(1):Number(0);
      }
      
      override protected function calculateTargetBounds(param1:ILayoutTarget, param2:Number, param3:Number) : Rectangle
      {
         var _loc7_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc13_:BoxAttributesMetadata = null;
         var _loc14_:RelativeLayoutMetadata = null;
         var _loc15_:AnchorLayoutMetadata = null;
         var _loc16_:Point = null;
         var _loc4_:LayoutAttributesMetadata = param1.layoutMetadata.getValue(MetadataNamespaces.LAYOUT_ATTRIBUTES) as LayoutAttributesMetadata || new LayoutAttributesMetadata();
         if(_loc4_.includeInLayout == false)
         {
            return new Rectangle();
         }
         var _loc5_:Rectangle = new Rectangle(0,0,param1.measuredWidth,param1.measuredHeight);
         var _loc6_:AbsoluteLayoutMetadata = param1.layoutMetadata.getValue(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS) as AbsoluteLayoutMetadata;
         var _loc8_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:* = int(ALL);
         if(_loc6_)
         {
            if(!isNaN(_loc6_.x))
            {
               _loc5_.x = _loc6_.x;
               _loc11_ = _loc11_ ^ X;
            }
            if(!isNaN(_loc6_.y))
            {
               _loc5_.y = _loc6_.y;
               _loc11_ = _loc11_ ^ Y;
            }
            if(!isNaN(_loc6_.width))
            {
               _loc5_.width = _loc6_.width;
               _loc11_ = _loc11_ ^ WIDTH;
            }
            if(!isNaN(_loc6_.height))
            {
               _loc5_.height = _loc6_.height;
               _loc11_ = _loc11_ ^ HEIGHT;
            }
         }
         if(_loc11_ != 0)
         {
            _loc14_ = param1.layoutMetadata.getValue(MetadataNamespaces.RELATIVE_LAYOUT_PARAMETERS) as RelativeLayoutMetadata;
            if(_loc14_)
            {
               if(_loc11_ & X && !isNaN(_loc14_.x))
               {
                  _loc5_.x = Number(param2 * _loc14_.x / 100) || Number(0);
                  _loc11_ = _loc11_ ^ X;
               }
               if(_loc11_ & WIDTH && !isNaN(_loc14_.width))
               {
                  if(this.layoutMode == LayoutMode.HORIZONTAL)
                  {
                     _loc13_ = container.layoutMetadata.getValue(MetadataNamespaces.BOX_LAYOUT_ATTRIBUTES) as BoxAttributesMetadata || new BoxAttributesMetadata();
                     _loc5_.width = Math.max(0,param2 - _loc13_.absoluteSum) * _loc14_.width / _loc13_.relativeSum;
                  }
                  else
                  {
                     _loc5_.width = param2 * _loc14_.width / 100;
                  }
                  _loc11_ = _loc11_ ^ WIDTH;
               }
               if(_loc11_ & Y && !isNaN(_loc14_.y))
               {
                  _loc5_.y = Number(param3 * _loc14_.y / 100) || Number(0);
                  _loc11_ = _loc11_ ^ Y;
               }
               if(_loc11_ & HEIGHT && !isNaN(_loc14_.height))
               {
                  if(this.layoutMode == LayoutMode.VERTICAL)
                  {
                     _loc13_ = container.layoutMetadata.getValue(MetadataNamespaces.BOX_LAYOUT_ATTRIBUTES) as BoxAttributesMetadata || new BoxAttributesMetadata();
                     _loc5_.height = Math.max(0,param3 - _loc13_.absoluteSum) * _loc14_.height / _loc13_.relativeSum;
                  }
                  else
                  {
                     _loc5_.height = param3 * _loc14_.height / 100;
                  }
                  _loc11_ = _loc11_ ^ HEIGHT;
               }
            }
         }
         if(_loc11_ != 0)
         {
            _loc15_ = param1.layoutMetadata.getValue(MetadataNamespaces.ANCHOR_LAYOUT_PARAMETERS) as AnchorLayoutMetadata;
            if(_loc15_)
            {
               if(_loc11_ & X && !isNaN(_loc15_.left))
               {
                  _loc5_.x = _loc15_.left;
                  _loc11_ = _loc11_ ^ X;
               }
               if(_loc11_ & Y && !isNaN(_loc15_.top))
               {
                  _loc5_.y = _loc15_.top;
                  _loc11_ = _loc11_ ^ Y;
               }
               if(!isNaN(_loc15_.right) && param2)
               {
                  if(_loc11_ & X && !(_loc11_ & WIDTH))
                  {
                     _loc5_.x = Math.max(0,param2 - _loc5_.width - _loc15_.right);
                     _loc11_ = _loc11_ ^ X;
                  }
                  else if(_loc11_ & WIDTH && !(_loc11_ & X))
                  {
                     _loc5_.width = Math.max(0,param2 - _loc15_.right - _loc5_.x);
                     _loc11_ = _loc11_ ^ WIDTH;
                  }
                  else
                  {
                     _loc5_.x = Math.max(0,param2 - param1.measuredWidth - _loc15_.right);
                     _loc11_ = _loc11_ ^ X;
                  }
                  _loc8_ = _loc8_ + _loc15_.right;
               }
               if(!isNaN(_loc15_.bottom) && param3)
               {
                  if(_loc11_ & Y && !(_loc11_ & HEIGHT))
                  {
                     _loc5_.y = Math.max(0,param3 - _loc5_.height - _loc15_.bottom);
                     _loc11_ = _loc11_ ^ Y;
                  }
                  else if(_loc11_ & HEIGHT && !(_loc11_ & Y))
                  {
                     _loc5_.height = Math.max(0,param3 - _loc15_.bottom - _loc5_.y);
                     _loc11_ = _loc11_ ^ HEIGHT;
                  }
                  else
                  {
                     _loc5_.y = Math.max(0,param3 - param1.measuredHeight - _loc15_.bottom);
                     _loc11_ = _loc11_ ^ Y;
                  }
                  _loc10_ = _loc10_ + _loc15_.bottom;
               }
            }
         }
         var _loc12_:PaddingLayoutMetadata = param1.layoutMetadata.getValue(MetadataNamespaces.PADDING_LAYOUT_PARAMETERS) as PaddingLayoutMetadata;
         if(_loc12_)
         {
            if(!isNaN(_loc12_.left))
            {
               _loc5_.x = _loc5_.x + _loc12_.left;
            }
            if(!isNaN(_loc12_.top))
            {
               _loc5_.y = _loc5_.y + _loc12_.top;
            }
            if(!isNaN(_loc12_.right) && !(_loc11_ & WIDTH))
            {
               _loc5_.width = _loc5_.width - (_loc12_.right + (_loc12_.left || 0));
            }
            if(!isNaN(_loc12_.bottom) && !(_loc11_ & HEIGHT))
            {
               _loc5_.height = _loc5_.height - (_loc12_.bottom + (_loc12_.top || 0));
            }
         }
         if(_loc4_.scaleMode)
         {
            if(!(_loc11_ & WIDTH || _loc11_ & HEIGHT) && param1.measuredWidth && param1.measuredHeight)
            {
               _loc16_ = ScaleModeUtils.getScaledSize(_loc4_.scaleMode,_loc5_.width,_loc5_.height,param1.measuredWidth,param1.measuredHeight);
               _loc7_ = _loc5_.width - _loc16_.x;
               _loc9_ = _loc5_.height - _loc16_.y;
               _loc5_.width = _loc16_.x;
               _loc5_.height = _loc16_.y;
            }
         }
         if(this.layoutMode != LayoutMode.HORIZONTAL)
         {
            _loc7_ = Number(_loc7_) || Number(param2 - (_loc5_.x || 0) - (_loc5_.width || 0) - _loc8_);
         }
         if(this.layoutMode != LayoutMode.VERTICAL)
         {
            _loc9_ = Number(_loc9_) || Number(param3 - (_loc5_.y || 0) - (_loc5_.height || 0) - _loc10_);
         }
         if(_loc9_)
         {
            switch(_loc4_.verticalAlign)
            {
               case null:
               case VerticalAlign.TOP:
                  break;
               case VerticalAlign.MIDDLE:
                  _loc5_.y = _loc5_.y + _loc9_ / 2;
                  break;
               case VerticalAlign.BOTTOM:
                  _loc5_.y = _loc5_.y + _loc9_;
            }
         }
         if(_loc7_)
         {
            switch(_loc4_.horizontalAlign)
            {
               case null:
               case HorizontalAlign.LEFT:
                  break;
               case HorizontalAlign.CENTER:
                  _loc5_.x = _loc5_.x + _loc7_ / 2;
                  break;
               case HorizontalAlign.RIGHT:
                  _loc5_.x = _loc5_.x + _loc7_;
            }
         }
         if(_loc4_.snapToPixel)
         {
            _loc5_.x = Math.round(_loc5_.x);
            _loc5_.y = Math.round(_loc5_.y);
            _loc5_.width = Math.round(_loc5_.width);
            _loc5_.height = Math.round(_loc5_.height);
         }
         if(this.layoutMode == LayoutMode.HORIZONTAL || this.layoutMode == LayoutMode.VERTICAL)
         {
            if(this.lastCalculatedBounds != null)
            {
               if(this.layoutMode == LayoutMode.HORIZONTAL)
               {
                  _loc5_.x = this.lastCalculatedBounds.x + this.lastCalculatedBounds.width;
               }
               else
               {
                  _loc5_.y = this.lastCalculatedBounds.y + this.lastCalculatedBounds.height;
               }
            }
            this.lastCalculatedBounds = _loc5_;
         }
         return _loc5_;
      }
      
      override protected function calculateContainerSize(param1:Vector.<ILayoutTarget>) : Point
      {
         var _loc4_:BoxAttributesMetadata = null;
         var _loc5_:Rectangle = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Rectangle = null;
         var _loc8_:ILayoutTarget = null;
         var _loc2_:Point = new Point(NaN,NaN);
         var _loc3_:AbsoluteLayoutMetadata = container.layoutMetadata.getValue(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS) as AbsoluteLayoutMetadata;
         if(_loc3_)
         {
            _loc2_.x = _loc3_.width;
            _loc2_.y = _loc3_.height;
         }
         if(this.layoutMode != LayoutMode.NONE)
         {
            _loc4_ = new BoxAttributesMetadata();
            container.layoutMetadata.addValue(MetadataNamespaces.BOX_LAYOUT_ATTRIBUTES,_loc4_);
         }
         if(isNaN(_loc2_.x) || isNaN(_loc2_.y) || this.layoutMode != LayoutMode.NONE)
         {
            _loc5_ = new Rectangle();
            for each(_loc8_ in param1)
            {
               if(_loc8_.layoutMetadata.includeInLayout)
               {
                  _loc6_ = this.calculateTargetBounds(_loc8_,_loc2_.x,_loc2_.y);
                  _loc6_.x = Number(_loc6_.x) || Number(0);
                  _loc6_.y = Number(_loc6_.y) || Number(0);
                  _loc6_.width = Number(_loc6_.width) || (Number(_loc8_.measuredWidth) || Number(0));
                  _loc6_.height = Number(_loc6_.height) || (Number(_loc8_.measuredHeight) || Number(0));
                  if(this.layoutMode == LayoutMode.HORIZONTAL)
                  {
                     if(!isNaN(_loc8_.layoutMetadata.percentWidth))
                     {
                        _loc4_.relativeSum = _loc4_.relativeSum + _loc8_.layoutMetadata.percentWidth;
                     }
                     else
                     {
                        _loc4_.absoluteSum = _loc4_.absoluteSum + _loc6_.width;
                     }
                     if(_loc7_)
                     {
                        _loc6_.x = _loc7_.x + _loc7_.width;
                     }
                     _loc7_ = _loc6_;
                  }
                  else if(this.layoutMode == LayoutMode.VERTICAL)
                  {
                     if(!isNaN(_loc8_.layoutMetadata.percentHeight))
                     {
                        _loc4_.relativeSum = _loc4_.relativeSum + _loc8_.layoutMetadata.percentHeight;
                     }
                     else
                     {
                        _loc4_.absoluteSum = _loc4_.absoluteSum + _loc6_.height;
                     }
                     if(_loc7_)
                     {
                        _loc6_.y = _loc7_.y + _loc7_.height;
                     }
                     _loc7_ = _loc6_;
                  }
                  _loc5_ = _loc5_.union(_loc6_);
               }
            }
            _loc2_.x = Number(_loc2_.x) || (_loc3_ == null || isNaN(_loc3_.width)?Number(_loc5_.width):Number(_loc3_.width));
            _loc2_.y = Number(_loc2_.y) || (_loc3_ == null || isNaN(_loc3_.height)?Number(_loc5_.height):Number(_loc3_.height));
         }
         return _loc2_;
      }
   }
}
