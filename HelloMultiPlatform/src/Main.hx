package ;

class Main {
	macro static function getCompilationTarget() {
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
	static function main() {
		Sys.println('Hello (${getCompilationTarget()}) World');
	}
}