import knapsack.CustomizableSearch;
import knapsack.BranchAndBoundAlgorithms.findByHorowitzSahni;
import knapsack.DynamicProgrammingAlgorithms.findEfficientFrontier;
import knapsack.FullSearch;
import knapsack.ProblemFactory;
import knapsack.Solution;
import sys.io.File;

class Main {
	static var SPACING = "    ";

	static function main() {
		var expected = Solution.fromString(File.getContent("example_10.txt")),
			heatMapSlotCount = expected.HeatMap.length,
			actualFullSearch = FullSearch.find(expected.Valuables, expected.WeightLimit, heatMapSlotCount),
			customizableSearch_HS = new CustomizableSearch(findByHorowitzSahni, findByHorowitzSahni, findEfficientFrontier),
			actualCustomizableSearch_HS = customizableSearch_HS.find(expected.Valuables, expected.WeightLimit, heatMapSlotCount);

		expected.shouldEqual(expected);
		actualFullSearch.shouldEqual(expected);
		actualCustomizableSearch_HS.shouldEqual(expected);

		Sys.println('\nExecution environment: ${getExecutionEnvironment()}');
		var problems = ProblemFactory.createProblems(15);
		for (problem in problems) {
			Sys.println(SPACING + problem.Descr);
			var actualFullSearch = time("Full Search", function() return FullSearch.find(problem.Valuables, problem.WeightLimit, heatMapSlotCount)),
				actualCustomizableSearch_HS = time("Horowitz-Sahni", function() return customizableSearch_HS.find(problem.Valuables, problem.WeightLimit, heatMapSlotCount));

			try {
				actualCustomizableSearch_HS.shouldEqual(actualFullSearch);
			} catch (e: Dynamic) {
				File.saveContent('error_${problem.Valuables.length}_${problem.Title}.txt', e);
				throw e;
			}
		}

		Sys.println("\n" + SPACING + "--- Tests completed successfully. ---\n");
	}

	static function time(type, f: Void -> Solution) {
		var start = Sys.time();
		var solution = f();
		var finish = Sys.time();
		Sys.println(SPACING + SPACING + '$type executed in (seconds): ${finish - start}');
		return solution;
	}

	static function getExecutionEnvironment() {
		#if cs
		return "C# (" + untyped __cs__('(System.Type.GetType("Mono.Runtime") == null ? "MS" : "Mono") + " " + System.Environment.Version.ToString()') + ")";
		#elseif java
		return "Java (" + untyped __java__('System.getProperty("java.version")') + ")";
		#elseif neko
		return "Neko";
		#else
		return "Not supported by 'getCompilationTarget'";
		#end
	}
}