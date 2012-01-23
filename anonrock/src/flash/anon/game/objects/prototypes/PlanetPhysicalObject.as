package flash.anon.game.objects.prototypes
{
	import flash.events.Event;

	public class PlanetPhysicalObject extends PlanetObject
	{
		protected var _speedX:Number = 0;
		protected var _speedY:Number = 0;
		protected var _planetGravity:Number;
		
		protected var _isFreeFalling:Boolean = false;
		
		public function PlanetPhysicalObject( planetLength:int, planetGravity:Number )
		{
			super( planetLength );
			_planetGravity = planetGravity;
		}
		
		public function fall( timeElapsed:Number ):void
		{
			if( _isFreeFalling )
			{
				planetX += _speedX * timeElapsed;
				planetY += _speedY * timeElapsed;
				_speedY -= _planetGravity * timeElapsed;
			}
		}
		
		public function get isFreeFalling():Boolean
		{
			return _isFreeFalling;
		}
		
		public function startFall():void
		{
			_speedX = _speedY = 0;
			_isFreeFalling = true;
		}
		
		public function ricochet():void
		{
			_speedX = -0.5*_speedX;
		}
		
		public function fixOnGround():void
		{
			_isFreeFalling = false;
		}
		
		public function get speedX():Number
		{
			return _speedX;
		}
		public function get speedY():Number
		{
			return _speedY;
		}
	}
}