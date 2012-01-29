package flash.anon.game
{
	public class PlanetParams
	{
		public var length:int; //= 6000;
		public var gravity:Number; //= 0.0004;
		public var minRockPeriod:int; // = 1500;
		public var maxRockPeriod:int; // = 3000;
		public var anonStepTime:int; // = 650;

		public function PlanetParams()
		{
			length = 4000 + 10000*Math.random();
			gravity = 0.0002 + 0.00075*Math.random();
			minRockPeriod = 333 + Math.random()*5000;
			maxRockPeriod = minRockPeriod*( 1.1 + 2*Math.random() );
			anonStepTime = 650;
		}
		
		public function createArcadePlanet():void
		{
			length = 2000 + 2000*Math.random();
			gravity = 0.00035 + 0.0002*Math.random();
			minRockPeriod = 500 + Math.random()*500;
			maxRockPeriod = minRockPeriod*2;
			anonStepTime = 500;
		}
		public function createMeditativePlanet():void
		{
			length = 8000 + 6000*Math.random();
			gravity = 0.00015 + 0.0001*Math.random();
			minRockPeriod = 1000 + Math.random()*5000;
			maxRockPeriod = minRockPeriod*4;
			anonStepTime = 800;
		}
		public function createHardcorePlanet():void
		{
			length = 4000 + 4000*Math.random();
			gravity = 0.0006 + 0.0004*Math.random();
			minRockPeriod = 200 + Math.random()*300;
			maxRockPeriod = minRockPeriod*1.5;
			anonStepTime = 600;
		}
		
		public function getNextRockTime():int
		{
			return minRockPeriod + ( maxRockPeriod - minRockPeriod )*Math.random();
		}
	}
}