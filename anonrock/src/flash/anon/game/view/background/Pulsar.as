package flash.anon.game.view.background
{
	import flash.anon.game.view.animations.PulsarAnimation;
	import flash.display.Sprite;
	
	public class Pulsar extends Sprite
	{
		private var _animation:PulsarAnimation;
		
		public function Pulsar( animationPeriod:Number )
		{
			super();
			_animation = new PulsarAnimation( this );
			_animation.period = animationPeriod;
			_animation.visible = true;
			_animation.reset();
		}

		public function play( timeElapsed:Number ):void
		{
			_animation.play( timeElapsed );
		}
	}
}