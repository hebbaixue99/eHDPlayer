package
{
   import flash.display.MovieClip;
   
   public class MaskedMovieClip extends MovieClip
   {
          
      
      //public var maskMovieClip:MovieClip;
      
      public function MaskedMovieClip()
      {
         super();
      }
      
	  override public function get width() : Number
      {
         return  600 ;// super.height;//maskMovieClip.width;
      }
      
	  override public function get height() : Number
      {
         return 400 ;//super.height;
      }
   }
}
