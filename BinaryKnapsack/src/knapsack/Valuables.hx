package knapsack;

class Valuables {
	public var Ids: Array<String>;
	public var Value: Float;
	public var Weight: Float;

	public function new(ids, value, weight) {
		this.Ids = ids;
		this.Value = value;
		this.Weight = weight;
	}

	public function toString() {
		return '$Value\t$Weight\t${Ids.join("\t")}';
	}

	public static function fromString(s: String) {
		var valueWeightIds = s.split("\t");
		return new Valuables(valueWeightIds.slice(2), Std.parseFloat(valueWeightIds[0]), Std.parseFloat(valueWeightIds[1]));
	}
}