package knapsack;

import haxe.ds.Vector.Vector;

class ArrayTools {
	public static function mapi<A, B>(a: Array<A>, f: Int -> A -> B) : Array<B> {
		var r = new Vector<B>(a.length);
		for (i in 0...a.length) r[i] = f(i, a[i]);

		var a = new Array();
		Reflect.setField(a, "__a", r);
		Reflect.setProperty(a, "length", r.length);
		return a;
	}
}