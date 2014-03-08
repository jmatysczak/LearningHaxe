package knapsack;

class Valuable {
	public var Id : String;
	public var Value : Float;
	public var Weight : Float;

	public function new(id, value, weight) {
		this.Id = id;
		this.Value = value;
		this.Weight = weight;
	}

	public function toString() {
		return '$Id\t$Value\t$Weight';
	}
}