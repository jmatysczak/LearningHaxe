package knapsack;

class BBAndDP {
	var findByBest: Array<Valuable> -> Float -> Valuables;
	
	public function new(findByBest) {
		this.findByBest = findByBest;
	}

	public function find(valuables: Array<Valuable>, weightLimit: Float) {
		var best = this.findByBest(valuables, weightLimit);
		return new Solution(valuables, weightLimit, best);
	}

	public static function findByHorowitzSahni(valuables: Array<Valuable>, weightLimit: Float) {
		return new Valuables([], 0, 0);
	}
}