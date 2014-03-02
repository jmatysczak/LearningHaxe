package ;

class Main {
	macro static function getCompilationTargetMacro() {
		#if cs
		return macro "c#";
		#elseif java
		return macro "java";
		#elseif neko
		return macro "neko";
		#else
		return macro "not supported by 'getCompilationTarget'";
		#end
	}
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