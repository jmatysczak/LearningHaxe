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

	public function toMappedVector(map: Vector<String>): Vector<String> {
		var index = 0,
			mappedVector = new Vector<String>(this.count);
		for (i in 0...this.bits.length) {
			var int = this.bits[i],
				iOffset = i * 32;
			for (j in 0...32) {
				if (int & (1 << j) != 0) {
					mappedVector[index++] = map[iOffset + j];
				}
			}
		}
		return mappedVector;
	}
}