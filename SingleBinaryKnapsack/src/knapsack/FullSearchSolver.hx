package knapsack;

import haxe.ds.Vector.Vector;
import knapsack.ProblemFactory.Difficulty;

using knapsack.ArrayTools;
using knapsack.Valuable;
using knapsack.FullSearchSolver;

class FullSearchSolver implements Solver {
	public var Title = "Full Search";

	public function new() { }

	public function getValuableCountLimit(d: Difficulty): Int return d == VeryHard ? 15 : 20;

	public function solve(valuables: Array<Valuable>, weightLimit: Float, heatMapSlotCount: Int) {
		var bestValue: Float = 0,
			bestWeight: Float = 0,
			bestInSolution = 0,
			inSolution = 1 << valuables.length,
			totalWeight = valuables.calculateTotalWeight(),
			heatMapSlotWeight = totalWeight / heatMapSlotCount,
			heatMap = Vector.fromArrayCopy([for (i in 0...heatMapSlotCount) new HMValuables()]),
			efficientFrontier = new EFValuables(0, 0, 0, new EFValuables(valuables.calculateTotalValue(), totalWeight, inSolution - 1));

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

			var efCurrent = efficientFrontier;
			while (efCurrent.Next.Weight < weight) efCurrent = efCurrent.Next;
			if (efCurrent.Value < value) {
				var efNext = efCurrent.Next;
				if (efNext.Value < value || weight < efNext.Weight) {
					while (efNext.Value < value) efNext = efNext.Next;
					efCurrent.Next = new EFValuables(value, weight, inSolution, efNext);
				}
			}
		}

		var best = new Valuables(valuables.getIdsInSolution(bestInSolution), bestValue, bestWeight);
		var heatMapValuables = heatMap.toValuables(valuables);
		var efficientFrontierValuables = efficientFrontier.toValuables(valuables);
		return new Solution(this.Title, valuables, weightLimit, best, heatMapValuables, efficientFrontierValuables);
	}

	inline static function hasBitSet(n:Int, i: Int) {
		return (n & (1 << i)) != 0;
	}

	public static function getIdsInSolution(valuables: Array<Valuable>, inSolution: Int) {
		return [for (i in 0...valuables.length) if (inSolution.hasBitSet(i)) valuables[i].Id].toStrVector();
	}

	static function toValuables(heatMapItems: Vector<HMValuables>, valuables: Array<Valuable>) {
		return [for(heatMapItem in heatMapItems) new Valuables(valuables.getIdsInSolution(heatMapItem.InSolution), heatMapItem.Value, heatMapItem.Weight)];
	}
}

private class HMValuables {
	public var Value: Float = 0;
	public var Weight: Float;
	public var InSolution: Int;

	public function new() { }
}

private class EFValuables extends HMValuables {
	public var Next: EFValuables;

	public function new(value, weight, inSolution, ?next) {
		super();
		this.Next = next;
		this.Value = value;
		this.Weight = weight;
		this.InSolution = inSolution;
	}

	public function toValuables(valuables: Array<Valuable>) {
		var ef = this;
		return [while((ef = ef.Next) != null) new Valuables(valuables.getIdsInSolution(ef.InSolution), ef.Value, ef.Weight)];
	}
}
