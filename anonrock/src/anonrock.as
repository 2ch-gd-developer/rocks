package
{	
	import flash.anon.SceneView;
	import flash.anon.game.Game;
	import flash.anon.game.PlanetParams;
	import flash.anon.menu.MenuView;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	[SWF(width="640", height="480", framerate="30", backgroundColor="#000000")]
	public class anonrock extends Sprite
	{
		private var _scene:SceneView;
		
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
			
			_scene = new SceneView( this );
			var menu:MenuView = new MenuView();
			_scene.menu = menu;
			menu.addEventListener( MenuView.START_GAME, startGame );
		}
		
		private function startGame( e:Event ):void
		{
			var game:Game = new Game( stage );
			game.addEventListener( Event.COMPLETE, onGameComplete, false, 0, true );
			game.start( ( e.target as MenuView ).planetParams );
			_scene.onStartGame( game );
		}
		
		private function onGameComplete( e:Event ):void
		{
			_scene.onStopGame();
		}
	}
}