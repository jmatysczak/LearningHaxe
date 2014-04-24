import haxe.unit.TestRunner;
import knapsack.BitMapTest;
import knapsack.BranchAndBoundSolver;
import knapsack.BranchAndBoundAlgorithms.findByHorowitzSahni;
import knapsack.DynamicProgrammingSolver;
import knapsack.DynamicProgrammingAlgorithms.findEfficientFrontier;
import knapsack.FullSearchSolver;
import knapsack.ProblemFactory;
import knapsack.Solution;
import sys.FileSystem;
import sys.io.File;

class Main {
	static var SPACING = "    ";

	static function main() {
		var full = Sys.getEnv("KNAPSACK_FULL") == "1",
			save = Sys.getEnv("KNAPSACK_SAVE") == "1";

		if(full) {
			var testRunner = new TestRunner();
			testRunner.add(new BitMapTest());
			var testsPassed = testRunner.run();
			if (!testsPassed) return;
		}

		Sys.println('\nExecution environment: ${getExecutionEnvironment()}');

		var example = Solution.fromString(File.getContent("example_10_Uncorrelated.txt")),
			heatMapSlotCount = example.HeatMap.length,
			exampleProblem = new Problem("Uncorrelated", "Uncorrelated.", example.Valuables),
			solvers = [
				new DynamicProgrammingSolver("", 500, findEfficientFrontier),
				new BranchAndBoundSolver("Horowitz-Sahni", findByHorowitzSahni),
				new FullSearchSolver()
			];

		example.shouldEqual(example);

		var problems = (full ? [exampleProblem].concat(ProblemFactory.createProblems([16, 25])) : []).concat(ProblemFactory.createProblems([36])),
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

			for (solver in solvers)
				if (valuableCount <= solver.ValuableCountLimit)
					results.push(time(solver, valuables, weightLimit, heatMapSlotCount));

			if (save && !exampleFileNameExists) File.saveContent(exampleFileName, results[0].toString());

			for(i in 1...results.length) {
				try {
					results[i].shouldEqual(results[0]);
				} catch (e: Dynamic) {
					Sys.println('"${results[i].SolverId}" does not equal the expected value.');
					File.saveContent("error_" + getExecutionLang() + fileNameSuffix, e);
					throw e;
				}
			}
		}

		Sys.println("\n" + SPACING + SPACING + "--- Tests completed successfully. ---\n");
	}

	static function time(solver, valuables, weightLimit, heatMapSlotCount) {
		var start = Sys.time();
		var solution = solver.solve(valuables, weightLimit, heatMapSlotCount);
		var finish = Sys.time();
		Sys.println(SPACING + SPACING + SPACING + '${solver.Title} executed in (seconds): ${finish - start}');
		return solution;
	}

	static function getExecutionLang() {
		#if cs
		return "C#" + untyped __cs__('(System.Type.GetType("Mono.Runtime") == null ? "MS" : "Mono")');
		#elseif java
		return "Java";
		#elseif neko
		return "Neko";
		#else
		return "Not supported by 'getCompilationTarget'";
		#end
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