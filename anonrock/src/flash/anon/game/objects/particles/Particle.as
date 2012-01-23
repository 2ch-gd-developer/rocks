package flash.anon.game.objects.particles
{
	import flash.anon.game.objects.prototypes.PlanetObject;
	import flash.anon.game.objects.prototypes.PlanetPhysicalObject;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Particle extends PlanetPhysicalObject
	{
		protected var _bitmap:DisplayObject;
		
		protected var _timeToLive:int = 1000;
		private var _timeLeft:int = 0;
		
		public function Particle( planetLength:int, planetGravity:Number )
		{
			super( planetLength, planetGravity );
		}
		
		protected function createBitmap():void
		{
			_bitmap = new Sprite();
		}
		
		public function init( size:Number, angle:Number, speed:Number ):void
		{
			createBitmap();
			_bitmap.scaleX = _bitmap.scaleY = size;
			_bitmap.x = -_bitmap.width/2;
			_bitmap.y = -_bitmap.height;
			addChild( _bitmap );
			_timeToLive = 1000+Math.random()*500;
			_timeLeft = _timeToLive;
			_speedX = Math.cos( angle )*speed;
			_speedY = Math.sin( angle )*speed;
			_isFreeFalling = true;
		}
		
		override public function fall( timeElapsed:Number ):void
		{
			super.fall( timeElapsed );
			alpha = 0.5 + 0.5 * _timeLeft/_timeToLive;
			_timeLeft -= timeElapsed;
			if( _timeLeft < 0 )
			{
				dispatchEvent( new Event(PlanetObject.DISAPPEAR) );
			}
		}
	}
}