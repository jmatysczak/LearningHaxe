package knapsack;

import haxe.ds.Vector;

using knapsack.ArrayTools;
using knapsack.VectorTools;

class Valuables {
	public var Ids: BitMap;
	public var Value: Float;
	public var Weight: Float;

	public function new(ids, value, weight) {
		this.Ids = ids;
		this.Value = value;
		this.Weight = weight;
	}

	public function toString() {
		return '$Value\t$Weight\t$Ids';
	}

	public static function fromString(s: String) {
		var value = Std.parseFloat(s),
			weightStart = s.indexOf("\t") + 1,
			weightFinish = s.indexOf("\t", weightStart),
			weight = Std.parseFloat(s.substring(weightStart, weightFinish)),
			ids = new BitMap(s.length - weightFinish - 1),
			idsStart = weightFinish + 1;
		while ((weightFinish = s.indexOf("1", weightFinish + 1)) != -1) ids.set(weightFinish - idsStart);
		return new Valuables(ids, value, weight);
	}
}