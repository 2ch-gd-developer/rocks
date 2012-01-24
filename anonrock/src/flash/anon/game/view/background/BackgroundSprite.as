package flash.anon.game.view.background
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class BackgroundSprite extends Sprite
	{
		private var _image0:Bitmap;
		private var _image1:Bitmap;
		private var _gap:int;
		private var _deep:Number;
		private var _widthWithGap:int;
		
		public function BackgroundSprite()
		{
			super();
		}
		
		public function init( bitmapClass:Class, deep:Number=0, gap:int=0 ):void
		{
			_deep = deep;
			_image0 = new Bitmap( new bitmapClass(), "auto", true );
			_image1 = new Bitmap( new bitmapClass(), "auto", true );
			addChild( _image0 );
			_gap = gap;
			_widthWithGap = Math.max( _image0.width, _gap );
			_image1.x = _widthWithGap;
			addChild( _image1 );
		}
		
		public function setCamera( xValue:Number ):void
		{
			var perspectiveX:Number = xValue/( 1+_deep );
			var loops:int = perspectiveX/_widthWithGap;
			perspectiveX -= loops*_widthWithGap;
			x = -perspectiveX;
			if( x > 0 )
				x -= _widthWithGap;
		}
		
		private function get widthWithGap():int
		{
			return Math.max( _image0.width, _gap );
		}
	}
}