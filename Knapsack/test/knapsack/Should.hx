package knapsack;

class Should {
	public static function shouldEqual(a: Solution, b: Solution) {
		if(!a.equals(b)) throw "Should equal, but doesn't...";
	}
}