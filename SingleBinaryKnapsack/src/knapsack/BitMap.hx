package knapsack;

import haxe.ds.Vector.Vector;

class BitMap {
	var bits: Vector<Int>;
	public var count(default, null):Int;
	public var capacity(default, null):Int;

	public function new(c: Int) {
		this.count = 0;
		this.capacity = c;
		this.bits = new Vector(Math.ceil(this.capacity / 32));
		#if neko
		for (i in 0...this.bits.length) this.bits[i] = 0;
		#end
	}

	public function clone(?c: BitMap) {
		if(c == null) c = new BitMap(this.capacity);
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

	public function isSet(i: Int) {
		return (this.bits[Math.floor(i / 32)] & (1 << (i % 32))) != 0;
	}

	public function equals(rhs: BitMap): Bool {
		if (this.count != rhs.count) return false;
		if (this.capacity != rhs.capacity) return false;
		for (i in 0...this.bits.length) if (this.bits[i] != rhs.bits[i]) return false;
		return true;
	}

	public function toString() {
		var buf = new StringBuf();
		for (bit in this.bits) for (i in 0...32) buf.add((bit & (1 << i)) == 0 ? "0" : "1");
		return buf.toString().substr(0, this.capacity);
	}
}