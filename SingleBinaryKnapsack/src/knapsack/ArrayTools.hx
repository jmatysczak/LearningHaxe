package knapsack;

import haxe.ds.Vector.Vector;

using knapsack.VectorTools;

class ArrayTools {
	public static function toStrVector(a: Array<String>): Vector<String> {
		var v = new Vector(a.length);
		for (i in 0...a.length) v[i] = a[i];
		return v;
	}

	public static function mapi<A, B>(a: Array<A>, f: Int -> A -> B) : Array<B> {
		var v = new Vector<B>(a.length);
		for (i in 0...a.length) v[i] = f(i, a[i]);
		return v.toArray();
	}
}