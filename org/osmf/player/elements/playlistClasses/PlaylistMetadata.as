package org.osmf.player.elements.playlistClasses
{
   import flash.errors.IllegalOperationError;
   import org.osmf.media.MediaElement;
   import org.osmf.metadata.Metadata;
   
   public class PlaylistMetadata extends Metadata
   {
      
      public static const NAMESPACE:String = "http://www.osmf.org.player/1.0/playlist";
      
      public static const NEXT_ELEMENT:String = "nextElement";
      
      public static const PREVIOUS_ELEMENT:String = "previousElement";
      
      public static const GOTO_NEXT:String = "gotoNext";
      
      public static const GOTO_PREVIOUS:String = "gotoPrevious";
      
      public static const SWITCHING:String = "switching";
       
      
      private var elements:Vector.<MediaElement>;
      
      private var _currentElement:MediaElement;
      
      public function PlaylistMetadata()
      {
         super();
         this.elements = new Vector.<MediaElement>();
         addValue(GOTO_NEXT,null);
         addValue(GOTO_PREVIOUS,null);
         addValue(SWITCHING,false);
      }
      
      public function set currentElement(param1:MediaElement) : void
      {
         if(param1 != this._currentElement)
         {
            this._currentElement = param1;
            this.updatePreviousAndNextValues();
         }
      }
      
      public function get switching() : Boolean
      {
         return getValue(SWITCHING);
      }
      
      public function set switching(param1:Boolean) : void
      {
         addValue(SWITCHING,param1);
      }
      
      public function get currentElement() : MediaElement
      {
         return this._currentElement;
      }
      
      public function get previousElement() : MediaElement
      {
         return getValue(PREVIOUS_ELEMENT);
      }
      
      public function get nextElement() : MediaElement
      {
         return getValue(NEXT_ELEMENT);
      }
      
      public function addElement(param1:MediaElement) : void
      {
         this.elements.push(param1);
      }
      
      public function updateElementAt(param1:Number, param2:MediaElement) : void
      {
         this.elements[param1] = param2;
         this.updatePreviousAndNextValues();
      }
      
      public function get numElements() : Number
      {
         return this.elements.length;
      }
      
      public function elementAt(param1:Number) : MediaElement
      {
         if(param1 >= 0 && this.elements.length > param1)
         {
            return this.elements[param1];
         }
         throw new IllegalOperationError();
      }
      
      public function indexOf(param1:MediaElement) : Number
      {
         return this.elements.indexOf(param1);
      }
      
      private function updatePreviousAndNextValues() : void
      {
         var _loc1_:MediaElement = null;
         var _loc2_:MediaElement = null;
         var _loc3_:Number = this.elements.indexOf(this._currentElement);
         if(_loc3_ != -1 && this.elements.length > 1)
         {
            _loc2_ = _loc3_ + 1 < this.elements.length?this.elements[_loc3_ + 1]:null;
            _loc1_ = _loc3_ - 1 >= 0?this.elements[_loc3_ - 1]:null;
         }
         if(_loc1_ != this.previousElement)
         {
            addValue(PREVIOUS_ELEMENT,_loc1_);
         }
         if(_loc2_ != this.nextElement)
         {
            addValue(NEXT_ELEMENT,_loc2_);
         }
      }
   }
}
