package knapsack;
import haxe.ds.Vector.Vector;

using knapsack.FullSearch;

class FullSearch {
	public static function Find(valuables: Array<Valuable>, weightLimit: Float) {
		if (valuables.length > 30) throw "FullSearch.Find does not support more than 30 Valuable items.";

		var bestValue: Float = 0,
			bestWeight: Float = 0,
			bestInSolution = 0,
			maxSolution = (1 << (valuables.length + 1)) - 1;

		for(inSolution in 1...maxSolution) {
			var value: Float = 0,
				weight: Float = 0;
			for (i in 0...valuables.length) {
				if (inSolution.hasBitSet(i)) {
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

		var bestIds = [];
		for (i in 0...valuables.length) if (bestInSolution.hasBitSet(i)) bestIds.push(valuables[i].Id);

		var solution = new Solution(valuables, weightLimit, new Valuables(bestIds, bestValue, bestWeight));

		return solution;
	}

	inline static function hasBitSet(n:Int, i: Int) {
		return (n & (1 << i)) != 0;
	}
}