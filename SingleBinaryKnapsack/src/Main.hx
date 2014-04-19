import knapsack.BranchAndBoundSolver;
import knapsack.BranchAndBoundAlgorithms.findByHorowitzSahni;
import knapsack.DynamicProgrammingSolver;
import knapsack.DynamicProgrammingAlgorithms.findEfficientFrontierArray;
import knapsack.DynamicProgrammingAlgorithms.findEfficientFrontierLinkedList;
import knapsack.FullSearchSolver;
import knapsack.ProblemFactory;
import knapsack.Solution;
import sys.FileSystem;
import sys.io.File;

class Main {
	static var SPACING = "    ";

	static function main() {
		Sys.println('\nExecution environment: ${getExecutionEnvironment()}');

		var example = Solution.fromString(File.getContent("example_10_Uncorrelated.txt")),
			heatMapSlotCount = example.HeatMap.length,
			exampleProblem = new Problem("Uncorrelated", "Uncorrelated.", example.Valuables),
			solvers = [
				new DynamicProgrammingSolver("Array", findEfficientFrontierArray),
				new DynamicProgrammingSolver("LinkedList", findEfficientFrontierLinkedList),
				new BranchAndBoundSolver("Horowitz-Sahni", findByHorowitzSahni),
				new FullSearchSolver()
			];

		example.shouldEqual(example);

		var problems = [exampleProblem].concat(ProblemFactory.createProblems([16, 25 /*, 30*/])),
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

			if (!exampleFileNameExists) File.saveContent(exampleFileName, results[0].toString());

			for(i in 1...results.length) {
				try {
					results[i].shouldEqual(results[0]);
				} catch (e: Dynamic) {
					File.saveContent("error" + fileNameSuffix, e);
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