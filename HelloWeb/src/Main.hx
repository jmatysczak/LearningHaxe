// With the output file being "HelloWeb.n" the url is "http://localhost:2000/HelloWeb.n"
// Parameters work as normal ("http://localhost:2000/HelloWeb.n?foo=bar&baz=biff").
package ;

class Main {
	static function main() {
		trace("Hello (trace) World!");
		Sys.println("Hello (Sys.println) World!");
	}
}