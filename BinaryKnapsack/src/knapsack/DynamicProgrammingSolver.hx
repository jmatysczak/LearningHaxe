package knapsack;

using knapsack.Valuable;

class DynamicProgrammingSolver {
	public var ValuableCountLimit = 500;

	public function new() { }

	public function solve(valuables: Array<Valuable>, weightLimit: Float, heatMapSlotCount: Int) {
		var efficientFrontier = DynamicProgrammingAlgorithms.findEfficientFrontier(valuables);

		var best = null;
		for (valuables in efficientFrontier) if (valuables.Weight <= weightLimit) best = valuables;

		var heatMap = [],
			heatMapSlotWeight = valuables.calculateTotalWeight() / heatMapSlotCount,
			currentHeatMapSlotWeight = 0.0,
			efficientFrontierIndex = 0;
		for (i in 1...heatMapSlotCount) {
			currentHeatMapSlotWeight += heatMapSlotWeight;
			while (efficientFrontierIndex < efficientFrontier.length) {
				if (efficientFrontier[efficientFrontierIndex].Weight > currentHeatMapSlotWeight) {
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