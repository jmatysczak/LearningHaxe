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

	public function new() { }

	public function toString() {
		return
			this.Valuables.length + NEWLINE() +
			this.Valuables.join(NEWLINE()) + NEWLINE() +
			this.WeightLimit + NEWLINE() +
			this.Best + NEWLINE() +
			this.HeatMap.join(NEWLINE()) + NEWLINE() +
			this.EfficientFrontier.join(NEWLINE());
	}

	public static function fromString(s: String) {
		var OFFSET_WEIGHT_LIMIT = 1,
			OFFSET_BEST = OFFSET_WEIGHT_LIMIT + 1,
			OFFSET_HEAT_MAP = OFFSET_BEST + 1,
			OFFSET_EFFICIENT_FRONTIER = OFFSET_HEAT_MAP + 20;

		var solution = new Solution(),
			linesSansComments = s.lines().notEmpty().withOutComments(),
			numberOfValuables = Std.parseInt(linesSansComments[0]);
		solution.Valuables = linesSansComments.slice(1, numberOfValuables + OFFSET_WEIGHT_LIMIT).map(Valuable.fromString);
		solution.WeightLimit = Std.parseFloat(linesSansComments[numberOfValuables + OFFSET_WEIGHT_LIMIT]);
		solution.Best = linesSansComments[numberOfValuables + OFFSET_BEST].toValuables();
		solution.HeatMap = linesSansComments.slice(numberOfValuables + OFFSET_HEAT_MAP, numberOfValuables + OFFSET_EFFICIENT_FRONTIER).map(toValuables);
		solution.EfficientFrontier = linesSansComments.slice(numberOfValuables + OFFSET_EFFICIENT_FRONTIER).map(toValuables);

		var actual = solution.toString(),
			expected = linesSansComments.join(NEWLINE());
		for (i in 0...expected.length)
			if (actual.charCodeAt(i) != expected.charCodeAt(i))
				throw
					'The solution string was not parsed correctly. Different at position $i.\n' +
					'Expected: ${expected.charAt(i)}(${expected.charCodeAt(i)})\n' +
					'Actual:   ${actual.charAt(i)}(${actual.charCodeAt(i)})\n' +
					solution;

		return solution;
	}

	static function lines(text: String) return text.split(text.indexOf("\r") == -1 ? "\n" : "\r\n");
	static function notEmpty(lines: Array<String>) return lines.filter(function(line) return line.ltrim().length > 0);
	static function withOutComments(lines: Array<String>) return lines.filter(function(line) return !line.ltrim().startsWith("#"));
	static function toValuables(line: String) {
		var valueWeightIds = line.split("\t");
		return new Valuables(valueWeightIds.slice(2), Std.parseFloat(valueWeightIds[0]), Std.parseFloat(valueWeightIds[1]));
	}
}