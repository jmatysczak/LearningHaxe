package knapsack;

import haxe.ds.Vector.Vector;

using knapsack.BBAndDP;

class BBAndDP {
	var findByBest: Array<Valuable> -> Float -> Valuables;
	
	public function new(findByBest) {
		this.findByBest = findByBest;
	}

	public function find(valuables: Array<Valuable>, weightLimit: Float) {
		var best = this.findByBest(valuables, weightLimit);
		return new Solution(valuables, weightLimit, best);
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
			sortedValuables = valuables.map(DenseValuable.fromValuable).sortByDensityDesc(),
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
					} while (jToRWeight <= currentResidualWeight);
					var u = (jToRValue - sortedValuables[r].Value) + (currentResidualWeight - jToRWeight - sortedValuables[r].Weight) * sortedValuables[r].Density;
					currentState = bestValue >= currentValue + u ? Backtrack : PerformAForwardStep;
				case PerformAForwardStep:
					while (sortedValuables[j].Weight <= currentResidualWeight) {
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

		return new Valuables(sortedValuables.getIdsInSolution(bestInSolution), bestValue, bestWeight);
	}

	static function getIdsInSolution(valuables: Array<DenseValuable>, inSolution: Vector<Bool>) {
		return [for (i in 0...valuables.length) if (inSolution[i]) valuables[i].Id];
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
}

class DenseValuable extends Valuable {
	public var Density: Float;

	public function new(valuable: Valuable) {
		super(valuable.Id, valuable.Value, valuable.Weight);
		this.Density = this.Value / this.Weight;
	}

	public override function toString() {
		return '$Id; $Value; $Weight; $Density\r\n';
	}

	public static function fromValuable(valuable: Valuable) return new DenseValuable(valuable);
}

enum HSState {
	ComputeUpperBoundU1;
	PerformAForwardStep;
	UpdateTheBestSolution;
	Backtrack;
}
