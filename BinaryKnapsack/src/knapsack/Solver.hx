package knapsack;

interface Solver {
	public var Title: String;
	public var ValuableCountLimit: Int;
	public function solve(valuables: Array<Valuable>, weightLimit: Float, heatMapSlotCount: Int): Solution;
}