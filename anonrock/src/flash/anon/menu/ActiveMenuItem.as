package flash.anon.menu
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ActiveMenuItem extends MenuItem
	{
		public function ActiveMenuItem(title:String=null)
		{
			super(title);
			addEventListener( MouseEvent.ROLL_OVER, onMouseOver );
		}
		
		override public function highlight():void
		{
			_tf.textColor = 0xFFFFFF;
		}
		override public function unhighlight():void
		{
			_tf.textColor = 0x00FF00;
		}
		
		private function onMouseOver( e:MouseEvent ):void
		{
			dispatchEvent( new Event( MenuItem.HIGHLIGHTED ) );
		}
	}
}