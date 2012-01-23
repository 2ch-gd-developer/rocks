package flash.anon.game.view.background
{
	import resources.Planet;

	public class PlanetSprite extends BackgroundSprite
	{
		public function PlanetSprite( gap:int )
		{
			super();
			init( Planet, 3, gap );
		}
	}
}