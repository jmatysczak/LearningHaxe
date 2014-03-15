package knapsack;

using knapsack.Valuable;

class ProblemFactory {
	public static function createProblems(size) {
		var start = 1,
			range = 99,
			problems = new Array<Problem>();

		problems.push(new Problem(
			'Uncorrelated. Value and weight uniformly random in [$start, ${start + range}].',
			[for (i in 0...size) new Valuable(Std.string(i), start + (Math.random() * range), start + (Math.random() * range))]
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