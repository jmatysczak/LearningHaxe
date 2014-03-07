package knapsack;

class Valuable {
	public var Id(default, null): String;
	public var Value(default, null): Float;
	public var Weight(default, null): Float;

	public function new(id, value, weight) {
		this.Id = id;
		this.Value = value;
		this.Weight = weight;
	}
}