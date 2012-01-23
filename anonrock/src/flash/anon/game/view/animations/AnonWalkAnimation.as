package flash.anon.game.view.animations
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	
	import resources.anon.Walk0;
	import resources.anon.Walk1;
	import resources.anon.Walk2;
	import resources.anon.Walk3;
	
	public class AnonWalkAnimation extends BitmapFramesAnimation
	{
		public function AnonWalkAnimation( container:DisplayObjectContainer )
		{
			super( container );
			addFrame( new Bitmap( new Walk0(), "auto", true ) );
			addFrame( new Bitmap( new Walk1(), "auto", true ) );
			addFrame( new Bitmap( new Walk2(), "auto", true ) );
			addFrame( new Bitmap( new Walk3(), "auto", true ) );
			reset();
		}
	}
}