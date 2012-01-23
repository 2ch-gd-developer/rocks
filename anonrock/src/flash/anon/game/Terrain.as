package flash.anon.game
{
	import flash.anon.game.objects.Rock;
	import flash.events.Event;

	public class Terrain
	{
		private var _length:int;
		private var _rocksZones:Vector.< Vector.<Rock> >;
		private var _freeRocks:Vector.<Rock>;
		private var _zonesNumber:int;
		private var _zoneWidth:Number;

		public function Terrain()
		{
		}

		public function init( length:int, zoneWidth:int ):void
		{
			_length = length;
			_zonesNumber = _length / zoneWidth;
			_zoneWidth = _length / _zonesNumber;
			_rocksZones = new Vector.< Vector.<Rock> >( _zonesNumber, true );
			for( var i:int = 0; i < _zonesNumber; ++i )
			{
				_rocksZones[i] = new Vector.<Rock>();
			}
			_freeRocks = new Vector.<Rock>();
		}

		public function get length():Number
		{
			return _length;
		}
		
		public function getLoopedX( planetX:Number ):Number
		{
			planetX = planetX % _length;
			if( planetX < 0 )
				planetX += _length;
			return planetX;
		}
		
		public function addFreeRock( rock:Rock ):void
		{
			if( _freeRocks.indexOf( rock ) < 0 )
				_freeRocks.push( rock );
		}
		public function removeFreeRock( rock:Rock ):void
		{
			var index:int = _freeRocks.indexOf( rock );
			if( index >= 0 )
				_freeRocks.splice( index, 1 );
		}
		
		private function getRocksForPoint( planetXLooped:Number ):Vector.<Rock>
		{
			const zoneIndex:int = planetXLooped / _zoneWidth;
			var leftZoneIndex:int = zoneIndex;
			var rightZoneIndex:int = zoneIndex;
			if( zoneIndex == _zonesNumber-1 )
				rightZoneIndex = 0;
			else
				++rightZoneIndex;
			if( zoneIndex == 0 )
				leftZoneIndex = _zonesNumber-1;
			else
				--leftZoneIndex;
			var result:Vector.<Rock> = new Vector.<Rock>();
			result = result.concat( _rocksZones[zoneIndex] );
			result = result.concat( _rocksZones[leftZoneIndex] );
			result = result.concat( _rocksZones[rightZoneIndex] );
			result = result.concat( _freeRocks );
			return result;
		}
		
		public function getHeightForPoint( planetXLooped:Number, onlyFreeRock:Boolean=false ):TerrainCheckResult
		{
			if( planetXLooped == _length )
				--planetXLooped;
			var rocks:Vector.<Rock> = getRocksForPoint( planetXLooped );
			var result:TerrainCheckResult = new TerrainCheckResult();
			for each( var rock:Rock in rocks )
			{
				if( !onlyFreeRock || rock.baseFor.length == 0 )
				{
					var rockProfile:Number = rock.getProfile( planetXLooped );
					if( rockProfile != Rock.POINT_IS_OUTSIDE && rockProfile > result.height )
					{
						result.height = rockProfile;
						result.rock = rock;
						result.rockProfile = ( rockProfile - rock.planetY )/rock.height;
					}
				}
			}
			return result;
		}

		public function findRockBase( rock:Rock ):void
		{
			var lowestResult:TerrainCheckResult = null;
			var highestResult:TerrainCheckResult = null;
			rock.clearFrontShadow();
			for( var rockInnerOffset:Number = rock.objectWidth*0.12; rockInnerOffset < 0.88*rock.objectWidth; ++rockInnerOffset )
			{
				var rockInnerPlanetX:Number = rock.getInnerPlanetX( rockInnerOffset );
				var pointCheckResult:TerrainCheckResult = getHeightForPoint( rockInnerPlanetX );
				if( pointCheckResult.rockProfile > 0.33 )
					rock.drawFrontShadowLine( rockInnerOffset, pointCheckResult.height, pointCheckResult.rockProfile );
				if( lowestResult == null || lowestResult.height > pointCheckResult.height )
					lowestResult = pointCheckResult;
				if( rockInnerOffset > rock.objectWidth*0.333 && rockInnerOffset < rock.objectWidth*0.667 &&
					( highestResult == null || highestResult.height < pointCheckResult.height ) )
					highestResult = pointCheckResult;
			}
			rock.basedOn = lowestResult.rock;
			rock.baseHeight = lowestResult.height;
			if( highestResult.rock != null )
			{
				rock.nearestRock = highestResult.rock;
				rock.nearestHeight = highestResult.height;
			}
			else
			{
				rock.nearestRock = lowestResult.rock;
				rock.nearestHeight = lowestResult.height;
			}
		}
		
		public function addFixedRock( rock:Rock ):void
		{
			const zoneIndex:int = rock.planetXLooped / _zoneWidth;
			_rocksZones[zoneIndex].push( rock );
			if( rock.basedOn != null )
				rock.basedOn.addRockOnIt( rock );
		}
		
		public function removeFixedRock( rock:Rock ):void
		{
			var zoneIndex:int = rock.planetXLooped / _zoneWidth;
			if( zoneIndex == _zonesNumber )
				zoneIndex = 0;
			var index:int = _rocksZones[zoneIndex].indexOf( rock );
			if( index >= 0 )
			{
				_rocksZones[zoneIndex].splice( index, 1 );
			}
			for each( var rockOnTop:Rock in rock.baseFor )
			{
				rockOnTop.dispatchEvent( new Event(Rock.LOOSE_BASE) );
			}
			if( rock.basedOn != null )
				rock.basedOn.removeRockFromTop( rock );
			rock.clearBaseFor();
			rock.basedOn = null;
		}
	}
}