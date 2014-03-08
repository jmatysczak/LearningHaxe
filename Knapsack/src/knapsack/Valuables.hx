package knapsack;

class Valuables {
	public var Ids(default, null): Array<String>;
	public var Value(default, null): Float;
	public var Weight(default, null): Float;

	public function new(ids, value, weight) {
		this.Ids = ids;
		this.Value = value;
		this.Weight = weight;
	}

	public function toString() {
		return '{ Value => $Value, Weight => $Weight, Ids => $Ids }';
	}
}