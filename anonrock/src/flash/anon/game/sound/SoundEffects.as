package flash.anon.game.sound
{
	import flash.anon.game.objects.Rock;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	import resources.Bloodrain;
	import resources.RockGround;
	import resources.RockRock;
	
	public class SoundEffects
	{
		public static function playRockSound( maxVolume:Number, rock:Rock, normalizedDistance:Number, breaks:Boolean ):void
		{
			var sound:Sound = breaks? new RockRock() : new RockGround();
			var volume:Number = rock.weight/( 1+10*Math.abs(normalizedDistance) );
			if( normalizedDistance < -1 )
				normalizedDistance = -1;
			else if( normalizedDistance > 1 )
				normalizedDistance = 1;
			var transform:SoundTransform = new SoundTransform( maxVolume*volume, normalizedDistance );
			sound.play( 0, 0, transform );
		}
		
		public static function playDeathSound():void
		{
			var sound:Sound = new Bloodrain();
			sound.play();
		}
	}
}