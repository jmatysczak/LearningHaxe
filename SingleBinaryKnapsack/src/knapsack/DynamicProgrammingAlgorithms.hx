package knapsack;

import haxe.ds.Vector.Vector;

using knapsack.ArrayTools;
using knapsack.DynamicProgrammingAlgorithms;
using knapsack.FloatTools;

class DynamicProgrammingAlgorithms {
	public static function findEfficientFrontier(valuables: Array<Valuable>) {
		var emptyBitMap = new BitMap(valuables.length),
			sortedValuables = valuables.copy().sortByWeightAscValueDesc(),
			firstEFValuables = new EFValuables(sortedValuables[0].Index, emptyBitMap, sortedValuables[0].Value, sortedValuables[0].Weight);

		for (i in 1...sortedValuables.length) {
			var previous = firstEFValuables.toArray(),
				currentSortedValuable = sortedValuables[i],
				startEFValuables = firstEFValuables.insert(currentSortedValuable.Index, emptyBitMap, currentSortedValuable.Value, currentSortedValuable.Weight);

			for (previousSortedValuable in previous) {
				var value = previousSortedValuable.Value + currentSortedValuable.Value;
				var weight = previousSortedValuable.Weight + currentSortedValuable.Weight;
				startEFValuables = startEFValuables.insert(currentSortedValuable.Index, previousSortedValuable.SolutionIndexes, value, weight);
			}
		}

		return firstEFValuables.toArrayOfValuables(valuables);
	}

	static function sortByWeightAscValueDesc(valuables: Array<Valuable>) {
		valuables.sort(function(dv1, dv2) return dv1.Weight.compareTo(dv2.Weight, dv2.Value.compareTo(dv1.Value)));
		return valuables;
	}
}

private class EFValuables {
	public var Next: EFValuables;
	public var Value: Float;
	public var Weight: Float;
	public var SolutionIndexes: BitMap;

	public function new(index, indexes: BitMap, value, weight, ?next) {
		this.Next = next;
		this.Value = value;
		this.Weight = weight;
		this.SolutionIndexes = indexes.clone();
		this.SolutionIndexes.set(index);
	}

	public function toArray() {
		var valuable = this,
			valuables = new Array<EFValuables>();
		while (valuable != null) {
			valuables.push(valuable);
			valuable = valuable.Next;
		}
		return valuables;
	}

	public function toArrayOfValuables(valuables: Array<Valuable>) {
		var valuable = this,
			valuabless = new Array<Valuables>(),
			idsByIndex = new Vector(valuables.length);
		for (i in 0...valuables.length) idsByIndex[i] = valuables[i].Id;
		while (valuable != null) {
			valuabless.push(new Valuables(valuable.SolutionIndexes.toMappedVector(idsByIndex), valuable.Value, valuable.Weight));
			valuable = valuable.Next;
		}
		return valuabless;
	}

	public function insert(id, ids, value, weight) {
		var current = this;
		while (current.Next != null && current.Next.Weight < weight) current = current.Next;

		if (value <= current.Value) return current;
		
		var next = current.Next;
		if (next == null) {
			current.Next = new EFValuables(id, ids, value, weight);
			return current.Next;
		}

		if (weight == next.Weight && value <= next.Value) return next;
		
		while (next != null && next.Value <= value) next = next.Next;

		current.Next = new EFValuables(id, ids, value, weight, next);
		return current.Next;
	}
}