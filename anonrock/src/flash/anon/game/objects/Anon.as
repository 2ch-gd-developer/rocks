package flash.anon.game.objects
{
	import flash.anon.game.objects.prototypes.PlanetPhysicalObject;
	import flash.anon.game.view.animations.AnonPickupAnimation;
	import flash.anon.game.view.animations.AnonWalkAnimation;
	import flash.anon.game.view.animations.AnonWalkHandsupAnimation;
	import flash.anon.game.view.animations.BitmapFramesAnimation;
	import flash.display.Sprite;
	
	public class Anon extends PlanetPhysicalObject
	{
		private var _isAlive:Boolean = true;
		
		private var _bitmapsContainer:Sprite;
		private var _walkAnimation:BitmapFramesAnimation;
		private var _walkHandsupAnimation:BitmapFramesAnimation;
		private var _curWalkAnimation:BitmapFramesAnimation;
		private var _pickupAnimation:BitmapFramesAnimation;

		private var _stepPeriod:Number = 650;
		private var _stepAmplitude:Number = 21;
		private var _pickupTime:Number = 1000;
		private var _burden:Number = 0;

		private var _direction:int = 0;
		private var _pickingUp:Boolean = false;
		private var _putingDown:Boolean = false;

		public function Anon( stepTime:int, planetLength:int, planetGravity:Number )
		{
			super( planetLength, planetGravity );
			_stepPeriod = stepTime;
		}

		public function init():void
		{
			_bitmapsContainer = new Sprite();
			addChild( _bitmapsContainer );

			_pickupAnimation = new AnonPickupAnimation( _bitmapsContainer );
			_pickupAnimation.period = _pickupTime;
			_pickupAnimation.visible = false;
			
			_walkHandsupAnimation = new AnonWalkHandsupAnimation( _bitmapsContainer );
			_walkHandsupAnimation.period = _stepPeriod;
			_walkHandsupAnimation.visible = false;
			
			_walkAnimation = new AnonWalkAnimation( _bitmapsContainer );
			_walkAnimation.period = _stepPeriod;
			_walkAnimation.visible = true;
			_curWalkAnimation = _walkAnimation;
			direction = 1;
			
			calculateLeftAndRight();
			_bitmapsContainer.y = -_bitmapsContainer.height;
			if( groundShadow != null )
				drawGroundShadow();
		}
		
		override public function get objectWidth():Number
		{
			return width*0.5;
		}
		
		public function set isAlive( value:Boolean ):void
		{
			_isAlive = value;
		}
		public function get isAlive():Boolean
		{
			return _isAlive;
		}

		public function walkDeltaX( timeElapsed:Number ):Number
		{
			return _stepAmplitude*timeElapsed*_direction/_stepPeriod;
		}
		public function walk( timeElapsed:Number ):void
		{
			_curWalkAnimation.play( timeElapsed );
			planetX += walkDeltaX( timeElapsed );
		}
		public function stop():void
		{
			_curWalkAnimation.reset();
		}
		
		public function set direction( value:int ):void
		{
			if( _direction == value )
				return;
			_curWalkAnimation.reset();
			_direction = value;
			_bitmapsContainer.scaleX = _direction;
			if( _direction > 0 )
				_bitmapsContainer.x = -width/2;
			else
				_bitmapsContainer.x = width/2;
		}
		public function get direction():int
		{
			return _direction;
		}
		
		public function set burden( value:Number ):void
		{
			_burden = value;
			_curWalkAnimation.period = _stepPeriod*( 1+2*_burden );
		}
		
		private function switchToWalkAnimation():void
		{
			_walkAnimation.visible = true;
			_walkAnimation.reset();
			_walkHandsupAnimation.visible = false;
			_curWalkAnimation = _walkAnimation;
			burden = _burden;
		}
		private function switchToCaryAnimation():void
		{
			_walkAnimation.visible = false;
			_walkHandsupAnimation.visible = true;
			_walkHandsupAnimation.reset();
			_curWalkAnimation = _walkHandsupAnimation;
			burden = _burden;
		}
		
		public function startPickup( rockWeight:Number ):void
		{
			_walkAnimation.visible = _walkHandsupAnimation.visible = false;
			_pickupAnimation.backwards = false;
			_pickupAnimation.reset();
			_pickupAnimation.visible = true;
			_pickupAnimation.period = _pickupTime*rockWeight;
			_pickingUp = true;
			burden = rockWeight;
		}
		
		public function pickup( timeElapsed:Number ):void
		{
			_pickingUp = !_pickupAnimation.play( timeElapsed );
			if( !_pickingUp )
			{
				_pickupAnimation.visible = false;
				switchToCaryAnimation();
			}
		}
		
		public function get isPickingUp():Boolean
		{
			return _pickingUp;
		}
		
		public function stopPickingUp():void
		{
			if( !_pickingUp )
				return;
			_pickingUp = false;
			_pickupAnimation.visible = false;
			_curWalkAnimation.visible = true;
		}
		
		public function get pickupProgress():Number
		{
			if( _pickingUp )
				return _pickupAnimation.progress;
			else
				return 1;
		}
		
		public function startPutdown():void
		{
			stopPickingUp();
			_walkAnimation.visible = _walkHandsupAnimation.visible = false;
			_pickupAnimation.backwards = true;
			_pickupAnimation.reset();
			_pickupAnimation.visible = true;
			_pickupAnimation.period = _pickupTime;
			_putingDown = true;
			burden = 0;
		}
		
		public function putdown( timeElapsed:Number ):void
		{
			_putingDown = !_pickupAnimation.play( timeElapsed );
			if( !_putingDown )
			{
				_pickupAnimation.visible = false;
				switchToWalkAnimation();
			}
		}
		
		public function get isPutingDown():Boolean
		{
			return _putingDown;
		}

		public function stopPutdown():void
		{
			if( !_putingDown )
				return;
			_putingDown = false;
			_pickupAnimation.visible = false;
			_curWalkAnimation.visible = true;
		}

		public function get putdownProgress():Number
		{
			if( _putingDown )
				return _pickupAnimation.progress;
			else
				return 1;
		}
		
		public function get isFreeToGo():Boolean
		{
			return _isAlive && !_pickingUp && !_putingDown && !_isFreeFalling;
		}
	}
}