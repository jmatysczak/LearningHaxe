package ;
import haxe.macro.Context;

class Main {
	static function getCompilationTarget() {
		#if cs
		return "c#";
		#elseif java
		return "java";
		#elseif js
		return "javascript";
		#elseif neko
		return "neko";
		#else
		return "not supported by 'getCompilationTarget'";
		#end
	}

	macro static function getCompilationTargetMacro() {
		var targetNames = ["-cs"=>"c#", "-java"=>"java", "-js"=>"javascript", "-neko"=>"neko"];
		var target = Sys.args().filter(function(arg) return targetNames.exists(arg)).map(function(arg) return targetNames[arg]).pop();
		return Context.makeExpr(target, Context.currentPos());
	}

	static function main() {
		trace('Hello (${getCompilationTarget()} - ${getCompilationTargetMacro()}) World');
	}
}