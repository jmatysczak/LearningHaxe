package knapsack;

using knapsack.Valuable;

class DynamicProgrammingSolver {
	public var ValuableCountLimit = 500;

	public function new() { }

	public function solve(valuables: Array<Valuable>, weightLimit: Float, heatMapSlotCount: Int) {
		var efficientFrontier = DynamicProgrammingAlgorithms.findEfficientFrontier(valuables);

		var best = null;
		for (i in 0...efficientFrontier.length) {
			if (efficientFrontier[i].Weight > weightLimit) {
				best = efficientFrontier[i - 1];
				break;
			}
		}

		var heatMap = [],
			heatMapSlotWeight = valuables.calculateTotalWeight() / heatMapSlotCount,
			currentHeatMapMaxWeight = 0.0,
			efficientFrontierIndex = 0;
		for (i in 1...heatMapSlotCount) {
			currentHeatMapMaxWeight += heatMapSlotWeight;
			while (efficientFrontierIndex < efficientFrontier.length) {
				if (efficientFrontier[efficientFrontierIndex].Weight > currentHeatMapMaxWeight) {
					heatMap.push(efficientFrontier[efficientFrontierIndex - 1]);
					break;
				}
				efficientFrontierIndex++;
			}
		}
		heatMap.push(efficientFrontier[efficientFrontier.length - 1]);

		return new Solution(valuables, weightLimit, best, heatMap, efficientFrontier);
	}
}