package flash.anon.game
{
	public class PlanetParams
	{
		public var length:int; //= 6000;
		public var gravity:Number; //= 0.0004;
		public var minRockPeriod:int; // = 1500;
		public var maxRockPeriod:int; // = 3000;

		public function PlanetParams()
		{
			length = 4000 + 10000*Math.random();
			gravity = 0.0002 + 0.00075*Math.random();
			minRockPeriod = 333 + Math.random()*5000;
			maxRockPeriod = minRockPeriod*( 1.1 + 2*Math.random() );
		}
		
		public function getNextRockTime():int
		{
			return minRockPeriod + ( maxRockPeriod - minRockPeriod )*Math.random();
		}
	}
}