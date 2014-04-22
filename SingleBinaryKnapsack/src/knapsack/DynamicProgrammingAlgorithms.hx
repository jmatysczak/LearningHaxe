package knapsack;

import haxe.ds.Vector.Vector;

using knapsack.ArrayTools;
using knapsack.DynamicProgrammingAlgorithms;
using knapsack.FloatTools;

class DynamicProgrammingAlgorithms {
	public static function findEfficientFrontierArray(valuables: Array<Valuable>) {
		var current = new Array<EFValuables>(),
			previous = new Array<EFValuables>(),
			sortedValuables = valuables.copy().sortByWeightAscValueDesc(),
			firstSortedValuable = sortedValuables[0];

		current.push(new EFValuables(firstSortedValuable.Index, null, firstSortedValuable.Value, firstSortedValuable.Weight));
		for (i in 1...sortedValuables.length) {
			for (j in 0...current.length) previous[j] = current[j];

			var currentSortedValuable = sortedValuables[i],
				start = current.insertEF(0, currentSortedValuable.Index, null, currentSortedValuable.Value, currentSortedValuable.Weight);

			for (previousSortedValuable in previous) {
				var value = previousSortedValuable.Value + currentSortedValuable.Value;
				var weight = previousSortedValuable.Weight + currentSortedValuable.Weight;
				start = current.insertEF(start, currentSortedValuable.Index, previousSortedValuable.SolutionIndexes, value, weight);
			}
		}

		return current.map(function(efValuables) return efValuables.toValuables(valuables));
	}

	static function insertEF(current: Array<EFValuables>, i, id, ids, value, weight) {
		while (i < current.length && current[i].Weight <= weight) i++;
		if (value <= current[i - 1].Value) return i;
		current.insert(i, new EFValuables(id, ids, value, weight));
		var end = ++i;
		while (end < current.length && current[end].Value <= value) end++;
		current.splice(i, end - i);
		return i;
	}

	static function sortByWeightAscValueDesc(valuables: Array<Valuable>) {
		valuables.sort(function(dv1, dv2) return dv1.Weight.compareTo(dv2.Weight, dv2.Value.compareTo(dv1.Value)));
		return valuables;
	}

	public static function findEfficientFrontierLinkedListAndArray(valuables: Array<Valuable>) {
		var sortedValuables = valuables.copy().sortByWeightAscValueDesc(),
			firstEFValuables = new EFValuablesNodeWithArray(sortedValuables[0].Index, null, sortedValuables[0].Value, sortedValuables[0].Weight);

		for (i in 1...sortedValuables.length) {
			var previous = firstEFValuables.toArray(),
				currentSortedValuable = sortedValuables[i],
				startEFValuables = firstEFValuables.insert(currentSortedValuable.Index, null, currentSortedValuable.Value, currentSortedValuable.Weight);

			for (previousSortedValuable in previous) {
				var value = previousSortedValuable.Value + currentSortedValuable.Value;
				var weight = previousSortedValuable.Weight + currentSortedValuable.Weight;
				startEFValuables = startEFValuables.insert(currentSortedValuable.Index, previousSortedValuable.SolutionIndexes, value, weight);
			}
		}

		return firstEFValuables.toArray().map(function(efValuables) return efValuables.toValuables(valuables));
	}

	public static function findEfficientFrontierLinkedListAndBitMap(valuables: Array<Valuable>) {
		var emptyBitMap = new BitMap(valuables.length),
			sortedValuables = valuables.copy().sortByWeightAscValueDesc(),
			firstEFValuables = new EFValuablesNodeWithBitMap(sortedValuables[0].Index, emptyBitMap, sortedValuables[0].Value, sortedValuables[0].Weight);

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

		//return firstEFValuables.toArray().map(function(efValuables) return efValuables.toValuables(valuables));
		return firstEFValuables.toArrayOfValuables(valuables);
	}
}

private class EFValuablesBase {
	public var Value: Float;
	public var Weight: Float;

	public function new(value, weight) {
		this.Value = value;
		this.Weight = weight;
	}
}

private class EFValuables extends EFValuablesBase {
	public var SolutionIndexes: Array<Int>;

	public function new(index, indexes: Array<Int>, value, weight) {
		super(value, weight);
		this.SolutionIndexes = [index];
		if(indexes != null) for (i in indexes) this.SolutionIndexes.push(i);
	}

	public function toValuables(valuables: Array<Valuable>) {
		this.SolutionIndexes.sort(function(id1, id2) return id1 - id2);
		return new Valuables([for(i in this.SolutionIndexes) valuables[i].Id], this.Value, this.Weight);
	}
}

private class EFValuablesNodeWithArray extends EFValuables {
	public var Next: EFValuablesNodeWithArray;

	public function new(index, indexes: Array<Int>, value, weight, ?next) {
		super(index, indexes, value, weight);
		this.Next = next;
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

	public function insert(id, ids, value, weight) {
		var current = this;
		while (current.Next != null && current.Next.Weight < weight) current = current.Next;

		if (value <= current.Value) return current;
		
		var next = current.Next;
		if (next == null) {
			current.Next = new EFValuablesNodeWithArray(id, ids, value, weight);
			return current.Next;
		}

		if (weight == next.Weight && value <= next.Value) return next;
		
		while (next != null && next.Value <= value) next = next.Next;

		current.Next = new EFValuablesNodeWithArray(id, ids, value, weight, next);
		return current.Next;
	}
}

private class EFValuablesNodeWithBitMap extends EFValuablesBase {
	public var Next: EFValuablesNodeWithBitMap;
	public var SolutionIndexes: BitMap;

	public function new(index, indexes: BitMap, value, weight, ?next) {
		super(value, weight);
		this.Next = next;
		this.SolutionIndexes = indexes.clone();
		this.SolutionIndexes.set(index);
	}

	public function toValuables(valuables: Array<Valuable>) {
		var v = new Vector(this.SolutionIndexes.count);
		this.SolutionIndexes.each(function(i, bit) v[i] = valuables[bit].Id);
		return new Valuables(ArrayTools.fromVector(v), this.Value, this.Weight);
	}

	public function toArray() {
		var valuable = this,
			valuables = new Array<EFValuablesNodeWithBitMap>();
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
			var ids = new Vector(valuable.SolutionIndexes.count);
			valuable.SolutionIndexes.each(function(i, bit) ids[i] = idsByIndex[bit]);
			valuabless.push(new Valuables(ArrayTools.fromVector(ids), valuable.Value, valuable.Weight));
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
			current.Next = new EFValuablesNodeWithBitMap(id, ids, value, weight);
			return current.Next;
		}

		if (weight == next.Weight && value <= next.Value) return next;
		
		while (next != null && next.Value <= value) next = next.Next;

		current.Next = new EFValuablesNodeWithBitMap(id, ids, value, weight, next);
		return current.Next;
	}
}