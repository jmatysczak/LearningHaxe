import knapsack.CustomizableSearch;
import knapsack.BranchAndBoundAlgorithms.findByHorowitzSahni;
import knapsack.DynamicProgrammingAlgorithms.findEfficientFrontier;
import knapsack.FullSearch;
import knapsack.ProblemFactory;
import knapsack.Solution;
import sys.FileSystem;
import sys.io.File;

class Main {
	static var SPACING = "    ";

	static function main() {
		Sys.println('\nExecution environment: ${getExecutionEnvironment()}');

		var example10 = Solution.fromString(File.getContent("example_10.txt")),
			heatMapSlotCount = example10.HeatMap.length,
			example10Problem = new Problem("", "Uncorrelated.", example10.Valuables, example10.WeightLimit, example10),
			customizableSearch_HS = new CustomizableSearch(findByHorowitzSahni, findByHorowitzSahni, findEfficientFrontier);

		example10.shouldEqual(example10);

		var problems = [example10Problem].concat(ProblemFactory.createProblems([16, 30])),
			lastValuableCount = -1;
		for (problem in problems) {
			if (problem.Valuables.length != lastValuableCount) {
				lastValuableCount = problem.Valuables.length;
				Sys.println(SPACING + '$lastValuableCount Valuables');
			}

			Sys.println(SPACING + SPACING + problem.Descr);

			var results = [],
				valuables = problem.Valuables,
				weightLimit = problem.WeightLimit,
				valuableCount = problem.Valuables.length,
				fileNameSuffix = '_${valuableCount}_${problem.Title}.txt',
				exampleFileName = "example" + fileNameSuffix,
				exampleFileNameExists = FileSystem.exists(exampleFileName);

			if (exampleFileNameExists) {
				var example = Solution.fromString(File.getContent(exampleFileName));
				valuables = example.Valuables;
				weightLimit = example.WeightLimit;
				results.push(example);
			}

			if (problem.Solution != null) results.push(problem.Solution);
			if (valuableCount <= 20) results.push(time("Full Search", function() return FullSearch.find(valuables, weightLimit, heatMapSlotCount)));
			results.push(time("Horowitz-Sahni", function() return customizableSearch_HS.find(valuables, weightLimit, heatMapSlotCount)));

			if (!exampleFileNameExists) File.saveContent(exampleFileName, results[results.length - 1].toString());

			for(i in 1...results.length) {
				try {
					results[i].shouldEqual(results[i - 1]);
				} catch (e: Dynamic) {
					File.saveContent("error" + fileNameSuffix, e);
					throw e;
				}
			}
		}

		Sys.println("\n" + SPACING + SPACING + "--- Tests completed successfully. ---\n");
	}

	static function time(type, f: Void -> Solution) {
		var start = Sys.time();
		var solution = f();
		var finish = Sys.time();
		Sys.println(SPACING + SPACING + SPACING + '$type executed in (seconds): ${finish - start}');
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