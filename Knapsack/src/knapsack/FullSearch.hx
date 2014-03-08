package knapsack;
import haxe.ds.Vector.Vector;

class FullSearch {
	public static function Find(valuables: Array<Valuable>, weightLimit: Float) {
		var bestValue = 0,
			bestWeight = 0,
			bitMap = new Vector(valuables.length),
			solution = new Solution();
		solution.Valuables = valuables;
		solution.WeightLimit = weightLimit;

		return solution;
	}
}