package flash.anon.game
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class Control extends EventDispatcher
	{
		public static const WALK_LEFT:String = "walkLeft";
		public static const WALK_RIGHT:String = "walkRight";
		public static const WALK_STOP:String = "walkStop";
		public static const PICKUP_ROCK:String = "pickupRock";
		public static const PUTDOWN_ROCK:String = "putdownRock";
		public static const ESCAPE:String = "escape";
		
		public var walkLeftKey:uint = Keyboard.LEFT;
		public var walkRightKey:uint = Keyboard.RIGHT;
		public var pickupKey:uint = Keyboard.UP;
		public var putdownKey:uint = Keyboard.DOWN;
		public var escapeKey:uint = Keyboard.BACKSPACE;

		private var _stage:Stage;
		
		private var _walkingLeft:Boolean = false;
		private var _walkingRight:Boolean = false;

		public function Control( target:IEventDispatcher=null )
		{
			super(target);
		}
		
		public function start( stage:Stage, useMouse:Boolean ):void
		{
			_stage = stage;
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, handleKeyDown );
			_stage.addEventListener( KeyboardEvent.KEY_UP, handleKeyUp );
			if( useMouse )
			{
				_stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
				_stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			}
		}
		
		public function stop():void
		{
			_stage.removeEventListener( KeyboardEvent.KEY_DOWN, handleKeyDown );
			_stage.removeEventListener( KeyboardEvent.KEY_UP, handleKeyUp );
			_stage.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			_stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		}
		
		public function get isWalkingLeft():Boolean
		{
			return _walkingLeft;
		}
		public function get isWalkingRight():Boolean
		{
			return _walkingRight;
		}
		
		private function handleKeyDown( e:KeyboardEvent ):void
		{
			switch( e.keyCode )
			{
			case walkLeftKey:
				if( !_walkingLeft )
				{
					_walkingLeft = true;
					_walkingRight = false;
					dispatchEvent( new Event(WALK_LEFT) );
				}
				break;
			case walkRightKey:
				if( !_walkingRight )
				{
					_walkingRight = true;
					_walkingLeft = false;
					dispatchEvent( new Event(WALK_RIGHT) );
				}
				break;
			case pickupKey:
				dispatchEvent( new Event(PICKUP_ROCK) );
				break;
			case putdownKey:
				dispatchEvent( new Event(PUTDOWN_ROCK) );
				break;
			case escapeKey:
				dispatchEvent( new Event(ESCAPE) );
				break;
			}
		}

		private function handleKeyUp( e:KeyboardEvent ):void
		{
			switch( e.keyCode )
			{
			case walkLeftKey:
				if( _walkingLeft )
				{
					_walkingLeft = false;
					_walkingRight = false;
					dispatchEvent( new Event(WALK_STOP) );
				}
				break;
			case walkRightKey:
				if( _walkingRight )
				{
					_walkingLeft = false;
					_walkingRight = false;
					dispatchEvent( new Event(WALK_STOP) );
				}
				break;
			}
		}
		
		private function onMouseDown( e:MouseEvent ):void
		{
			var mouseXRelative:Number = e.stageX / _stage.stageWidth;
			var mouseYRelative:Number = e.stageY / _stage.stageHeight;
			if( mouseYRelative < 0.667 )
			{
				dispatchEvent( new Event(PUTDOWN_ROCK) );
				dispatchEvent( new Event(PICKUP_ROCK) );
			}
			else if( mouseXRelative < 0.333 )
			{
				_walkingLeft = true;
				_walkingRight = false;
				dispatchEvent( new Event(WALK_LEFT) );
			}
			else if( mouseXRelative > 0.667 )
			{
				_walkingLeft = false;
				_walkingRight = true;
				dispatchEvent( new Event(WALK_RIGHT) );
			}
		}
		private function onMouseUp( e:MouseEvent ):void
		{
			if( _walkingLeft || _walkingRight )
			{
				_walkingLeft = false;
				_walkingRight = false;
				dispatchEvent( new Event(WALK_STOP) );
			}
		}
	}
}