package knapsack;

import knapsack.ProblemFactory.Difficulty;

using knapsack.Valuable;

class DynamicProgrammingSolver implements Solver {
	public var Title = "Dynamic Programming";
	var findEfficientFrontier: Array<Valuable> -> Array<Valuables>;

	public function new(title, findEfficientFrontier) {
		this.Title += " (" + title + ")";
		this.findEfficientFrontier = findEfficientFrontier;
	}

	public function getValuableCountLimit(d: Difficulty): Int return d == VeryHard ? 20 : 500;

	public function solve(valuables: Array<Valuable>, weightLimit: Float, heatMapSlotCount: Int) {
		var efficientFrontier = this.findEfficientFrontier(valuables);

		var best = null;
		for (i in 0...efficientFrontier.length) {
			if (efficientFrontier[i].Weight > weightLimit) {
				best = efficientFrontier[i - 1];
				break;
			}
		}

		var heatMap = [],
			heatMapSlotWeight = valuables.calculateTotalWeight() / heatMapSlotCount,
			efficientFrontierIndex = 0;
		for (i in 1...heatMapSlotCount) {
			var currentHeatMapMaxWeight = i * heatMapSlotWeight;
			while (efficientFrontier[efficientFrontierIndex].Weight < currentHeatMapMaxWeight) efficientFrontierIndex++;
			heatMap.push(efficientFrontier[efficientFrontierIndex - 1]);
		}
		heatMap.push(efficientFrontier[efficientFrontier.length - 1]);

		return new Solution(this.Title, valuables, weightLimit, best, heatMap, efficientFrontier);
	}
}