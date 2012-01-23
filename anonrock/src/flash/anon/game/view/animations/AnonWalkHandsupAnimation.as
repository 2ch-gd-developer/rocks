package flash.anon.game.view.animations
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	
	import resources.anon.WalkHands0;
	import resources.anon.WalkHands1;
	import resources.anon.WalkHands2;
	import resources.anon.WalkHands3;
	
	public class AnonWalkHandsupAnimation extends BitmapFramesAnimation
	{
		public function AnonWalkHandsupAnimation( container:DisplayObjectContainer )
		{
			super( container );
			addFrame( new Bitmap( new WalkHands0(), "auto", true ) );
			addFrame( new Bitmap( new WalkHands1(), "auto", true ) );
			addFrame( new Bitmap( new WalkHands2(), "auto", true ) );
			addFrame( new Bitmap( new WalkHands3(), "auto", true ) );
			reset();
		}
	}
}