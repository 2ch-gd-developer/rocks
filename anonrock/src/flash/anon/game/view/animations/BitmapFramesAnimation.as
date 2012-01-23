package flash.anon.game.view.animations
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;

	public class BitmapFramesAnimation
	{
		private var _container:DisplayObjectContainer;
		private var _bitmaps:Vector.<Bitmap> = new Vector.<Bitmap>();
		private var _period:Number = 1000;
		private var _index:int = -1;
		private var _progress:Number = 0;
		private var _backwards:Boolean = false;
		
		public function BitmapFramesAnimation( container:DisplayObjectContainer )
		{
			_container = container;
		}
		
		public function set period( value:Number ):void
		{
			_period = value;
		}
		
		public function addFrame( bitmap:Bitmap ):void
		{
			bitmap.visible = false;
			_bitmaps.push( bitmap );
			_container.addChild( bitmap );
		}
		
		public function set backwards( value:Boolean ):void
		{
			_backwards = value;
		}
		
		public function reset():void
		{
			for each( var bitmap:Bitmap in _bitmaps )
			{
				bitmap.visible = false;
			}
			_progress = 0;
			_index = _backwards? _bitmaps.length-1 : 0;
			_bitmaps[_index].visible = true;
		}
		
		public function play( timeElapsed:Number ):Boolean
		{
			_progress += timeElapsed / _period;
			var looped:Boolean = false;
			if( _progress >= 1 )
			{
				_progress -= 1;
				looped = true;
			}
			var nextIndex:int = ( _backwards? ( 1-_progress ) : _progress )*_bitmaps.length;
			if( nextIndex != _index && nextIndex >= 0 && nextIndex < _bitmaps.length )
			{
				_bitmaps[_index].visible = false;
				_index = nextIndex;
				_bitmaps[_index].visible = true;
			}
			return looped;
		}
		
		public function get progress():Number
		{
			return _progress;
		}
		
		public function set visible( value:Boolean ):void
		{
			if( _index >= 0 )
				_bitmaps[_index].visible = value;
		}
	}
}