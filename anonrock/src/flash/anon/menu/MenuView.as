package flash.anon.menu
{
	import flash.anon.game.PlanetParams;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	
	public class MenuView extends Sprite
	{
		public static const START_GAME:String = "MENU_START_GAME";
		
		private var _active:Boolean = false;
		
		private var _items:Vector.<MenuItem>;
		private var _visibleItems:Vector.<MenuItem>;
		private var _curHighlightedItemIndex:int;
		
		private var _startGameItem:MenuItem;
		private var _helpItem:MenuItem;
		private var _creditsItem:MenuItem;
		private var _emptyItem:MenuItem;
		private var _backItem:MenuItem;
		
		private var _arcadeMode:MenuItem;
		private var _meditateMode:MenuItem;
		private var _hardcoreMode:MenuItem;
		
		private var _threadURL:MenuItem;
		private var _songURL:MenuItem;
		
		private var _helpText:MenuItem;
		
		private var _sceneWidth:Number;
		private var _sceneHeight:Number;
		private var _subMenuHeight:Number;
		
		private var _planetParams:PlanetParams;
		
		public function MenuView()
		{
			super();
			
			_items = new Vector.<MenuItem>();
			
			_startGameItem = new ActiveMenuItem( "start game" );
			_startGameItem.addEventListener( MouseEvent.CLICK, drawModeSelection );
			_items.push( _startGameItem );
			_helpItem = new ActiveMenuItem( "help" );
			_helpItem.addEventListener( MouseEvent.CLICK, drawHelp );
			_items.push( _helpItem );
			_creditsItem = new ActiveMenuItem( "credits" );
			_creditsItem.addEventListener( MouseEvent.CLICK, drawCredits );
			_items.push( _creditsItem );
			_backItem = new ActiveMenuItem( "back" );
			_backItem.addEventListener( MouseEvent.CLICK, drawMain );
			_items.push( _backItem );
			
			_helpText = new HelpText();
			_items.push( _helpText );
			
			_threadURL = new ActiveMenuItem( "homepage" );
			_threadURL.addEventListener( MouseEvent.CLICK, navigateToThread );
			_items.push( _threadURL );
			_songURL = new ActiveMenuItem( "song" );
			_songURL.addEventListener( MouseEvent.CLICK, navigateToSong );
			_items.push( _songURL );
			
			_arcadeMode = new ActiveMenuItem( "arcade" );
			_arcadeMode.addEventListener( MouseEvent.CLICK, setModeAndStart );
			_items.push( _arcadeMode );
			_meditateMode = new ActiveMenuItem( "meditation" );
			_meditateMode.addEventListener( MouseEvent.CLICK, setModeAndStart );
			_items.push( _meditateMode );
			_hardcoreMode = new ActiveMenuItem( "hardcore" );
			_hardcoreMode.addEventListener( MouseEvent.CLICK, setModeAndStart );
			_items.push( _hardcoreMode );
			
			for each( var item:MenuItem in _items )
			{
				item.addEventListener( MenuItem.HIGHLIGHTED, itemHighlightedByMouse );
			}
			
			drawMain();
			
			_planetParams = new PlanetParams();
			
			addEventListener( Event.ADDED_TO_STAGE, onStage, false, 0, true );
		}
		
		public function activate():void
		{
			_active = true;
			if( stage )
				stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		}
		public function deactivate():void
		{
			_active = false;
			if( stage )
				stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		}
		
		private function onStage( e:Event ):void
		{
			if( _active )
				stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		}
		
		private function onKeyDown( e:KeyboardEvent ):void
		{
			switch( e.keyCode )
			{
			case Keyboard.UP:
				if( _curHighlightedItemIndex > 0 )
				{
					highlightItem( _visibleItems[--_curHighlightedItemIndex] );
				}
				break;
			case Keyboard.DOWN:
				if( _curHighlightedItemIndex < _visibleItems.length-1 )
				{
					highlightItem( _visibleItems[++_curHighlightedItemIndex] );
				}
				break;
			case Keyboard.ENTER:
			case Keyboard.SPACE:
				_visibleItems[_curHighlightedItemIndex].dispatchEvent( new MouseEvent( MouseEvent.CLICK ) );
				break;
			}
		}
		
		public function setSizes( sceneWidth:Number, sceneHeight:Number ):void
		{
			_sceneWidth = sceneWidth;
			_sceneHeight = sceneHeight;
			for each( var item:MenuItem in _items )
			{
				item.sceneWidth = _sceneWidth;
			}
			y = ( _sceneHeight - _subMenuHeight )*scaleY/2;
		}
		
		public function get planetParams():PlanetParams
		{
			return _planetParams;
		}
		
		private function clear():void
		{
			while( numChildren > 0 )
			{
				removeChildAt(0);
			}
			_visibleItems = new Vector.<MenuItem>();
		}
		
		private function drawSubMenu( items:Array ):void
		{
			clear();
			_subMenuHeight = 0;
			var itemHeight:Number = 0;
			for each( var item:MenuItem in items )
			{
				if( item == null )
				{
					_subMenuHeight += itemHeight;
				}
				else
				{
					item.y = _subMenuHeight;
					addChild( item );
					itemHeight = item.height;
					_subMenuHeight += itemHeight;
					if( item is ActiveMenuItem )
						_visibleItems.push( item );
				}
			}
			_curHighlightedItemIndex = 0;
			highlightItem( _visibleItems[_curHighlightedItemIndex] );
			setSizes( _sceneWidth, _sceneHeight );
		}
		
		private function itemHighlightedByMouse( e:Event ):void
		{
			if( !_active )
				return;
			if( e.target is MenuItem )
			{
				const item:MenuItem = e.target as MenuItem;
				const itemIndex:int = _visibleItems.indexOf(item);
				if( itemIndex >= 0 )
				{
					_curHighlightedItemIndex = itemIndex;
					highlightItem( item );
				}
			}
		}
		
		private function highlightItem( itemToHighlight:MenuItem ):void
		{
			for each( var item:MenuItem in _items )
			{
				if( item == itemToHighlight )
					item.highlight();
				else
					item.unhighlight();
			}
		}
		
		private function drawMain( event:Event=null ):void
		{
			drawSubMenu( new Array( _startGameItem, _helpItem, _creditsItem ) );
		}
		
		private function drawModeSelection( event:Event=null ):void
		{
			drawSubMenu( new Array( _arcadeMode, _meditateMode, _hardcoreMode, null, _backItem ) );
		}
		
		private function drawCredits( event:Event=null ):void
		{
			drawSubMenu( new Array( _threadURL, _songURL, null, _backItem ) );
		}
		
		private function drawHelp( event:Event=null ):void
		{
			drawSubMenu( new Array( _helpText, _backItem ) );
		}
		
		private function setModeAndStart( event:Event ):void
		{
			switch( event.target )
			{
				case _arcadeMode:
					_planetParams.createArcadePlanet();
					break;
				case _meditateMode:
					_planetParams.createMeditativePlanet();
					break;
				case _hardcoreMode:
					_planetParams.createHardcorePlanet();
					break;
			}
			dispatchEvent( new Event( START_GAME ) );
		}
		
		private function navigateToThread( event:Event=null ):void
		{
			navigateToURL( new URLRequest( "http://2ch.so/gd/res/188.html" ), "_blank" );
		}
		private function navigateToSong( event:Event=null ):void
		{
			navigateToURL( new URLRequest( "http://www.youtube.com/watch?v=l-GwX5x1cio" ), "_blank" );
		}
	}
}