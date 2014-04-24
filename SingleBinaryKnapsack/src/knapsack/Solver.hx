package knapsack;

import knapsack.ProblemFactory.Difficulty;

interface Solver {
	public var Title: String;
	public function getValuableCountLimit(d: Difficulty): Int;
	public function solve(valuables: Array<Valuable>, weightLimit: Float, heatMapSlotCount: Int): Solution;
}