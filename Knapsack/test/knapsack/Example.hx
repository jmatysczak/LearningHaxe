package knapsack;

import knapsack.Valuable;

using StringTools;

class Example {
	public var Valuables(default, null): Array<Valuable>;

	public function new(example: String) {
		var lines = example.split(example.indexOf("\r") == -1 ? "\n" : "\r\n").filter(function(line) return !line.ltrim().startsWith("#"));
		for (line in lines) Sys.println(line);
	}
}