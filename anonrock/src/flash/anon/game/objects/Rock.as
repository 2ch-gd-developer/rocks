package flash.anon.game.objects
{
	import flash.anon.game.objects.prototypes.PlanetPhysicalObject;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import resources.RockBitmap;

	public class Rock extends PlanetPhysicalObject
	{
		public static const POINT_IS_OUTSIDE:Number = -16384;
		
		public static const FALL:String = "RockFall";
		public static const LOOSE_BASE:String = "RockLooseBase";
		
		private var _weight:Number;
		private var _isDeadly:Boolean = true;
		
		private var _basedOn:Rock;
		private var _nearestRock:Rock;
		private var _baseFor:Vector.<Rock>;
		private var _baseHeight:Number;
		private var _nearestHeight:Number;
		
		private var _bitmap:Bitmap;
		
		public function Rock( planetLength:int, planetGravity:Number )
		{
			super( planetLength, planetGravity );
		}

		public function init( weight:Number, size:Number ):void
		{
			_weight = weight;
			_baseFor = new Vector.<Rock>();
			_bitmap = new Bitmap( new RockBitmap(), "auto", true );
			_bitmap.scaleX = _bitmap.scaleY = size;
			_bitmap.x = -_bitmap.width/2;
			_bitmap.y = -_bitmap.height;
			addChild( _bitmap );
			calculateLeftAndRight();
			if( groundShadow != null )
				drawGroundShadow();
			startFall();
		}
		
		override public function get frontShadowDistance():Number
		{
			var result:Number = _planetY - _baseHeight;
			if( result < height )
				result = Number.MAX_VALUE;// /= height - result;
			return result;
		}

		public function get weight():Number
		{
			return _weight;
		}
		
		public function set isDeadly( value:Boolean ):void
		{
			_isDeadly = value;
		}
		public function get isDeadly():Boolean
		{
			return _isDeadly;
		}
		
		public function getProfile( planetXToCheck:Number ):Number
		{
			var innerX:Number = -1;
			if( planetXToCheck >= _left && planetXToCheck <= _right )
			{
				innerX = planetXToCheck - _left;
				if( _rightLoopedPart == _planetLength )
					innerX += _rightLoopedPart - _leftLoopedPart;
			}
			else if( planetXToCheck >= _leftLoopedPart && planetXToCheck <= _rightLoopedPart )
			{
				innerX = planetXToCheck - _leftLoopedPart;
				if( _leftLoopedPart == 0 )
					innerX += _right - _left;
			}
			if( innerX >= 0 && innerX <= width )
			{
				innerX = 2*innerX/width - 1;
				if( innerX < 0 ) innerX = -innerX;
				return planetY + 0.7*height*( 1 - innerX*innerX*innerX );
			}
			return POINT_IS_OUTSIDE;
		}
		
		public function getInnerPlanetX( offset:Number ):Number
		{
			if( _rightLoopedPart == _planetLength )
			{
				if( offset < _rightLoopedPart - _leftLoopedPart )
					return _leftLoopedPart + offset;
				else
					return offset - ( _rightLoopedPart - _leftLoopedPart );
			}
			else if( _leftLoopedPart == 0 )
			{
				if( offset < _right - _left )
					return _left + offset;
				else
					return offset - ( _right - _left );
			}
			return _left + offset;
		}
		
		public function drop( angle:Number, speed:Number ):void
		{
			_speedX = Math.cos( angle )*speed;
			_speedY = Math.sin( angle )*speed;
			_isFreeFalling = true;
		}
		
		public function set basedOn( value:Rock ):void
		{
			_basedOn = value;
		}
		public function get basedOn():Rock
		{
			return _basedOn;
		}
		public function set nearestRock( value:Rock ):void
		{
			_nearestRock = value;
		}
		public function get nearestRock():Rock
		{
			return _nearestRock;
		}
		
		public function addRockOnIt( rock:Rock ):void
		{
			_baseFor.push( rock );
		}
		public function removeRockFromTop( rock:Rock ):void
		{
			const index:int = _baseFor.indexOf( rock );
			if( index >= 0 )
			{
				_baseFor.splice( index, 1 );
			}
		}
		public function get baseFor():Vector.<Rock>
		{
			return _baseFor;
		}
		public function clearBaseFor():void
		{
			_baseFor = new Vector.<Rock>();
		}
		
		public function set baseHeight( value:Number ):void
		{
			_baseHeight = value;
		}
		public function get baseHeight():Number
		{
			return _baseHeight;
		}
		
		public function set nearestHeight( value:Number ):void
		{
			_nearestHeight = value;
		}
		public function get nearestHeight():Number
		{
			return _nearestHeight;
		}
	}
}