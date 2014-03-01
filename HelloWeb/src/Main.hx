// With the output file being "HelloWeb.n" the url is "http://localhost:2000/HelloWeb.n"
// Parameters work as normal ("http://localhost:2000/HelloWeb.n?foo=bar&baz=biff").
// Also, the server doesn't need to stopped and restarted to pick up new changes.

package ;

import neko.Web;

class Main {
	static function main() {
		trace("Hello World!");
		Sys.println("<br/>");
		trace(Web.getURI());
		Sys.println("<br/>");
		trace(Web.getParams());
		Sys.println("<br/>");
	}
}