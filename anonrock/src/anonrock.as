package
{	
	import flash.anon.SceneView;
	import flash.anon.game.Game;
	import flash.anon.game.PlanetParams;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	[SWF(width="640", height="480", framerate="30", backgroundColor="#000000")]
	public class anonrock extends Sprite
	{
		public function anonrock()
		{
			if( stage )
				onStage( null );
			else
				addEventListener( Event.ADDED_TO_STAGE, onStage );
		}

		private function onStage( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onStage );
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var scene:SceneView = new SceneView( this );
			var game:Game = new Game( stage );
			var planetParams:PlanetParams = new PlanetParams();
			game.start( planetParams );
			scene.onStartGame( game );
		}
	}
}