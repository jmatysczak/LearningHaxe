package ;
import haxe.macro.Context;

class Main {
	static function getCompilationTarget() {
		#if cs
		return "c#";
		#elseif java
		return "java";
		#elseif neko
		return "neko";
		#else
		return "not supported by 'getCompilationTarget'";
		#end
	}
	static function main() {
		Sys.println('Hello (${getCompilationTarget()}) World');
	}
}