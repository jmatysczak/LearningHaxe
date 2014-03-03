package ;

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
	static function main() {
		trace('Hello (${getCompilationTarget()}) World');
	}
}