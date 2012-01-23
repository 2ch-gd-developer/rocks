package flash.anon.game.objects.particles
{
	import flash.display.Shape;

	public class BloodParticle extends Particle
	{
		public function BloodParticle( planetLength:int, planetGravity:Number )
		{
			super( planetLength, planetGravity );
		}
		
		override protected function createBitmap():void
		{
			var blood:Shape = new Shape();
			blood.graphics.clear();
			blood.graphics.beginFill( 0x124000 );
			blood.graphics.drawCircle( 0, 0, 1 );
			blood.graphics.endFill();
			_bitmap = blood;
		}
	}
}