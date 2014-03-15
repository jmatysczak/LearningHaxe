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
		// Can't do this because of rounding errors. Need to check value by value with a tolerance.
		//this.shouldBeEquivalentTo(other.toString(), "The Solutions are not equal.");
		var errors = "";

		if (this.Valuables.length != other.Valuables.length)
			errors += createErrorMessage("The number of valuables are different.", Std.string(other.Valuables.length), Std.string(this.Valuables.length));

		var minValuablesLength = Std.int(Math.min(this.Valuables.length, other.Valuables.length));
		for (i in 0...minValuablesLength)
			if (this.Valuables[i].toString() != other.Valuables[i].toString())
				errors += createErrorMessage('The Valuables at index $i are different.', other.Valuables[i].toString(), this.Valuables[i].toString());

		if(this.WeightLimit != other.WeightLimit) 
			errors += createErrorMessage("The weight limits are different.", Std.string(other.WeightLimit), Std.string(this.WeightLimit));

		if(this.Best.isNotCloseTo(other.Best))
			errors += createErrorMessage("The best solutions are different.", other.Best.toString(), this.Best.toString());

		if (this.HeatMap.length != other.HeatMap.length)
			errors += createErrorMessage("The heat map slot counts are different.", Std.string(other.HeatMap.length), Std.string(this.HeatMap.length));

		var minHeatMapLength = Std.int(Math.min(this.HeatMap.length, other.HeatMap.length));
		for (i in 0...minHeatMapLength)
			if (this.HeatMap[i].isNotCloseTo(other.HeatMap[i]))
				errors += createErrorMessage('The heat map Valuables at index $i are different.', other.HeatMap[i].toString(), this.HeatMap[i].toString());

		if (this.EfficientFrontier.length != other.EfficientFrontier.length)
			errors += createErrorMessage("The efficient frontier lengths are different.", Std.string(other.EfficientFrontier.length), Std.string(this.EfficientFrontier.length));

		var minEfficientFrontierLength = Std.int(Math.min(this.EfficientFrontier.length, other.EfficientFrontier.length));
		for (i in 0...minEfficientFrontierLength)
			if (this.EfficientFrontier[i].isNotCloseTo(other.EfficientFrontier[i]))
				errors += createErrorMessage('The efficient frontier Valuables at index $i are different.', other.EfficientFrontier[i].toString(), this.EfficientFrontier[i].toString());

		if (errors.length > 0) throw 'The Solutions are not equal.\n$errors\nExpected solution:\n$other\n\nActual solution:\n$this';
	}

	static function createErrorMessage(message, expected, actual) return '$message\n\tExpected: $expected\n\tActual:   $actual\n\n';
	static function isNotCloseTo(me: Valuables, other: Valuables) {
		var tolerance = 0.000000001;
		if (me.Ids.length != other.Ids.length) return true;
		if (Math.abs(me.Value - other.Value) > tolerance) return true;
		if (Math.abs(me.Weight - other.Weight) > tolerance) return true;
		for (i in 0...me.Ids.length) if (me.Ids[i] != other.Ids[i]) return true;
		return false;
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