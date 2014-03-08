package knapsack;

import knapsack.Solution;

using StringTools;
using knapsack.Example;

class Example extends Solution {
	public function new(example: String) {
		var lines = example.lines().withOutComments();
		var numberOfValuables = Std.parseInt(lines[0]);
		this.Valuables = lines.slice(1, numberOfValuables + 1).map(function(line) {
			var idValueWeight = line.split("\t");
			return new Valuable(idValueWeight[0], Std.parseFloat(idValueWeight[1]), Std.parseFloat(idValueWeight[2]));
		});

		this.WeightLimit = Std.parseFloat(lines[numberOfValuables + 1]);

		var best = lines[numberOfValuables + 2].split("\t");
		this.Best = new Valuables(best.slice(2), Std.parseFloat(best[0]), Std.parseFloat(best[1]));
	}

	static function lines(text: String) return text.split(text.indexOf("\r") == -1 ? "\n" : "\r\n");
	static function withOutComments(lines: Array<String>) return lines.filter(function(line) return !line.ltrim().startsWith("#"));
}