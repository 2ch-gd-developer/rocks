package flash.anon.game.objects.prototypes
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class PlanetObject extends Sprite
	{
		public static const DISAPPEAR:String = "PlanetObjectDisappear";

		protected var _planetLength:int;
		protected var _planetX:Number = -1;
		protected var _planetY:Number = -1;
		protected var _planetXLooped:Number = -1;
		protected var _moved:Boolean = false;
		
		protected var _left:Number;
		protected var _right:Number;
		protected var _leftLoopedPart:Number;
		protected var _rightLoopedPart:Number;
		
		protected var _frontShadow:Shape;
		protected var _groundShadow:Shape;
		
		public function PlanetObject( planetLength:int )
		{
			super();
			_planetLength = planetLength;
			_frontShadow = new Shape();
			_groundShadow = new Shape();
		}
		
		public function get frontShadow():Shape
		{
			return _frontShadow;
		}
		public function get groundShadow():Shape
		{
			return _groundShadow;
		}
		public function clearFrontShadow():void
		{
			if( _frontShadow != null )
				_frontShadow.graphics.clear();
		}
		public function get frontShadowDistance():Number
		{
			return _planetY;
		}
		public function get groundShadowDistance():Number
		{
			return _planetY;
		}
		
		public function drawFrontShadowLine( innerOffsetX:Number, planetY:Number, alpha:Number ):void
		{
			if( _frontShadow != null )
			{
				var thickness:Number = innerOffsetX / objectWidth;
				thickness = Math.sin( thickness*Math.PI );
				thickness *= objectWidth/8;
				_frontShadow.graphics.lineStyle( 3, 0, alpha );
				_frontShadow.graphics.moveTo( innerOffsetX - objectWidth/2, -( planetY-thickness ) );
				_frontShadow.graphics.lineTo( innerOffsetX - objectWidth/2, -( planetY+thickness/2 ) );
			}
		}
		
		public function drawGroundShadow():void
		{
			if( _frontShadow != null )
			{
				_groundShadow.graphics.clear();
				_groundShadow.graphics.beginFill( 0 );
				_groundShadow.graphics.drawEllipse( -objectWidth/2, -objectWidth/8, objectWidth, objectWidth/4 );
				_groundShadow.graphics.endFill();
			}
		}

		public function get objectWidth():Number
		{
			return width;
		}
		
		public function get planetX():Number
		{
			return _planetX;
		}
		public function get planetXLooped():Number
		{
			return _planetXLooped;
		}
		public function set planetX( value:Number ):void
		{
			if( _planetX != value )
			{
				_planetX = value;
				_planetXLooped = _planetX % _planetLength;
				if( _planetXLooped < 0 )
					_planetXLooped += _planetLength;
				_moved = true;
				calculateLeftAndRight();
			}
		}
		public function get planetY():Number
		{
			return _planetY;
		}
		public function set planetY( value:Number ):void
		{
			if( _planetY != value )
			{
				_planetY = value;
				_moved = true;
			}
		}
		
		protected function calculateLeftAndRight():void
		{
			_left = _planetXLooped - objectWidth/2;
			_right = _planetXLooped + objectWidth/2;
			if( _left < 0 )
			{
				_leftLoopedPart = _planetLength + _left;
				_rightLoopedPart = _planetLength;
				_left = 0;
			}
			else if( _right > _planetLength )
			{
				_leftLoopedPart = 0;
				_rightLoopedPart = _right - _planetLength;
				_right = _planetLength;
			}
			else
			{
				_leftLoopedPart = _rightLoopedPart = -1;
			}
		}
		
		public function get moved():Boolean
		{
			return _moved;
		}
		
		public function clearMovedFlag():void
		{
			_moved = false;
		}
		
		public function moveToSameLoopAsObject( planetObject:PlanetObject ):Number
		{
			var d:Number = planetObject.planetX - _planetX;
			var sign:int = 1;
			if( d < 0 )
			{
				sign = -1;
				d = -d;
			}
			var loops:int = ( d + 0.5*_planetLength ) / _planetLength;
			return _planetX + sign*loops*_planetLength;
		}
		
		public function checkIntersect( otherObject:PlanetObject ):Boolean
		{
			if( checkIntersectSingleDiapason( _left, _right, otherObject.loopedLeftMain, otherObject.loopedRightMain ) )
				return true;
			if( _leftLoopedPart >= 0 )
			{
				if( checkIntersectSingleDiapason( _leftLoopedPart, _rightLoopedPart, otherObject.loopedLeftMain, otherObject.loopedRightMain ) )
					return true;
				if( otherObject.loopedLeftSecond >= 0 && 
					checkIntersectSingleDiapason( _leftLoopedPart, _rightLoopedPart, otherObject.loopedLeftSecond, otherObject.loopedRightSecond ) )
					return true;
			}
			if( otherObject.loopedLeftMain >= 0 )
			{
				if( checkIntersectSingleDiapason( _left, _right, otherObject.loopedLeftSecond, otherObject.loopedRightSecond ) )
					return true;
			}
			return false;
		}
		private function checkIntersectSingleDiapason( l1:Number, r1:Number, l2:Number, r2:Number ):Boolean
		{
			if( l2 < l1 )
				return r2 >= l1;
			return l2 < r1;
		}
		
		public function get loopedLeftMain():Number
		{
			return _left;
		}
		public function get loopedRightMain():Number
		{
			return _right;
		}
		public function get loopedLeftSecond():Number
		{
			return _leftLoopedPart;
		}
		public function get loopedRightSecond():Number
		{
			return _rightLoopedPart;
		}
	}
}