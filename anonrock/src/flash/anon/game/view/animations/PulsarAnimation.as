package flash.anon.game.view.animations
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	
	import resources.pulsar.PulsarFrame0;
	import resources.pulsar.PulsarFrame1;
	import resources.pulsar.PulsarFrame2;
	import resources.pulsar.PulsarFrame3;
	import resources.pulsar.PulsarFrame4;
	import resources.pulsar.PulsarFrame5;
	import resources.pulsar.PulsarFrame6;
	import resources.pulsar.PulsarFrame7;
	import resources.pulsar.PulsarFrame8;
	
	public class PulsarAnimation extends BitmapFramesAnimation
	{
		public function PulsarAnimation( container:DisplayObjectContainer )
		{
			super( container );
			addFrame( new Bitmap( new PulsarFrame0(), "auto", true ) );
			addFrame( new Bitmap( new PulsarFrame1(), "auto", true ) );
			addFrame( new Bitmap( new PulsarFrame2(), "auto", true ) );
			addFrame( new Bitmap( new PulsarFrame3(), "auto", true ) );
			addFrame( new Bitmap( new PulsarFrame4(), "auto", true ) );
			addFrame( new Bitmap( new PulsarFrame5(), "auto", true ) );
			addFrame( new Bitmap( new PulsarFrame6(), "auto", true ) );
			addFrame( new Bitmap( new PulsarFrame7(), "auto", true ) );
			addFrame( new Bitmap( new PulsarFrame8(), "auto", true ) );
		}
	}
}