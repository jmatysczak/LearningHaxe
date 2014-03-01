// With the output file being "HelloWeb.n" the url is "http://localhost:2000/HelloWeb.n"
// Parameters work as normal ("http://localhost:2000/HelloWeb.n?foo=bar&baz=biff").
package ;
import neko.Web;

class Main {
	static function main() {
		trace("<pre>");
		trace("Hello (trace) World!");
		trace(Web.getURI());
		trace(Web.getParams());
		trace("</pre>");
	}
}