package knapsack;

using knapsack.Valuable;

class ProblemFactory {
	/**
	 * Based on:
	 * Chapter 2.10
	 * "Knapsack Problems: Algorithms and Computer Implementations"
	 * http://www.or.deis.unibo.it/knapsack.html
	 * AND
	 * Where are the hard knapsack problems?
	 * David Pisinger
	 */
	public static function createProblems(size) {
		var lowerBound = 1,
			upperBound = 100,
			correlation = upperBound / 10,
			boundsRange = upperBound - lowerBound,
			problems = new Array<Problem>();

		problems.push(new Problem(
			"Uncorrelated", 'Uncorrelated. Value and weight uniformly random in [$lowerBound, $upperBound].',
			[for (i in 0...size) new Valuable(Std.string(i), lowerBound + (Math.random() * boundsRange), lowerBound + (Math.random() * boundsRange))]
		));

		problems.push(new Problem(
			"WeaklyCorrelated", 'Weakly correlated. Weight uniformly random in [$lowerBound, $upperBound], Value in [Weight - $correlation, Weight + $correlation].',
			[
				for (i in 0...size) {
					var value: Float = 0,
						weight: Float = 0;
					do {
						weight = lowerBound + (Math.random() * boundsRange);
						value = weight - correlation + (Math.random() * correlation * 2);
					} while (value < 1);
					new Valuable(Std.string(i), value, weight);
				}
			]
		));

		problems.push(new Problem(
			"StronglyCorrelated", 'Strongly correlated. Weight uniformly random in [$lowerBound, $upperBound], Value = Weight + $correlation.',
			[
				for (i in 0...size) {
					var weight = lowerBound + (Math.random() * boundsRange);
					new Valuable(Std.string(i), weight + correlation, weight);
				}
			]
		));

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