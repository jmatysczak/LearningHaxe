package knapsack;

using knapsack.DynamicProgrammingAlgorithms;
using knapsack.FloatTools;

class DynamicProgrammingAlgorithms {
	public static function findEfficientFrontierArray(valuables: Array<Valuable>) {
		var current = new Array<EFValuables>(),
			previous = new Array<EFValuables>(),
			idIndexes = new Map<String, Int>(),
			sortedValuables = valuables.copy().sortByWeightAscValueDesc(),
			firstSortedValuable = sortedValuables[0];

		for (i in 0...valuables.length) idIndexes[valuables[i].Id] = i;

		current.push(new EFValuables(idIndexes[firstSortedValuable.Id], null, firstSortedValuable.Value, firstSortedValuable.Weight));
		for (i in 1...sortedValuables.length) {
			for (j in 0...current.length) previous[j] = current[j];

			var currentSortedValuable = sortedValuables[i],
				idIndex = idIndexes[currentSortedValuable.Id],
				start = current.insertEF(0, idIndex, null, currentSortedValuable.Value, currentSortedValuable.Weight);

			for (previousSortedValuable in previous) {
				var value = previousSortedValuable.Value + currentSortedValuable.Value;
				var weight = previousSortedValuable.Weight + currentSortedValuable.Weight;
				start = current.insertEF(start, idIndex, previousSortedValuable.SolutionIds, value, weight);
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

	public static function findEfficientFrontierLinkedList(valuables: Array<Valuable>) {
		var idIndexes = new Map<String, Int>(),
			sortedValuables = valuables.copy().sortByWeightAscValueDesc();

		for (i in 0...valuables.length) idIndexes[valuables[i].Id] = i;
		
		var firstEFValuables = new EFValuables(idIndexes[sortedValuables[0].Id], null, sortedValuables[0].Value, sortedValuables[0].Weight);

		for (i in 1...sortedValuables.length) {
			var previous = firstEFValuables.toArray(),
				currentSortedValuable = sortedValuables[i],
				idIndex = idIndexes[currentSortedValuable.Id],
				startEFValuables = firstEFValuables.insert(idIndex, null, currentSortedValuable.Value, currentSortedValuable.Weight);

			for (previousSortedValuable in previous) {
				var value = previousSortedValuable.Value + currentSortedValuable.Value;
				var weight = previousSortedValuable.Weight + currentSortedValuable.Weight;
				startEFValuables = startEFValuables.insert(idIndex, previousSortedValuable.SolutionIds, value, weight);
			}
		}

		return firstEFValuables.toArray().map(function(efValuables) return efValuables.toValuables(valuables));
	}
}

private class EFValuables {
	public var Value: Float;
	public var Weight: Float;
	public var SolutionIds: Array<Int>;

	public var Next: EFValuables;

	public function new(id, ids: Array<Int>, value, weight, ?next) {
		this.Next = next;
		this.Value = value;
		this.Weight = weight;
		this.SolutionIds = [id];
		if(ids != null) for (id in ids) this.SolutionIds.push(id);
	}

	public function toValuables(valuables: Array<Valuable>) {
		this.SolutionIds.sort(function(id1, id2) return id1 - id2);
		return new Valuables([for(i in this.SolutionIds) valuables[i].Id], this.Value, this.Weight);
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
			current.Next = new EFValuables(id, ids, value, weight);
			return current.Next;
		}

		if (weight == next.Weight && value <= next.Value) return next;
		
		while (next != null && next.Value <= value) next = next.Next;

		current.Next = new EFValuables(id, ids, value, weight, next);
		return current.Next;
	}
}
