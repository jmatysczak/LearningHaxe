package knapsack;

import haxe.ds.Vector.Vector;

class BitMap {
	var bits: Vector<Int>;
	public var count(default, null):Int;
	public var capacity(default, null):Int;

	public function new(c: Int ) {
		this.count = 0;
		this.capacity = c;
		this.bits = new Vector(Math.ceil(this.capacity / 32));
		#if neko
		for (i in 0...this.bits.length) this.bits[i] = 0;
		#end
	}

	public function clone() {
		var c = new BitMap(this.capacity);
		Vector.blit(this.bits, 0, c.bits, 0, this.bits.length);
		c.count = this.count;
		return c;
	}

	public function set(i: Int) {
		var index = Math.floor(i / 32);
		var currentValue = this.bits[index];
		this.bits[index] = currentValue | (1 << (i % 32));
		this.count++;
	}

	public function each(f: Int -> Int -> Void) {
		var index = 0;
		for (i in 0...this.bits.length) {
			var int = this.bits[i];
			for (j in 0...32) {
				if (int & (1 << j) != 0) {
					f(index++, i * 32 + j);
				}
			}
		}
	}
}