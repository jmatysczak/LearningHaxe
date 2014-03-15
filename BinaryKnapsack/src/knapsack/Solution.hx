package knapsack;

using StringTools;
using knapsack.Solution;

class Solution {
	macro static function NEWLINE() return macro "\n";

	public var Valuables: Array<Valuable>;
	public var WeightLimit: Float;
	public var Best: Valuables;
	public var HeatMap: Array<Valuables>;
	public var EfficientFrontier: Array<Valuables>;

	public function new(?valuables, ?weightLimit, ?best, ?heatMap, ?efficientFrontier) {
		this.Valuables = valuables;
		this.WeightLimit = weightLimit;
		this.Best = best;
		this.HeatMap = heatMap;
		this.EfficientFrontier = efficientFrontier;
	}

	public function toString(): String {
		var s = "";

		s += (this.Valuables == null ? 0 : this.Valuables.length) + ", " + (this.HeatMap == null ? 0 : this.HeatMap.length) + NEWLINE();
		if (this.Valuables != null) s += this.Valuables.join(NEWLINE()) + NEWLINE();
		s += Std.string(this.WeightLimit) + NEWLINE() + this.Best + NEWLINE();
		if (this.HeatMap != null) s += this.HeatMap.join(NEWLINE()) + NEWLINE();
		if (this.EfficientFrontier!=null) s+=this.EfficientFrontier.join(NEWLINE());

		return s;
	}

	public static function fromString(s: String) {
		var solution = new Solution(),
			linesSansComments = s.lines().notEmpty().withOutComments(),
			numberOfValuables = Std.parseInt(linesSansComments[0].split(",")[0]),
			numberOfHeatMapSlots = Std.parseInt(linesSansComments[0].split(",")[1]),
		    OFFSET_WEIGHT_LIMIT = 1,
			OFFSET_BEST = OFFSET_WEIGHT_LIMIT + 1,
			OFFSET_HEAT_MAP = OFFSET_BEST + 1,
			OFFSET_EFFICIENT_FRONTIER = OFFSET_HEAT_MAP + numberOfHeatMapSlots;
		solution.Valuables = linesSansComments.slice(1, numberOfValuables + OFFSET_WEIGHT_LIMIT).map(Valuable.fromString);
		solution.WeightLimit = Std.parseFloat(linesSansComments[numberOfValuables + OFFSET_WEIGHT_LIMIT]);
		solution.Best = Valuables.fromString(linesSansComments[numberOfValuables + OFFSET_BEST]);
		solution.HeatMap = linesSansComments.slice(numberOfValuables + OFFSET_HEAT_MAP, numberOfValuables + OFFSET_EFFICIENT_FRONTIER).map(Valuables.fromString);
		solution.EfficientFrontier = linesSansComments.slice(numberOfValuables + OFFSET_EFFICIENT_FRONTIER).map(Valuables.fromString);

		solution.shouldBeEquivalentTo(linesSansComments.join(NEWLINE()), "The input was not parsed correctly.");

		return solution;
	}

	public function shouldEqual(other: Solution) {
		this.shouldBeEquivalentTo(other.toString(), "The Solutions are not equal.");
	}

	function shouldBeEquivalentTo(expected: String, message: String) {
		var errors = "",
			actual = this.toString(),
			minLength = Std.int(Math.min(actual.length, expected.length));

		if (actual.length != expected.length)
			errors +=
				'\nThe lengths are different.\n' +
				'\tExpected: ${expected.length}\n' +
				'\tActual:   ${actual.length}\n';

		for (i in 0...minLength) {
			if (actual.charCodeAt(i) != expected.charCodeAt(i)) {
				errors +=
					'\nThe content is different at position $i.\n' +
					'\tExpected: ${expected.charAt(i)}(${expected.charCodeAt(i)})\n' +
					'\tActual:   ${actual.charAt(i)}(${actual.charCodeAt(i)})\n';
				break;
			}
		}

		if (errors.length > 0) throw '$message\n$errors\nExpected solution:\n$expected\n\nActual solution:\n$this';
	}

	static function lines(text: String) return text.split(text.indexOf("\r") == -1 ? "\n" : "\r\n");
	static function notEmpty(lines: Array<String>) return lines.filter(function(line) return line.ltrim().length > 0);
	static function withOutComments(lines: Array<String>) return lines.filter(function(line) return !line.ltrim().startsWith("#"));
}