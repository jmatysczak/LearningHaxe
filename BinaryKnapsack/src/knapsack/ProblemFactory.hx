package knapsack;

using knapsack.Valuable;

class ProblemFactory {
	/**
	 * Based on:
	 * Chapter 2.10
	 * "Knapsack Problems: Algorithms and Computer Implementations"
	 * http://www.or.deis.unibo.it/knapsack.html
	 */
	public static function createProblems(size) {
		var start = 1,
			range = 99,
			problems = new Array<Problem>(),
			correlation = 10;

		problems.push(new Problem(
			'Uncorrelated. Value and weight uniformly random in [$start, ${start + range}].',
			[for (i in 0...size) new Valuable(Std.string(i), start + (Math.random() * range), start + (Math.random() * range))]
		));

		problems.push(new Problem(
			'Weakly correlated. Weight uniformly random in [$start, ${start + range}], Value in [Weight - $correlation, Weight + $correlation].',
			[
				for (i in 0...size) {
					var value: Float = 0,
						weight: Float = 0;
					do {
						weight = start + (Math.random() * range);
						value = weight - correlation + (Math.random() * correlation * 2);
					} while (value < 1);
					new Valuable(Std.string(i), value, weight);
				}
			]
		));

		problems.push(new Problem(
			'Strongly correlated. Weight uniformly random in [$start, ${start + range}], Value = Weight + $correlation.',
			[
				for (i in 0...size) {
					var weight = start + (Math.random() * range);
					new Valuable(Std.string(i), weight + correlation, weight);
				}
			]
		));

		return problems;
	}
}

class Problem {
	public var Descr: String;
	public var Valuables: Array<Valuable>;
	public var WeightLimit: Float;

	public function new(descr, valuables) {
		this.Descr = descr;
		this.Valuables = valuables;
		this.WeightLimit = this.Valuables.calculateTotalWeight() / 2;
	}
}