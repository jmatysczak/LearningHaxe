package knapsack;

class BBAndDP {
	public static function Find(valuables: Array<Valuable>, weightLimit: Float) {
		return new Solution(valuables, weightLimit);
	}
}