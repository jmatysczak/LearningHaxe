package knapsack;

using knapsack.Valuable;

class ProblemFactory {
	/**
	 * Based on:
	 * Where are the hard knapsack problems?
	 * David Pisinger
	 * AND
	 * Chapter 2.10
	 * "Knapsack Problems: Algorithms and Computer Implementations"
	 * http://www.or.deis.unibo.it/knapsack.html
	 */
	public static function createProblems(sizes: Array<Int>) {
		var lowerBound = 1,
			upperBound = 100,
			correlation = upperBound / 10,
			boundsRange = upperBound - lowerBound,
			almostStrongCorrelation = upperBound / 500,
			problems = new Array<Problem>();

		for(size in sizes) {
			problems.push(new Problem(
				"Uncorrelated", 'Uncorrelated. Values and weights are distributed in [$lowerBound, $upperBound].',
				[for (i in 0...size) new Valuable(Std.string(i), i, lowerBound + (Math.random() * boundsRange), lowerBound + (Math.random() * boundsRange))]
			));

			problems.push(new Problem(
				"WeaklyCorrelated", 'Weakly correlated. Weights are distributed in [$lowerBound, $upperBound], Value in [Weight - $correlation, Weight + $correlation].',
				[
					for (i in 0...size) {
						var value: Float = 0,
							weight: Float = 0;
						do {
							weight = lowerBound + (Math.random() * boundsRange);
							value = weight - correlation + (Math.random() * correlation * 2);
						} while (value < 1);
						new Valuable(Std.string(i), i, value, weight);
					}
				]
			));

			problems.push(new Problem(
				"StronglyCorrelated", 'Strongly correlated. Weights are distributed in [$lowerBound, $upperBound], Value = Weight + $correlation.',
				[
					for (i in 0...size) {
						var weight = lowerBound + (Math.random() * boundsRange);
						new Valuable(Std.string(i), i, weight + correlation, weight);
					}
				]
			));

			problems.push(new Problem(
				"InverseStronglyCorrelated", 'Inverse strongly correlated. Values are distributed in [$lowerBound, $upperBound], Weight = Value + $correlation.',
				[
					for (i in 0...size) {
						var value = lowerBound + (Math.random() * boundsRange);
						new Valuable(Std.string(i), i, value, value + correlation);
					}
				]
			));

			problems.push(new Problem(
				"AlmostStronglyCorrelated", 'Almost strongly correlated. Weights are distributed in [$lowerBound, $upperBound], Value in [Weight + $correlation - $almostStrongCorrelation, Weight + $correlation + $almostStrongCorrelation].',
				[
					for (i in 0...size) {
						var value: Float = 0,
							weight: Float = 0;
						do {
							weight = lowerBound + (Math.random() * boundsRange);
							value = weight + correlation - almostStrongCorrelation + (Math.random() * almostStrongCorrelation * 2);
						} while (value < 1);
						new Valuable(Std.string(i), i, value, weight);
					}
				]
			));

			problems.push(new Problem(
				"SubsetSum", 'Subset sum. Weights are distributed in [$lowerBound, $upperBound], Value = Weight.',
				[
					for (i in 0...size) {
						var weight = lowerBound + (Math.random() * boundsRange);
						new Valuable(Std.string(i), i, weight, weight);
					}
				]
			));

			// TODO: Uncorrelated instances with similar weights: weights wj are distributed in [100000, 100100] and the profits pj in [1, 1000].
		}

		return problems;
	}
}

class Problem {
	public var Title: String;
	public var Descr: String;
	public var Valuables: Array<Valuable>;
	public var WeightLimit: Float;

	public function new(title, descr, valuables) {
		this.Title = title;
		this.Descr = descr;
		this.Valuables = valuables;
		this.WeightLimit = this.Valuables.calculateTotalWeight() / 2;
	}
}