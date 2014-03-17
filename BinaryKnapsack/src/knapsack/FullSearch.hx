package knapsack;
import haxe.ds.Vector.Vector;

using knapsack.Valuable;
using knapsack.FullSearch;

class FullSearch {
	public static function find(valuables: Array<Valuable>, weightLimit: Float, heatMapSlotCount: Int) {
		if (valuables.length > 30) throw "FullSearch.Find does not support more than 30 Valuable items.";

		var bestValue: Float = 0,
			bestWeight: Float = 0,
			bestInSolution = 0,
			inSolution = 1 << valuables.length,
			heatMapSlotWeight = valuables.calculateTotalWeight() / heatMapSlotCount,
			heatMap = [for (i in 0...heatMapSlotCount) new TempValuables()],
			efficientFrontier = new Array<TempValuables>();

		while(--inSolution > 0) {
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

			var heatMapStartIndex = Math.ceil(weight / heatMapSlotWeight) - 1;
			for (i in heatMapStartIndex...heatMapSlotCount) {
				if (value <= heatMap[i].Value) break;
				var heatMapItem = heatMap[i];
				heatMapItem.Value = value;
				heatMapItem.Weight = weight;
				heatMapItem.InSolution = inSolution;
			}

			var efInsertIndex = -1;
			while (++efInsertIndex < efficientFrontier.length) if (weight < efficientFrontier[efInsertIndex].Weight) break;
			if (efInsertIndex == 0 || efficientFrontier[efInsertIndex - 1].Value < value) {
				efficientFrontier.insert(efInsertIndex, new TempValuables(value, weight, inSolution));
				var efDeleteStopIndex = ++efInsertIndex;
				while (efDeleteStopIndex < efficientFrontier.length && efficientFrontier[efDeleteStopIndex].Value < value) efDeleteStopIndex++;
				if (efInsertIndex < efDeleteStopIndex) efficientFrontier.splice(efInsertIndex, efDeleteStopIndex - efInsertIndex);
			}
		}

		var best = new Valuables(valuables.getIdsInSolution(bestInSolution), bestValue, bestWeight);
		var heatMapValuables = heatMap.toValuables(valuables);
		var efficientFrontierValuables = efficientFrontier.toValuables(valuables);
		return new Solution(valuables, weightLimit, best, heatMapValuables, efficientFrontierValuables);
	}

	inline static function hasBitSet(n:Int, i: Int) {
		return (n & (1 << i)) != 0;
	}

	static function getIdsInSolution(valuables: Array<Valuable>, inSolution: Int) {
		return [for (i in 0...valuables.length) if (inSolution.hasBitSet(i)) valuables[i].Id];
	}

	static function toValuables(heatMapItems: Array<TempValuables>, valuables: Array<Valuable>) {
		return heatMapItems.map(function(heatMapItem) return new Valuables(valuables.getIdsInSolution(heatMapItem.InSolution), heatMapItem.Value, heatMapItem.Weight));
	}
}

class TempValuables {
	public var Value: Float = 0;
	public var Weight: Float;
	public var InSolution: Int;

	public function new(?value, ?weight, ?inSolution) {
		this.Value = value;
		this.Weight = weight;
		this.InSolution = inSolution;
	}
}
