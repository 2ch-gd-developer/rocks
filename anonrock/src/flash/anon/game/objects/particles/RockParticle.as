package flash.anon.game.objects.particles
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import resources.RockBitmap;
	
	public class RockParticle extends Particle
	{
		public function RockParticle( planetLength:int, planetGravity:Number )
		{
			super( planetLength, planetGravity );
		}
		
		override protected function createBitmap():void
		{
			_bitmap = new Bitmap( new RockBitmap(), "auto", true );
		}
	}
}