package knapsack;

import haxe.ds.Vector.Vector;

using Lambda;
using knapsack.BranchAndBoundAlgorithms;
using knapsack.FloatTools;

class BranchAndBoundAlgorithms {
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

		sortedValuables.setInSolution(bestInSolution);

		var bestWeight = sortedValuables.fold(function(valuable, weigth) return weigth + (valuable.InSolution ? valuable.Weight : 0), 0);

		return new Valuables(sortedValuables.sortByIndexAsc().getIdsInSolution(), bestValue, bestWeight);
	}

	static function sortByDensityDesc(valuables: Array<DenseValuable>) {
		valuables.sort(function(dv1, dv2) return dv2.Density.compareTo(dv1.Density));
		return valuables;
	}
	static function setInSolution(valuables: Array<DenseValuable>, inSolution: Vector<Bool>) {
		for (i in 0...valuables.length) valuables[i].InSolution = inSolution[i];
	}
	static function sortByIndexAsc(valuables: Array<DenseValuable>) {
		valuables.sort(function(dv1, dv2) return dv1.Index - dv2.Index);
		return valuables;
	}
	static function getIdsInSolution(valuables: Array<DenseValuable>) {
		return [for (valuable in valuables) if (valuable.InSolution) valuable.Id];
	}
}

class DenseValuable extends Valuable {
	public var Index: Int;
	public var Density: Float;
	public var InSolution: Bool = false;

	public function new(index, valuable: Valuable) {
		this.Index = index;
		this.Density = valuable.Value / valuable.Weight;
		super(valuable.Id, valuable.Value, valuable.Weight);
	}

	public static function fromValuable(index: Int, valuable: Valuable) return new DenseValuable(index, valuable);
}

enum HSState {
	ComputeUpperBoundU1;
	PerformAForwardStep;
	UpdateTheBestSolution;
	Backtrack;
}
