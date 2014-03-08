package knapsack;

class Solution {
	public var Valuables(default, null): Array<Valuable>;
	public var WeightLimit(default, null): Float;
	public var Best: Valuables;
	public var HeatMap: Array<Valuables>;
	public var EfficientFrontier: Array<Valuables>;
}