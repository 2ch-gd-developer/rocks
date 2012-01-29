package flash.anon.menu
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import resources.DungeonFont;
	
	public class MenuItem extends Sprite
	{
		public static const HIGHLIGHTED:String = "MENU_ITEM_HIGHLIGHTED";
		
		protected var _tf:TextField;
		protected var _textFormat:TextFormat;
		protected var _textWidth:Number;
		protected var _textHeight:Number;
		protected var _hitRect:Shape;
		
		public function MenuItem( title:String=null )
		{
			super();
			_hitRect = new Shape();
			addChild( _hitRect );
			createFontFormat();
			_tf = new TextField();
			_tf.textColor = 0x00FF00;
			_tf.embedFonts = true;
			_tf.selectable = false;
			_tf.y = 2;
			addChild( _tf );
			if( title != null )
				this.title = title;
			
			mouseChildren = false;
		}
		
		protected function createFontFormat():void
		{
			var font:Font = new DungeonFont();
			_textFormat = new TextFormat( font.fontName, 20 );
		}
		
		public function set title( value:String ):void
		{
			_tf.text = value;
			_tf.setTextFormat( _textFormat );
			_textWidth = _tf.textWidth + 4;
			_textHeight = _tf.textHeight + 6;
			_tf.width = _textWidth;
			_tf.height = _textHeight - _tf.y;
			_hitRect.graphics.clear();
			_hitRect.graphics.beginFill( 0, 0 );
			_hitRect.graphics.drawRect( 0, 0, _textWidth, _textHeight );
			_hitRect.graphics.endFill();
		}
		public function get title():String
		{
			return _tf.text;
		}
		
		public function set sceneWidth( value:Number ):void
		{
			_tf.x = _hitRect.x = ( value - _textWidth )/2;
		}
		
		override public function get width():Number
		{
			return _textWidth;
		}
		override public function get height():Number
		{
			return _textHeight;
		}
		
		public function highlight():void
		{
		}
		public function unhighlight():void
		{
		}
	}
}