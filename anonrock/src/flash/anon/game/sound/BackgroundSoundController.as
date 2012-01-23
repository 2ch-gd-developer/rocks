package flash.anon.game.sound
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import resources.MusicLoop;

	public class BackgroundSoundController
	{
		public static const DEFAULT_VOLUME:Number = 0.5;
		
		private var _volume:Number = DEFAULT_VOLUME;
		
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		
		public function BackgroundSoundController()
		{
			_sound = new MusicLoop();
		}
		
		public function start():void
		{
			if( _soundChannel == null )
				startSound();
		}
		
		private function startSound( event:Event=null ):void
		{
			if( event )
				event.target.removeEventListener( Event.SOUND_COMPLETE, startSound );
			_soundChannel = _sound.play( 0, 0, new SoundTransform( _volume,0 ) );
			_soundChannel.addEventListener( Event.SOUND_COMPLETE, startSound );
		}
		
		public function set volume( value:Number ):void
		{
			_volume = value;
			if( _soundChannel != null )
				_soundChannel.soundTransform = new SoundTransform( _volume,0 );
		}
		public function get volume():Number
		{
			return _volume;
		}
	}
}