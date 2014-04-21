package knapsack;

import haxe.unit.TestCase;

class BitMapTest extends TestCase {
	public function test_Ensure_that_a_bit_can_be_set_and_retrieved() {
		var bitMap = new BitMap(32);
		assertEquals(0, bitMap.count);

		bitMap.set(10);
		assertEquals(1, bitMap.count);

		var setBits = [];
		bitMap.each(function(i, bit) setBits[i] = bit);

		assertEquals(1, setBits.length);
		assertEquals(10, setBits[0]);
	}

	public function test_Ensure_that_bits_that_span_int_boundaries_can_be_set_and_retrieved() {
		var bitMap = new BitMap(100);
		assertEquals(0, bitMap.count);

		for(i in 1...10) bitMap.set(i*10);
		assertEquals(9, bitMap.count);

		var setBits = [];
		bitMap.each(function(i, bit) setBits[i] = bit);

		assertEquals(9, setBits.length);
		for(i in 1...10) assertEquals(i * 10, setBits[i-1]);
	}
}