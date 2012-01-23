package flash.anon.game.view.animations
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	
	import resources.anon.Hands0;
	import resources.anon.Hands1;
	import resources.anon.Hands2;
	import resources.anon.Hands3;
	
	public class AnonPickupAnimation extends BitmapFramesAnimation
	{
		public function AnonPickupAnimation( container:DisplayObjectContainer )
		{
			super( container );
			addFrame( new Bitmap( new Hands0(), "auto", true ) );
			addFrame( new Bitmap( new Hands1(), "auto", true ) );
			addFrame( new Bitmap( new Hands2(), "auto", true ) );
			addFrame( new Bitmap( new Hands3(), "auto", true ) );
			reset();
		}
	}
}