package knapsack;

import haxe.ds.Vector.Vector;

using Lambda;
using knapsack.BBAndDP;

class BBAndDP {
	var findByBest: Array<Valuable> -> Float -> Valuables;
	var findByHeatMap: Array<Valuable> -> Float -> Valuables;

	public function new(findByBest, findByHeatMap) {
		this.findByBest = findByBest;
		this.findByHeatMap = findByHeatMap;
	}

	public function find(valuables: Array<Valuable>, weightLimit: Float) {
		var best = this.findByBest(valuables, weightLimit);

		var heatMapSlotCount = 20,
			heatMapSlotWeight = valuables.fold(function(valuable, weight) return valuable.Weight + weight, 0) / heatMapSlotCount;
		var heatMap = [for (i in 1...heatMapSlotCount + 1) this.findByHeatMap(valuables, heatMapSlotWeight * i) ];

		return new Solution(valuables, weightLimit, best, heatMap);
	}

	/**
	 * Based on:
	 * Horowitz-Sahni
	 * Chapter 2.5.1
	 * "Knapsack Problems: Algorithms and Computer Implementations"
	 * http://www.or.deis.unibo.it/knapsack.html
	 */
	public static function findByHorowitzSahni(valuables: Array<Valuable>, weightLimit: Float) {
		var j = 0,
			bestValue: Float = 0,
			bestWeight: Float = 0,
			bestInSolution = new Vector<Bool>(valuables.length),
			currentValue: Float = 0,
			currentResidualWeight: Float = weightLimit,
			currentInSolution = new Vector<Bool>(valuables.length),
			upperBound = valuables.length - 1,
			sortedValuables = valuables.mapi(DenseValuable.fromValuable).array().sortByDensityDesc(),
			currentState: HSState = ComputeUpperBoundU1;

		while (true) {
			switch(currentState) {
				case ComputeUpperBoundU1:
					var r = j - 1,
						jToRValue: Float = 0,
						jToRWeight: Float = 0;
					do {
						r++;
						jToRValue += sortedValuables[r].Value;
						jToRWeight += sortedValuables[r].Weight;
					} while (r < upperBound && jToRWeight <= currentResidualWeight);
					var u = (jToRValue - sortedValuables[r].Value) + (currentResidualWeight - jToRWeight + sortedValuables[r].Weight) * sortedValuables[r].Density;
					currentState = bestValue >= currentValue + u ? Backtrack : PerformAForwardStep;
				case PerformAForwardStep:
					while (j <= upperBound && sortedValuables[j].Weight <= currentResidualWeight) {
						currentResidualWeight -= sortedValuables[j].Weight;
						currentValue += sortedValuables[j].Value;
						currentInSolution[j] = true;
						j++;
					}
					if (j <= upperBound) {
						currentInSolution[j] = false;
						j++;
					}
					if (j < upperBound) currentState = ComputeUpperBoundU1;
					if (j == upperBound) currentState = PerformAForwardStep;
					if (j > upperBound) currentState = UpdateTheBestSolution;
				case UpdateTheBestSolution:
					if (bestValue < currentValue) {
						bestValue = currentValue;
						bestWeight = weightLimit - currentResidualWeight;
						for (i in 0...bestInSolution.length) bestInSolution[i] = currentInSolution[i];
					}
					j = upperBound;
					if (currentInSolution[upperBound]) {
						currentResidualWeight += sortedValuables[upperBound].Weight;
						currentValue -= sortedValuables[upperBound].Value;
						currentInSolution[upperBound] = false;
					}
					currentState = Backtrack;
				case Backtrack:
					var i = j - 1;
					while (i >= 0 && !currentInSolution[i]) i--;
					if (i == -1) break;
					currentResidualWeight += sortedValuables[i].Weight;
					currentValue -= sortedValuables[i].Value;
					currentInSolution[i] = false;
					j = i + 1;
					currentState = ComputeUpperBoundU1;
			}
		}

		return new Valuables(sortedValuables.setInSolution(bestInSolution).sortByIndexAsc().getIdsInSolution(), bestValue, bestWeight);
	}

	static function sortByDensityDesc(valuables: Array<DenseValuable>) {
		valuables.sort(function(dv1, dv2) {
			var diff = dv2.Density - dv1.Density;
			if (diff < 0) return -1;
			if (diff > 0) return 1;
			return 0;
		});
		return valuables;
	}
	static function setInSolution(valuables: Array<DenseValuable>, inSolution: Vector<Bool>) {
		for (i in 0...valuables.length) valuables[i].InSolution = inSolution[i];
		return valuables;
	}
	static function sortByIndexAsc(valuables: Array<DenseValuable>) {
		valuables.sort(function(dv1, dv2) return dv1.Index - dv2.Index);
		return valuables;
	}
	static function getIdsInSolution(valuables: Array<DenseValuable>) {
		return [for (i in 0...valuables.length) if (valuables[i].InSolution) valuables[i].Id];
	}
}

class DenseValuable extends Valuable {
	public var Index: Int;
	public var Density: Float;
	public var InSolution: Bool = false;

	public function new(index: Int, valuable: Valuable) {
		this.Index = index;
		this.Density = valuable.Value / valuable.Weight;
		super(valuable.Id, valuable.Value, valuable.Weight);
	}

	public override function toString() {
		return '$Id; $Value; $Weight; $Density\r\n';
	}

	public static function fromValuable(index: Int, valuable: Valuable) return new DenseValuable(index, valuable);
}

enum HSState {
	ComputeUpperBoundU1;
	PerformAForwardStep;
	UpdateTheBestSolution;
	Backtrack;
}
