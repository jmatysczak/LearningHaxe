package knapsack;

using Lambda;
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

		var allIds = [for(valuable in valuables) valuable.Id],
			totalValue = valuables.fold(function(valuable, value) return value + valuable.Value, 0),
			totalWeight = valuables.calculateTotalWeight(),
			heatMapSlotWeight = totalWeight / heatMapSlotCount,
			heatMap = [for (i in 1...heatMapSlotCount) this.findByHeatMap(valuables, heatMapSlotWeight * i) ];
		heatMap.push(new Valuables(allIds, totalValue, totalWeight));

		var efficientFrontier = this.findEfficientFrontier(valuables);

		return new Solution(valuables, weightLimit, best, heatMap, efficientFrontier);
	}

}
