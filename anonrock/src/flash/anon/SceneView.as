package flash.anon
{
	import flash.anon.game.Game;
	import flash.anon.menu.MenuView;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	import resources.OverlayBitmap;

	public class SceneView
	{
		public static const GAME_WIDTH:Number = 640;
		public static const GAME_HEIGHT:Number = 480;
		
		private var _stage:Stage;
		private var _root:DisplayObjectContainer;
		private var _menu:MenuView;
		private var _game:Game;
		private var _overlay:Bitmap;
		private var _mask:Shape;
		
		public function SceneView( root:DisplayObjectContainer )
		{
			_root = root;
			_stage = _root.stage;
			_overlay = new Bitmap( new OverlayBitmap(), "auto", true );
			_overlay.blendMode = BlendMode.MULTIPLY;
			_root.addChild( _overlay );
			_mask = new Shape();
			_root.addChild( _mask );
			_root.mask = _mask;
			setSizes();
			
			_stage.addEventListener( Event.RESIZE, setSizes );
		}
		
		public function addChild( child:DisplayObject ):void
		{
			_root.addChild( child );
			_root.setChildIndex( _overlay, _root.numChildren-1 );
		}
		
		public function set menu( value:MenuView ):void
		{
			_menu = value;
			addChild( _menu );
			setSizes();
		}
		
		public function onStartGame( game:Game ):void
		{
			Mouse.hide();
			_menu.visible = _menu.mouseEnabled = false;
			_game = game;
			addChild( _game.view );
			setSizes();
		}
		
		public function onStopGame():void
		{
			Mouse.show();
			if( _game != null )
			{
				_root.removeChild( _game.view );
				_game = null;
			}
			_menu.visible = _menu.mouseEnabled = true;
		}
		
		private function setSizes( e:Event=null ):void
		{
			var gameScale:Number = Math.max( _stage.stageWidth / GAME_WIDTH, _stage.stageHeight / GAME_HEIGHT );
			if( _game != null )
			{
				_game.view.scaleX = _game.view.scaleY = gameScale;
				_game.view.setSizes( _stage.stageWidth / gameScale, _stage.stageHeight / gameScale );
			}
			if( _menu != null )
			{
				_menu.scaleX = _menu.scaleY = gameScale;
				_menu.setSizes( _stage.stageWidth / gameScale, _stage.stageHeight / gameScale );
			}
			_overlay.scaleX = _overlay.scaleY = gameScale;
			_mask.graphics.clear();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect( 0, 0, _stage.stageWidth, _stage.stageHeight );
			_mask.graphics.endFill();
		}
	}
}