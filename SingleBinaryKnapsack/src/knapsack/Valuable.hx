package knapsack;

using Lambda;

class Valuable {
	public var Id: String;
	public var Index: Int;
	public var Value: Float;
	public var Weight: Float;

	public function new(id, index, value, weight) {
		this.Id = id;
		this.Index = index;
		this.Value = value;
		this.Weight = weight;
	}

	public function toString() {
		return '$Id\t$Value\t$Weight';
	}

	public static function fromString(i:Int, s: String) {
		var idValueWeight = s.split("\t");
		return new Valuable(idValueWeight[0], i, Std.parseFloat(idValueWeight[1]), Std.parseFloat(idValueWeight[2]));
	}

	public static function allIds(valuables: Iterable<Valuable>) {
		return [for(valuable in valuables) valuable.Id];
	}

	public static function calculateTotalValue(valuables: Iterable<Valuable>) {
		return valuables.fold(function(valuable, value) return valuable.Value + value, 0);
	}

	public static function calculateTotalWeight(valuables: Iterable<Valuable>) {
		return valuables.fold(function(valuable, weight) return valuable.Weight + weight, 0);
	}
}