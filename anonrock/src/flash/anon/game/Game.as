package flash.anon.game
{
	import flash.anon.SceneView;
	import flash.anon.game.objects.Anon;
	import flash.anon.game.objects.Rock;
	import flash.anon.game.objects.particles.BloodParticle;
	import flash.anon.game.objects.particles.Particle;
	import flash.anon.game.objects.particles.RockParticle;
	import flash.anon.game.objects.prototypes.PlanetObject;
	import flash.anon.game.sound.BackgroundSoundController;
	import flash.anon.game.sound.SoundEffects;
	import flash.anon.game.view.GameView;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class Game extends EventDispatcher
	{
		private var _planetParams:PlanetParams;
		
		private var _stage:Stage;
		private var _terrain:Terrain;
		private var _anon:Anon;
		private var _control:Control;
		private var _view:GameView;
		private var _backgroundSound:BackgroundSoundController;
		
		private var _score:Number;
		
		private var _fallingRocks:Vector.<Rock>;
		private var _timeForNextRock:int;
		private var _particles:Vector.<Particle>;
		
		private var _terrainUnderAnon:TerrainCheckResult;
		private var _carriedRock:Rock;
		private var _carriedRockPoint:Point;
		private var _carriedRockStartPoint:Point;

		public function Game( stage:Stage )
		{
			super();
			_stage = stage;
			
			_terrain = new Terrain();
			
			_view = new GameView();
			_backgroundSound = new BackgroundSoundController();
			
			_control = new Control();
			_control.addEventListener( Control.WALK_LEFT, onWalkLeft );
			_control.addEventListener( Control.WALK_RIGHT, onWalkRight );
			_control.addEventListener( Control.WALK_STOP, onWalkStop );
			_control.addEventListener( Control.PICKUP_ROCK, onPickup );
			_control.addEventListener( Control.PUTDOWN_ROCK, onPutdown );
			_control.addEventListener( Control.ESCAPE, escape );
		}
		
		public function start( planetParams:PlanetParams ):void
		{
			_planetParams = planetParams;
			
			_terrain.init( _planetParams.length, 100 );
			
			_anon = new Anon( _planetParams.anonStepTime, _terrain.length, _planetParams.gravity );
			_anon.init();
			
			_fallingRocks = new Vector.<Rock>();
			_particles = new Vector.<Particle>();
			_timeForNextRock = 0;
			
			_view.init( _terrain.length );
			_view.addPlanetObjectToForeground( _anon, true );
			_view.setSizes( 640, 480 );
			_view.setCamera( 0, -16 );
			
			_score = 0;
			_stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			_backgroundSound.start();
			
			_control.start( _stage, true );
		}
		
		public function stop():void
		{
			_backgroundSound.stop();
			_control.stop();
			_stage.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		private function escape( event:Event ):void
		{
			stop();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		private var _prevTime:int = int.MAX_VALUE;
		private function onEnterFrame( event:Event ):void
		{
			var timeElapsed:int = 0;
			var curTime:int = flash.utils.getTimer();
			if( curTime > _prevTime )
			{
				timeElapsed = curTime - _prevTime;
			}
			_prevTime = curTime;
			
			_view.animate( timeElapsed );
			
			if( curTime >= _timeForNextRock )
			{
				dropNewRock();
				_timeForNextRock = curTime + _planetParams.getNextRockTime();
			}
			
			for each( var rock:Rock in _fallingRocks )
			{
				rockFalling( rock, timeElapsed );
			}
			for each( var particle:Particle in _particles )
			{
				particle.fall( timeElapsed );
			}
			
			if( _anon.isAlive )
			{
				if( _anon.isFreeFalling )
				{
					_anon.fall( timeElapsed );
					carryRock();
					if( _anon.planetY <= _terrainUnderAnon.height )
					{
						if( _anon.speedY < -0.335 )
							anonDie();
						else
						{
							_anon.planetY = _terrainUnderAnon.height;
							_anon.fixOnGround();
						}
					}
				}
				else if( _anon.isPickingUp && _carriedRock != null )
				{
					_anon.pickup( timeElapsed );
					_carriedRock.planetX = _carriedRockStartPoint.x + _anon.pickupProgress*( _carriedRockPoint.x - _carriedRockStartPoint.x );
					_carriedRock.planetY = _carriedRockStartPoint.y + _anon.pickupProgress*( _carriedRockPoint.y - _carriedRockStartPoint.y );
					_terrain.findRockBase( _carriedRock );
				}
				else if( _anon.isPutingDown )
				{
					_anon.putdown( timeElapsed );
				}
				else if( _control.isWalkingLeft || _control.isWalkingRight )
				{
					anonWalking( timeElapsed );
				}
			}
			
			var cameraY:Number = ( _anon.planetY < _view.viewHeight/4 )? -16 : _anon.planetY - _view.viewHeight/4;
			if( Math.abs( _view.cameraPlanetY - _anon.planetY ) < 1 )
			{
				_view.setCamera( _anon.planetX, cameraY );
			}
			else
			{
				_view.setCamera( _anon.planetX, _view.cameraPlanetY + ( cameraY - _view.cameraPlanetY )*0.25 );
			}
			_view.updatePlanetObjects();
			
			if( _anon.isAlive )
			{
				_score += timeElapsed/1000;
				_view.score = _score;
			}
		}
		
		private function anonWalking( timeElapsed:int ):void
		{
			if( _control.isWalkingLeft && _anon.direction != -1 )
				_anon.direction = -1;
			if( _control.isWalkingRight && _anon.direction != 1 )
				_anon.direction = 1;
			const anonDeltaX:Number = _anon.walkDeltaX( timeElapsed );
			const nextStepLoopedX:Number = _terrain.getLoopedX( _anon.planetX + anonDeltaX );
			const anonDeltaY:Number = _terrain.getHeightForPoint( nextStepLoopedX ).height - _anon.planetY;
			if( anonDeltaY < Math.abs(anonDeltaX)*7 )
			{
				_anon.walk( timeElapsed );
				checkAnonGround();
				carryRock();
			}
		}
		private function checkAnonGround():void
		{
			_terrainUnderAnon = _terrain.getHeightForPoint( _anon.planetXLooped );
			if( _anon.planetY < _terrainUnderAnon.height + _anon.height/8 )
				_anon.planetY = _terrainUnderAnon.height;
			else
				_anon.startFall();
		}
		
		private function rockFalling( rock:Rock, timeElapsed:int ):void
		{
			var rockPrevX:Number = rock.planetX;
			var rockPrevY:Number = rock.planetY;
			rock.fall( timeElapsed );
			_terrain.findRockBase( rock );
			if( rock.baseHeight > rockPrevY )
			{
				rock.planetX = rockPrevX;
				rock.planetY = rockPrevY;
				rock.ricochet();
				SoundEffects.playRockSound( 1, rock, getDistanceFromAnonToRock(rock), false );
				return;
			}
			if( _anon.isAlive && rock.isDeadly && 
				rock.planetY < _anon.planetY + _anon.height && rock.checkIntersect( _anon ) )
				anonDie();
			if( _carriedRock != null &&
				rock.planetY < _carriedRock.planetY + _carriedRock.height && 
				rock.checkIntersect( _carriedRock ) )
			{
				breakRock( _carriedRock );
				breakRock( rock );
			}
			if( rock.isDeadly && rock.nearestHeight > rock.planetY || 
				rock.baseHeight > rock.planetY )
			{
				rock.planetY = rock.baseHeight;
				onRockFall( rock );
			}
		}
		
		private function carryRock():void
		{
			if( _carriedRock != null )
			{
				_carriedRock.planetX = _anon.planetX;
				_carriedRock.planetY = _anon.planetY + _anon.height;
				_terrain.findRockBase( _carriedRock );
			}
		}
		
		private function onWalkLeft( event:Event ):void
		{
			if( _anon.isFreeToGo && _anon.direction != -1 )
				_anon.direction = -1;
		}
		private function onWalkRight( event:Event ):void
		{
			if( _anon.isFreeToGo && _anon.direction != 1 )
				_anon.direction = 1;
		}
		private function onWalkStop( event:Event ):void
		{
			_anon.stop();
		}
		private function onPickup( event:Event ):void
		{
			if( _anon.isFreeToGo && _carriedRock == null )
			{
				var pickPoint:Number = _terrain.getLoopedX( _anon.planetX + 0.25*_anon.width*_anon.direction );
				var terrainCheckResult:TerrainCheckResult = _terrain.getHeightForPoint( pickPoint, true );
				if( terrainCheckResult.rock != null && checkRockForPickup( terrainCheckResult.rock ) )
				{
					_carriedRock = terrainCheckResult.rock;
					_carriedRock.planetX = _carriedRock.moveToSameLoopAsObject( _anon );
					_terrain.removeFixedRock( _carriedRock );
					_carriedRockStartPoint = new Point( _carriedRock.planetX, _carriedRock.planetY );
					_carriedRockPoint = new Point( _anon.planetX, _anon.planetY + _anon.height );
					_anon.startPickup( _carriedRock.weight );
				}
			}
		}
		private function checkRockForPickup( rock:Rock ):Boolean
		{
			return rock != _terrainUnderAnon.rock &&
				rock.baseFor.length == 0 &&
				rock.planetY + rock.height/2 >= _anon.planetY &&
				rock.planetY + rock.height/2 <= _anon.planetY + _anon.height;
		}
		
		private function onPutdown( event:Event ):void
		{
			if( _anon.isFreeToGo && _carriedRock != null )
			{
				_anon.startPutdown();
				_view.moveToTheBackOfRocksView( _carriedRock );
				_carriedRock.isDeadly = false;
				_carriedRock.drop( Math.PI/2 - _anon.direction*Math.PI/4, 0.05 + 0.025/_carriedRock.weight );
				_fallingRocks.push( _carriedRock );
				_carriedRock = null;
			}
		}
		
		private function anonDie():void
		{
			if( _anon.isAlive )
			{
				startDieEffect();
				_anon.isAlive = false;
				_anon.dispatchEvent( new Event(PlanetObject.DISAPPEAR) );
				if( _carriedRock != null )
				{
					_fallingRocks.push( _carriedRock );
					_carriedRock.startFall();
					_carriedRock = null;
				}
			}
		}
		
		private function dropNewRock():void
		{
			var rock:Rock = new Rock( _terrain.length, _planetParams.gravity );
			var rockSize:Number = 0.5+0.5*Math.random();
			rock.init( rockSize*rockSize, rockSize );
			rock.isDeadly = true;
			rock.planetX = _anon.planetX + 3*_view.viewWidth*( 2*Math.random() - 1 );
			rock.planetY = _anon.planetY + SceneView.GAME_HEIGHT*1.5;
			rock.startFall();
			_fallingRocks.push( rock );
			_view.addPlanetObjectToRocksView( rock, true );
			rock.addEventListener( Rock.LOOSE_BASE, onRockLooseBase, false, 0, true );
			//rock.addEventListener( MouseEvent.CLICK, onRockClick, false, 0, true );
		}
		private function onRockClick( event:MouseEvent ):void
		{
			if( event.target is Rock )
			{
				breakRock( event.target as Rock );
			}
		}
		
		private function removeRockFromFallingRocks( rock:Rock ):void
		{
			var index:int = _fallingRocks.indexOf( rock );
			if( index >= 0 )
			{
				_fallingRocks.splice( index, 1 );
			}
		}
		
		private function getDistanceFromAnonToRock( rock:Rock ):Number
		{
			var rockX:Number = rock.moveToSameLoopAsObject( _anon );
			return ( rockX - _anon.planetX )/_view.width;
		}
		
		private function breakRock( rock:Rock ):void
		{
			if( rock == _carriedRock )
			{
				_anon.startPutdown();
				_carriedRock = null;
			}
			startRockBreakEffect( rock );
			rock.dispatchEvent( new Event(PlanetObject.DISAPPEAR) );
			_terrain.removeFixedRock( rock );
			removeRockFromFallingRocks( rock );
			SoundEffects.playRockSound( 0.5, rock, getDistanceFromAnonToRock(rock), true );
		}
		
		private function onRockFall( rock:Rock ):void
		{
			var breaks:Boolean = false;
			if( rock.isDeadly && rock.nearestRock != null )
			{
				breakRock( rock.nearestRock );
				breakRock( rock );
			}
			else
			{
				rock.fixOnGround();
				removeRockFromFallingRocks( rock );
				rock.isDeadly = false;
				_terrain.findRockBase( rock );
				_terrain.addFixedRock( rock );
				SoundEffects.playRockSound( 1, rock, getDistanceFromAnonToRock(rock), false );
				checkAnonGround();
			}
		}
		
		private var _loosedRocks:Vector.<Rock>;
		private var _loosedRocksTimer:Timer;
		private function onRockLooseBase( event:Event ):void
		{
			if( event.target is Rock )
			{
				var rock:Rock = event.target as Rock;
				
				if( _loosedRocks == null )
					_loosedRocks = new Vector.<Rock>();
				_loosedRocks.push( rock );
				if( _loosedRocksTimer == null )
				{
					_loosedRocksTimer = new Timer( 500 );
					_loosedRocksTimer.addEventListener( TimerEvent.TIMER, loosedRockStartFall, false, 0, true );
					_loosedRocksTimer.start();
				}
			}
		}
		private function loosedRockStartFall( event:TimerEvent ):void
		{
			if( _loosedRocks == null || _loosedRocks.length == 0 )
			{
				_loosedRocksTimer.stop();
				_loosedRocksTimer = null;
			}
			else
			{
				var rock:Rock = _loosedRocks.shift();
				if( _fallingRocks.indexOf(rock) < 0 )
					_fallingRocks.push( rock );
				_terrain.removeFixedRock( rock );
				rock.isDeadly = false;
				rock.startFall();
			}
		}

		private var _dyingTimer:Timer;
		private function startDieEffect():void
		{
			SoundEffects.playDeathSound();
			_dyingTimer = new Timer( 30, 40 );
			_dyingTimer.addEventListener( TimerEvent.TIMER, onDyingTimer, false, 0, true );
			_dyingTimer.start();
		}
		private function onDyingTimer( event:Event ):void
		{
			for( var i:int = 0; i < 10; ++i )
			{
				var particle:BloodParticle = new BloodParticle( _terrain.length, _planetParams.gravity );
				particle.init( 1+4*Math.random(), Math.PI*( i+15 )/40, 0.075+0.1*Math.random() );
				particle.planetX = _anon.planetX;
				particle.planetY = _anon.planetY;
				_particles.push( particle );
				_view.addPlanetObjectToForeground( particle );
				particle.addEventListener( PlanetObject.DISAPPEAR, onParticleDisappear, false, 0, true );
			}
			_backgroundSound.volume = BackgroundSoundController.DEFAULT_VOLUME*( 1 - _dyingTimer.currentCount / _dyingTimer.repeatCount );
		}
		
		private function startRockBreakEffect( rock:Rock ):void
		{
			for( var i:int = 0; i < 6; ++i )
			{
				var particle:RockParticle = new RockParticle( _terrain.length, _planetParams.gravity );
				particle.init( rock.weight/4, Math.PI*( i+4 )/14, 0.07+0.07*Math.random() );
				particle.planetX = rock.planetX;
				particle.planetY = rock.planetY + rock.height/2;
				_particles.push( particle );
				_view.addPlanetObjectToForeground( particle );
				particle.addEventListener( PlanetObject.DISAPPEAR, onParticleDisappear, false, 0, true );
			}
		}
		
		private function onParticleDisappear( event:Event ):void
		{
			if( event.target is Particle )
			{
				var particle:Particle = event.target as Particle;
				var index:int = _particles.indexOf( particle );
				if( index >= 0 )
					_particles.splice( index, 1 );
			}
		}
		
		public function get view():GameView
		{
			return _view;
		}
	}
}