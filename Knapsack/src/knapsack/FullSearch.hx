package knapsack;
import haxe.ds.Vector.Vector;

class FullSearch {
	public static function Find(valuables: Array<Valuable>, weightLimit: Float) {
		if (valuables.length > 30) throw "FullSearch.Find does not support more than 30 Valuable items.";

		var bestValue: Float = 0,
			bestWeight: Float = 0,
			bestInSolution = 0,
			solution = new Solution(),
			maxSolution = (1 << (valuables.length + 1)) - 1;
		solution.Valuables = valuables;
		solution.WeightLimit = weightLimit;

		Sys.println(maxSolution);
		for(inSolution in 1...maxSolution) {
			var value: Float = 0,
				weight: Float = 0;
			for (i in 0...valuables.length) {
				if ((inSolution & (1 << i)) != 0) {
					value += valuables[i].Value;
					weight += valuables[i].Weight;
				}
			}
			if (weight < weightLimit && bestValue < value) {
				bestValue = value;
				bestWeight = weight;
				bestInSolution = inSolution;
			}
		}

		solution.Best = new Valuables([], bestValue, bestWeight);

		return solution;
	}
}