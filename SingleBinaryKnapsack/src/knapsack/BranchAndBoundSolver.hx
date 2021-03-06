package knapsack;

import knapsack.ProblemFactory.Difficulty;

using Lambda;
using knapsack.Valuable;

class BranchAndBoundSolver implements Solver {
	public var Title: String;
	var solverImpl: Array<Valuable> -> Float -> Valuables;

	public function new(title, solverImpl) {
		this.Title = title;
		this.solverImpl = solverImpl;
	}

	public function getValuableCountLimit(d: Difficulty): Int return d == VeryHard ? 20 : 500;

	public function solve(valuables: Array<Valuable>, weightLimit: Float, heatMapSlotCount: Int) {
		var best = this.solverImpl(valuables, weightLimit);

		var totalWeight = valuables.calculateTotalWeight(),
			heatMapSlotWeight = totalWeight / heatMapSlotCount,
			heatMap = [for (i in 1...heatMapSlotCount) this.solverImpl(valuables, heatMapSlotWeight * i) ];
		heatMap.push(new Valuables(valuables.allIds(), valuables.calculateTotalValue(), totalWeight));

		return new Solution(this.Title, valuables, weightLimit, best, heatMap);
	}

}
