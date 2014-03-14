package knapsack;

using knapsack.DynamicProgrammingAlgorithms;

class DynamicProgrammingAlgorithms {
	public static function findEfficientFrontier(valuables: Array<Valuable>) {
		var current = new Array<EFValuables>(),
			previous = new Array<EFValuables>(),
			sortedValuables = valuables.sortByWeightAscValueDesc(),
			firstSortedValuable = sortedValuables[0];

		current.push(new EFValuables(firstSortedValuable.Id, null, firstSortedValuable.Value, firstSortedValuable.Weight));
		for (i in 1...sortedValuables.length) {
			for (j in 0...current.length) previous[j] = current[j];

			var currentSortedValuable = sortedValuables[i];
			var start = current.insertEF(0, currentSortedValuable.Id, null, currentSortedValuable.Value, currentSortedValuable.Weight);

			for (previousSortedValuable in previous) {
				var value = previousSortedValuable.Value + currentSortedValuable.Value;
				var weight = previousSortedValuable.Weight + currentSortedValuable.Weight;
				start = current.insertEF(start, currentSortedValuable.Id, previousSortedValuable.SolutionIds, value, weight);
			}
		}

		return current.map(function(valuables) return new Valuables([], valuables.Value, valuables.Weight));
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
		valuables.sort(function(dv1, dv2) {
			var diff = dv1.Weight - dv2.Weight;
			if (diff < 0) return -1;
			if (diff > 0) return 1;
			diff = dv2.Value - dv1.Value;
			if (diff < 0) return -1;
			if (diff > 0) return 1;
			return 0;
		});
		return valuables;
	}
}

class EFValuables {
	public var Value: Float;
	public var Weight: Float;
	public var SolutionIds: Array<String>;

	public function new(id, ids: Array<String>, value, weight) {
		this.Value = value;
		this.Weight = weight;
		this.SolutionIds = [id];
		if(ids != null) for (id in ids) this.SolutionIds.push(id);
	}
}
