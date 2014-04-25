package knapsack;

import haxe.ds.Vector.Vector;

class VectorTools {
	public static function join<T>(v: Vector<T>, sep: String): String {
		if (v.length == 0) return "";
		var buf = new StringBuf();
		buf.add(v[0]);
		for (i in 1...v.length) {
			buf.add(sep);
			buf.add(v[i]);
		}
		return buf.toString();
	}

	public static function toArray<A>(v: Vector<A>): Array<A> {
		var a = new Array<A>();
		Reflect.setField(a, "__a", v);
		Reflect.setProperty(a, "length", v.length);
		return a;
	}
}