import knapsack.CustomizableSearch;
import knapsack.BranchAndBoundAlgorithms.findByHorowitzSahni;
import knapsack.FullSearch;
import knapsack.Solution;
import sys.io.File;

class Main {
	static function main() {
		var expected = Solution.fromString(File.getContent("example_10.txt")),
			actualFullSearch = FullSearch.find(expected.Valuables, expected.WeightLimit),
			actualCustomizableSearch_HS = new CustomizableSearch(findByHorowitzSahni, findByHorowitzSahni).find(expected.Valuables, expected.WeightLimit);

		expected.shouldEqual(expected);
		actualFullSearch.shouldEqual(expected);
		actualCustomizableSearch_HS.shouldEqual(expected);

		Sys.println("\n--- Test complete. No errors. ---\n");
	}
}