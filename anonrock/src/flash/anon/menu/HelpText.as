package flash.anon.menu
{
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import resources.DungeonFont;
	
	public class HelpText extends MenuItem
	{
		public function HelpText()
		{
			super();
			_tf.multiline = true;
			title = "Left key - walk left\n" +
				"Right key - walk right\n" +
				"Up key - pick up rock\n" +
				"Down key - drop down rock\n" +
				"Backspace - abandon game and return to menu\n ";
		}
		
		override protected function createFontFormat():void
		{
			var font:Font = new DungeonFont();
			_textFormat = new TextFormat( font.fontName, 16 );
			_textFormat.align = TextAlign.CENTER;
		}
	}
}