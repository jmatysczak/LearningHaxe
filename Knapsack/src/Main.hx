import knapsack.FullSearch;
import knapsack.Solution;
import sys.io.File;

class Main {
	static function main() {
		var expected = Solution.fromString(File.getContent("example_10.txt")),
			actual = FullSearch.Find(expected.Valuables, expected.WeightLimit);

		expected.shouldEqual(expected);
		actual.shouldEqual(expected);

		Sys.println("\n--- Test complete. No errors. ---\n");
	}
}