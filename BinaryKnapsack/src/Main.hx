import knapsack.CustomizableSearch;
import knapsack.BranchAndBoundAlgorithms.findByHorowitzSahni;
import knapsack.DynamicProgrammingAlgorithms.findEfficientFrontier;
import knapsack.FullSearch;
import knapsack.ProblemFactory;
import knapsack.Solution;
import sys.io.File;

class Main {
	static function main() {
		var expected = Solution.fromString(File.getContent("example_10.txt")),
			heatMapSlotCount = expected.HeatMap.length,
			actualFullSearch = FullSearch.find(expected.Valuables, expected.WeightLimit, heatMapSlotCount),
			customizableSearch_HS = new CustomizableSearch(findByHorowitzSahni, findByHorowitzSahni, findEfficientFrontier),
			actualCustomizableSearch_HS = customizableSearch_HS.find(expected.Valuables, expected.WeightLimit, heatMapSlotCount);

		expected.shouldEqual(expected);
		actualFullSearch.shouldEqual(expected);
		actualCustomizableSearch_HS.shouldEqual(expected);

		var problems = ProblemFactory.createProblems(15);
		for (problem in problems) {
			Sys.println(problem.Descr);
			var actualFullSearch = time("Full Search", function() return FullSearch.find(problem.Valuables, problem.WeightLimit, heatMapSlotCount)),
				actualCustomizableSearch_HS = time("Horowitz-Sahni", function() return customizableSearch_HS.find(problem.Valuables, problem.WeightLimit, heatMapSlotCount));
			actualFullSearch.shouldEqual(actualCustomizableSearch_HS);
		}

		Sys.println("\n--- Tests completed successfully. ---\n");
	}

	static function time(type, f: Void -> Solution) {
		var start = Date.now().getTime();
		var solution = f();
		var finish = Date.now().getTime();
		Sys.println('    $type executed in ${finish - start}');
		return solution;
	}
}