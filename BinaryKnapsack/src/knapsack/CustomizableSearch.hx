package knapsack;

using knapsack.Valuable;

class CustomizableSearch {
	var findByBest: Array<Valuable> -> Float -> Valuables;
	var findByHeatMap: Array<Valuable> -> Float -> Valuables;
	var findEfficientFrontier: Array<Valuable> -> Array<Valuables>;

	public function new(findByBest, findByHeatMap, findEfficientFrontier) {
		this.findByBest = findByBest;
		this.findByHeatMap = findByHeatMap;
		this.findEfficientFrontier = findEfficientFrontier;
	}

	public function find(valuables: Array<Valuable>, weightLimit: Float, heatMapSlotCount: Int) {
		var best = this.findByBest(valuables, weightLimit);

		var heatMapSlotWeight = valuables.calculateTotalWeight() / heatMapSlotCount;
		var heatMap = [for (i in 1...heatMapSlotCount + 1) this.findByHeatMap(valuables, heatMapSlotWeight * i) ];

		var efficientFrontier = this.findEfficientFrontier(valuables);

		return new Solution(valuables, weightLimit, best, heatMap, efficientFrontier);
	}

}
