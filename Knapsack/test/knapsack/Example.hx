package knapsack;

import knapsack.Valuable;

using StringTools;
using knapsack.Example;

class Example {
	public var Valuables(default, null): Array<Valuable>;
	public var WeightLimit(default, null): Float;
	public var SolutionIds: Array<String>;
	public var SolutionValue: Float;
	public var SolutionWeight: Float;

	public function new(example: String) {
		var lines = example.lines().withOutComments();
		var numberOfValuables = Std.parseInt(lines[0]);
		this.Valuables = lines.slice(1, numberOfValuables + 1).map(function(line) {
			var idValueWeight = line.split("\t");
			return new Valuable(idValueWeight[0], Std.parseFloat(idValueWeight[1]), Std.parseFloat(idValueWeight[2]));
		});

		this.WeightLimit = Std.parseFloat(lines[numberOfValuables + 1]);

		var solution = lines[numberOfValuables + 2].split("\t");
		this.SolutionValue = Std.parseFloat(solution[0]);
		this.SolutionWeight = Std.parseFloat(solution[1]);
		this.SolutionIds = solution.slice(2);
	}

	static function lines(text: String) return text.split(text.indexOf("\r") == -1 ? "\n" : "\r\n");
	static function withOutComments(lines: Array<String>) return lines.filter(function(line) return !line.ltrim().startsWith("#"));
}