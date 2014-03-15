import knapsack.CustomizableSearch;
import knapsack.BranchAndBoundAlgorithms.findByHorowitzSahni;
import knapsack.DynamicProgrammingAlgorithms.findEfficientFrontier;
import knapsack.FullSearch;
import knapsack.Solution;
import sys.io.File;

class Main {
	static function main() {
		var expected = Solution.fromString(File.getContent("example_10.txt")),
			actualFullSearch = FullSearch.find(expected.Valuables, expected.WeightLimit, expected.HeatMap.length),
			actualCustomizableSearch_HS = new CustomizableSearch(findByHorowitzSahni, findByHorowitzSahni, findEfficientFrontier).find(expected.Valuables, expected.WeightLimit, expected.HeatMap.length);

		expected.shouldEqual(expected);
		actualFullSearch.shouldEqual(expected);
		actualCustomizableSearch_HS.shouldEqual(expected);

		Sys.println("\n--- Tests completed successfully. ---\n");
	}
}