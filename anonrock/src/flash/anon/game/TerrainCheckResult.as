package flash.anon.game
{
	import flash.anon.game.objects.Rock;

	public class TerrainCheckResult
	{
		public var height:Number;
		public var rock:Rock;
		public var rockProfile:Number;
		
		public function TerrainCheckResult( height:Number=0, rock:Rock=null, rockProfile:Number=0 )
		{
			this.height = height;
			this.rock = rock;
			this.rockProfile = rockProfile;
		}
	}
}