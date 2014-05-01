package knapsack;

import haxe.ds.Vector.Vector;

using knapsack.ArrayTools;
using knapsack.DynamicProgrammingAlgorithms;
using knapsack.FloatTools;

class DynamicProgrammingAlgorithms {
	public static function findEfficientFrontier(valuables: Array<Valuable>) {
		var cache = new EFValuablesCache(),
			emptyBitMap = new BitMap(valuables.length),
			sortedValuables = valuables.copy().sortByDensityDesc(),
			firstEFValuables = new EFValuables(sortedValuables[0].Index, emptyBitMap, sortedValuables[0].Value, sortedValuables[0].Weight, cache);

		for (i in 1...sortedValuables.length) {
			var previous = firstEFValuables.toArray(),
				currentSortedValuable = sortedValuables[i],
				startEFValuables = firstEFValuables.insert(currentSortedValuable.Index, emptyBitMap, currentSortedValuable.Value, currentSortedValuable.Weight);

			for (previousSortedValuable in previous) {
				var value = previousSortedValuable.Value + currentSortedValuable.Value;
				var weight = previousSortedValuable.Weight + currentSortedValuable.Weight;
				startEFValuables = startEFValuables.insert(currentSortedValuable.Index, previousSortedValuable.SolutionIndexes, value, weight);
			}

			cache.compact();
		}

		return firstEFValuables.toArrayOfValuables();
	}

	static function sortByDensityDesc(valuables: Array<Valuable>) {
		valuables.sort(function(dv1, dv2) return (dv2.Value/dv2.Weight).compareTo(dv1.Value/dv1.Weight));
		var minIndex = 0;
		for (i in 1...valuables.length) if (valuables[i].Weight < valuables[minIndex].Weight) minIndex = i;
		valuables.insert(0, valuables.splice(minIndex, 1)[0]);
		return valuables;
	}
}

private class EFValuables {
	public var Next: EFValuables;
	public var Value: Float;
	public var Weight: Float;
	public var SolutionIndexes: BitMap;

	private var Cache: EFValuablesCache;

	public function new(index, indexes: BitMap, value, weight, cache, ?next) {
		this.Next = next;
		this.Cache = cache;
		this.Value = value;
		this.Weight = weight;
		this.SolutionIndexes = indexes.clone();
		this.SolutionIndexes.set(index);
	}

	private var cachedValuables: Array<EFValuables>;
	public function toArray() {
		if (this.cachedValuables == null) this.cachedValuables = new Array<EFValuables>();
		var i = 0,
			valuable = this,
			valuables = this.cachedValuables;
		while (valuable != null) {
			valuables[i++] = valuable;
			valuable = valuable.Next;
		}
		return valuables;
	}

	public function toArrayOfValuables() {
		var valuable = this,
			valuables = new Array<Valuables>();
		while (valuable != null) {
			valuables.push(new Valuables(valuable.SolutionIndexes, valuable.Value, valuable.Weight));
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
			current.Next = this.Cache.get(id, ids, value, weight);
			return current.Next;
		}

		if (weight == next.Weight && value <= next.Value) return next;
		
		while (next != null && next.Value <= value) next = this.Cache.addAndReturnNext(next);

		current.Next = this.Cache.get(id, ids, value, weight, next);
		return current.Next;
	}
}

private class EFValuablesCache {
	var First: EFValuables = null;
	var Last: EFValuables = null;

	var FirstHot: EFValuables = null;
	var LastHot: EFValuables = null;

	public function new() { }

	public function addAndReturnNext(valuable: EFValuables) {
		var next = valuable.Next;
		if (this.FirstHot == null) this.FirstHot = valuable;
		if (this.LastHot != null) this.LastHot.Next = valuable;
		this.LastHot = valuable;
		return next;
	}

	public function get(index, indexes, value, weight, ?next) {
		var valuable = this.First;
		if (valuable == null) return new EFValuables(index, indexes, value, weight, this, next);
		this.First = valuable.Next;
		valuable.Next = next;
		valuable.Value = value;
		valuable.Weight = weight;
		indexes.clone(valuable.SolutionIndexes);
		valuable.SolutionIndexes.set(index);
		return valuable;
	}

	public function compact() {
		if (this.FirstHot == null) return;
		if (this.First == null) {
			this.First = this.FirstHot;
		} else {
			this.Last.Next = this.FirstHot;
		}
		this.Last = this.LastHot;
		this.Last.Next = null;
		this.FirstHot = null;
		this.LastHot = null;
	}
}