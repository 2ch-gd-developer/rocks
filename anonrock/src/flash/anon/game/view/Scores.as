package flash.anon.game.view
{
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import resources.DungeonFont;
	
	public class Scores extends Sprite
	{
		private var _tf:TextField;
		private var _textFormat:TextFormat;
		
		public function Scores()
		{
			super();
			_tf = new TextField();
			var font:Font = new DungeonFont();
			_textFormat = new TextFormat( font.fontName, 14 );
			_textFormat.align = TextAlign.RIGHT;
			_tf.textColor = 0xFFFFFF;
			_tf.embedFonts = true;
			_tf.selectable = false;
			addChild( _tf );
		}
		
		public function setScore( value:int ):void
		{
			_tf.text = value.toString();
			_tf.setTextFormat( _textFormat );
		}
		
		public override function set width(value:Number):void
		{
			super.width = _tf.width = value;
		}
	}
}