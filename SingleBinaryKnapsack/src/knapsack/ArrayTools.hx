package knapsack;

import haxe.ds.Vector.Vector;

class ArrayTools {
	public static function fromVector<A>(v: Vector<A>): Array<A> {
		var a = new Array<A>();
		Reflect.setField(a, "__a", v);
		Reflect.setProperty(a, "length", v.length);
		return a;
	}

	public static function mapi<A, B>(a: Array<A>, f: Int -> A -> B) : Array<B> {
		var v = new Vector<B>(a.length);
		for (i in 0...a.length) v[i] = f(i, a[i]);
		return ArrayTools.fromVector(v);
	}
}