import knapsack.BBAndDP;
import knapsack.FullSearch;
import knapsack.Solution;
import sys.io.File;

class Main {
	static function main() {
		var expected = Solution.fromString(File.getContent("example_10.txt")),
			actualBBAndDP = BBAndDP.Find(expected.Valuables, expected.WeightLimit),
			actualFullSearch = FullSearch.Find(expected.Valuables, expected.WeightLimit);

		expected.shouldEqual(expected);
		actualBBAndDP.shouldEqual(expected);
		actualFullSearch.shouldEqual(expected);

		Sys.println("\n--- Test complete. No errors. ---\n");
	}
}