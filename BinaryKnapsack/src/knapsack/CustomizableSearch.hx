package knapsack;

using Lambda;

class CustomizableSearch {
	var findByBest: Array<Valuable> -> Float -> Valuables;
	var findByHeatMap: Array<Valuable> -> Float -> Valuables;

	public function new(findByBest, findByHeatMap) {
		this.findByBest = findByBest;
		this.findByHeatMap = findByHeatMap;
	}

	public function find(valuables: Array<Valuable>, weightLimit: Float, heatMapSlotCount: Int) {
		var best = this.findByBest(valuables, weightLimit);

		var heatMapSlotWeight = valuables.fold(function(valuable, weight) return valuable.Weight + weight, 0) / heatMapSlotCount;
		var heatMap = [for (i in 1...heatMapSlotCount + 1) this.findByHeatMap(valuables, heatMapSlotWeight * i) ];

		return new Solution(valuables, weightLimit, best, heatMap);
	}

}
