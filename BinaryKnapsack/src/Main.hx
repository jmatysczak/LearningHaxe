import knapsack.BBAndDP;
import knapsack.FullSearch;
import knapsack.Solution;
import sys.io.File;

class Main {
	static function main() {
		var expected = Solution.fromString(File.getContent("example_10.txt")),
			actualFullSearch = FullSearch.find(expected.Valuables, expected.WeightLimit),
			actualBBAndDP_HS = new BBAndDP(BBAndDP.findByHorowitzSahni, BBAndDP.findByHorowitzSahni).find(expected.Valuables, expected.WeightLimit);

		expected.shouldEqual(expected);
		actualFullSearch.shouldEqual(expected);
		actualBBAndDP_HS.shouldEqual(expected);

		Sys.println("\n--- Test complete. No errors. ---\n");
	}
}