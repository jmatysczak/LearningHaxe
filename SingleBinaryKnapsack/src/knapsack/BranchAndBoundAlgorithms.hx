package knapsack;

import haxe.ds.Vector.Vector;

using Lambda;
using knapsack.BranchAndBoundAlgorithms;
using knapsack.FloatTools;
using knapsack.ArrayTools;

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
			sortedValuables = valuables.map(DenseValuable.fromValuable).sortByDensityDesc(),
			currentState: HSState = ComputeUpperBoundU1;

		while (true) {
			if(currentState == ComputeUpperBoundU1) {
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
			}
			if(currentState == PerformAForwardStep) {
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
			}
			if(currentState == UpdateTheBestSolution) {
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
			}
			if(currentState == Backtrack) {
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

		bestValue = 0;
		var bestWeight: Float = 0;
		for (sortedValuable in sortedValuables)
			if (sortedValuable.InSolution) {
				bestValue += sortedValuable.Value;
				bestWeight += sortedValuable.Weight;
			}

		return new Valuables(sortedValuables.sortByIndexAsc().getIdsInSolution().toStrVector(), bestValue, bestWeight);
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

private class DenseValuable extends Valuable {
	public var Density: Float;
	public var InSolution: Bool = false;

	public function new(valuable: Valuable) {
		this.Density = valuable.Value / valuable.Weight;
		super(valuable.Id, valuable.Index, valuable.Value, valuable.Weight);
	}

	public static function fromValuable(valuable: Valuable) return new DenseValuable(valuable);
}

private enum HSState {
	ComputeUpperBoundU1;
	PerformAForwardStep;
	UpdateTheBestSolution;
	Backtrack;
}
