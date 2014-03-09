package knapsack;
import haxe.ds.Vector.Vector;

using Lambda;
using knapsack.FullSearch;

class FullSearch {
	public static function Find(valuables: Array<Valuable>, weightLimit: Float) {
		if (valuables.length > 30) throw "FullSearch.Find does not support more than 30 Valuable items.";

		var bestValue: Float = 0,
			bestWeight: Float = 0,
			bestInSolution = 0,
			inSolution = 0,
			maxInSolution = (1 << valuables.length) - 1,
			heatMapSlotCount = 20,
			heatMapSlotWeight = valuables.fold(function(valuable, weight) return valuable.Weight + weight, 0) / heatMapSlotCount,
			heatMap = [for(i in 0...heatMapSlotCount) new HeatMapItem()];

		while(++inSolution <= maxInSolution) {
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

			var heatMapStartIndex = Std.int(weight / heatMapSlotWeight);
			if (heatMapStartIndex * heatMapSlotWeight == weight) heatMapStartIndex--;
			for (i in heatMapStartIndex...heatMapSlotCount) {
				if (value <= heatMap[i].Value) break;
				var heatMapItem = heatMap[i];
				heatMapItem.Value = value;
				heatMapItem.Weight = weight;
				heatMapItem.InSolution = inSolution;
			}
		}

		var best = new Valuables(valuables.getIdsInSolution(bestInSolution), bestValue, bestWeight);
		var heatMapValuables = heatMap.map(function(heatMapItem) return new Valuables(valuables.getIdsInSolution(heatMapItem.InSolution), heatMapItem.Value, heatMapItem.Weight));

		var solution = new Solution(valuables, weightLimit, best, heatMapValuables);

		return solution;
	}

	inline static function hasBitSet(n:Int, i: Int) {
		return (n & (1 << i)) != 0;
	}

	static function getIdsInSolution(valuables: Array<Valuable>, inSolution: Int) {
		return [for (i in 0...valuables.length) if (inSolution.hasBitSet(i)) valuables[i].Id];
	}
}

class HeatMapItem {
	public var Value: Float = 0;
	public var Weight: Float;
	public var InSolution: Int;

	public function new() { }
}
