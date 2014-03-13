package knapsack;

using Lambda;

class Valuable {
	public var Id: String;
	public var Value: Float;
	public var Weight: Float;

	public function new(id, value, weight) {
		this.Id = id;
		this.Value = value;
		this.Weight = weight;
	}

	public function toString() {
		return '$Id\t$Value\t$Weight';
	}

	public static function fromString(s: String) {
		var idValueWeight = s.split("\t");
		return new Valuable(idValueWeight[0], Std.parseFloat(idValueWeight[1]), Std.parseFloat(idValueWeight[2]));
	}

	public static function calculateTotalWeight(valuables: Iterable<Valuable>) {
		return valuables.fold(function(valuable, weight) return valuable.Weight + weight, 0);
	}
}