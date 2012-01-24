package flash.anon.game.view
{
	import flash.anon.SceneView;
	import flash.anon.game.objects.prototypes.PlanetObject;
	import flash.anon.game.view.background.Ground;
	import flash.anon.game.view.background.PlanetSprite;
	import flash.anon.game.view.background.Pulsar;
	import flash.anon.game.view.background.Sky;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class GameView extends Sprite
	{
		private var _viewWidth:Number;
		private var _viewHeight:Number;
		private var _cameraPlanetX:Number;
		private var _cameraPlanetXCentric:Number;
		private var _cameraPlanetXLooped:Number;
		private var _cameraPlanetY:Number;
		private var _planetLength:int;
		
		private var _sky:Sky;
		private var _pulsars:Vector.<Pulsar>;
		private var _planet:PlanetSprite;
		private var _ground:Ground;
		private var _foreground:Sprite;
		private var _rocksView:Sprite;
		private var _groundShadows:Sprite;
		private var _frontShadows:Sprite;
		private var _scoresIndicator:Scores;
		
		private var _planetObjects:Vector.<PlanetObject>;
		
		public function GameView()
		{
			super();
		}
		
		public function init( planetLength:int ):void
		{
			_planetLength = planetLength;
			
			_sky = new Sky();
			addChild( _sky );
			
			const numOfPulsars:int = 10 + 10*Math.random();
			_pulsars = new Vector.<Pulsar>( planetLength*2, true );
			for( var i:int = 0; i < numOfPulsars; ++i )
			{
				var pulsarPeriod:Number = 500 + Math.random()*5000;
				var pulsar:Pulsar = new Pulsar( pulsarPeriod );
				pulsar.x = Math.random()*_sky.width/2;
				pulsar.y = Math.random()*_sky.height;
				_pulsars[i] = pulsar;
				_sky.addChild( pulsar );
				var pulsarDouble:Pulsar = new Pulsar( pulsarPeriod );
				pulsarDouble.x = pulsar.x + _sky.width/2;
				pulsarDouble.y = pulsar.y;
				_pulsars[i+numOfPulsars] = pulsarDouble;
				_sky.addChild( pulsarDouble );
			}
			
			_planet = new PlanetSprite( planetLength/4 );
			addChild( _planet );
			_ground = new Ground();
			addChild( _ground );
			_foreground = new Sprite();
			addChild( _foreground );
			_groundShadows = new Sprite();
			_foreground.addChild( _groundShadows );
			_rocksView = new Sprite();
			_foreground.addChild( _rocksView );
			_frontShadows = new Sprite();
			_foreground.addChild( _frontShadows );
			
			_scoresIndicator = new Scores();
			addChild( _scoresIndicator );
			
			_planetObjects = new Vector.<PlanetObject>();
			
			setCamera( 0,0, true );
		}
		
		public function setSizes( width:Number, height:Number ):void
		{
			if( width != _viewWidth || height != _viewHeight )
			{
				_viewWidth = width;
				_viewHeight = height;
				setCamera( _cameraPlanetXCentric, _cameraPlanetY, true );
				
				_sky.y = ( _viewHeight - _sky.height )/2;
				_planet.y = ( _viewHeight - _planet.height )/2;
				_ground.y = _viewHeight - _ground.height;
				
				_scoresIndicator.width = _viewWidth;
			}
		}
		
		public function get viewWidth():Number
		{
			return _viewWidth;
		}
		public function get viewHeight():Number
		{
			return _viewHeight;
		}
		
		public function animate( timeElapsed:Number ):void
		{
			for each( var pulsar:Pulsar in _pulsars )
			{
				if( pulsar != null )
					pulsar.play( timeElapsed );
			}
		}
		
		public function setCamera( cameraXCentric:Number, cameraY:Number, force:Boolean=false ):void
		{
			if( cameraXCentric != _cameraPlanetXCentric || force )
			{
				_cameraPlanetXCentric = cameraXCentric;
				_cameraPlanetX = _cameraPlanetXCentric - _viewWidth/2;
				_cameraPlanetXLooped = _cameraPlanetX % _planetLength;
				if( _cameraPlanetXLooped < 0 )
					_cameraPlanetXLooped += _planetLength;
				_sky.setCamera( _cameraPlanetX );
				_planet.setCamera( _cameraPlanetX );
				_ground.setCamera( _cameraPlanetX );
				for each( var planetObject:PlanetObject in _planetObjects )
				{
					adjustPlanetObject( planetObject );
				}
			}
			if( cameraY != _cameraPlanetY || force )
			{
				_cameraPlanetY = cameraY;
				_foreground.y = _viewHeight + _cameraPlanetY;
				_ground.y = _viewHeight - _ground.height;
				if( _cameraPlanetY > 0 )
					_ground.y += _cameraPlanetY/4;
			}
		}
		public function get cameraPlanetX():Number
		{
			return _cameraPlanetXCentric;
		}
		public function get cameraPlanetY():Number
		{
			return _cameraPlanetY;
		}
		
		public function moveToTheBackOfRocksView( planetObject:PlanetObject ):void
		{
			_rocksView.setChildIndex( planetObject, 0 );
		}
		public function moveToTheFrontOfRocksView( planetObject:PlanetObject ):void
		{
			_rocksView.setChildIndex( planetObject, _rocksView.numChildren-1 );
		}
		
		public function addPlanetObjectToRocksView( planetObject:PlanetObject, toTheBack:Boolean=false ):void
		{
			if( toTheBack )
				_rocksView.addChildAt( planetObject, 0 );
			else
				_rocksView.addChild( planetObject );
			addPlanetObject( planetObject );
		}
		public function addPlanetObjectToForeground( planetObject:PlanetObject, toTheBack:Boolean=false ):void
		{
			if( toTheBack )
				_foreground.addChildAt( planetObject, 1 ); // zero is ground shadows
			else
				_foreground.addChild( planetObject );
			addPlanetObject( planetObject );
		}
		private function addPlanetObject( planetObject:PlanetObject ):void
		{
			if( planetObject.frontShadow != null )
				_frontShadows.addChild( planetObject.frontShadow );
			if( planetObject.groundShadow != null )
				_groundShadows.addChild( planetObject.groundShadow );
			_planetObjects.push( planetObject );
			planetObject.addEventListener( PlanetObject.DISAPPEAR, onPlanetObjectDisappear, false, 0, true );
		}
		
		public function updatePlanetObjects():void
		{
			for each( var planetObject:PlanetObject in _planetObjects )
			{
				if( planetObject.moved )
				{
					adjustPlanetObject( planetObject );
					planetObject.clearMovedFlag();
				}
			}
		}
		
		private function adjustPlanetObject( planetObject:PlanetObject ):void
		{
			planetObject.x = planetObject.planetXLooped - _cameraPlanetXLooped;
			if( planetObject.x + _planetLength < _viewWidth + planetObject.width )
				planetObject.x += _planetLength;
			else if( planetObject.x - _planetLength > 0 - planetObject.width )
				planetObject.x -= _planetLength;
			planetObject.y = -planetObject.planetY;
			
			if( planetObject.frontShadow != null )
			{
				planetObject.frontShadow.alpha = 1 - 0.5*planetObject.frontShadowDistance / SceneView.GAME_HEIGHT;
				planetObject.frontShadow.x = planetObject.x;
				planetObject.frontShadow.y = 0;
			}
			if( planetObject.groundShadow != null )
			{
				planetObject.groundShadow.alpha = 1 - 0.5*planetObject.groundShadowDistance / SceneView.GAME_HEIGHT;
				planetObject.groundShadow.x = planetObject.x;
			}
		}
		
		private function onPlanetObjectDisappear( e:Event ):void
		{
			if( e.target is PlanetObject )
			{
				var planetObject:PlanetObject = e.target as PlanetObject;
				if( planetObject.parent != null )
					planetObject.parent.removeChild( planetObject );
				if( planetObject.frontShadow != null && planetObject.frontShadow.parent != null )
					planetObject.frontShadow.parent.removeChild( planetObject.frontShadow );
				if( planetObject.groundShadow != null && planetObject.groundShadow.parent != null )
					planetObject.groundShadow.parent.removeChild( planetObject.groundShadow );
				var objectIndex:int = _planetObjects.indexOf( planetObject );
				if( objectIndex >= 0 )
					_planetObjects.splice( objectIndex, 1 );
				planetObject.removeEventListener( PlanetObject.DISAPPEAR, onPlanetObjectDisappear );
			}
		}
		
		public function set score( value:Number ):void
		{
			_scoresIndicator.setScore( value );
		}
	}
}