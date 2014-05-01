package knapsack;

import haxe.ds.Vector.Vector;
import haxe.unit.TestCase;

using StringTools;

class BitMapTest extends TestCase {
	public function test_Ensure_that_a_bit_can_be_set_and_retrieved() {
		var bitMap = new BitMap(32);
		assertEquals(0, bitMap.count);

		bitMap.set(10);
		assertEquals(1, bitMap.count);
		for(i in 0...32) assertEquals(i==10, bitMap.isSet(i));
	}

	public function test_Ensure_that_bits_that_span_int_boundaries_can_be_set_and_retrieved() {
		var bitMap = new BitMap(100);
		assertEquals(0, bitMap.count);

		for(i in 1...10) bitMap.set(i*10);
		assertEquals(9, bitMap.count);
		for(i in 0...100) assertEquals(i > 0 && i % 10 == 0, bitMap.isSet(i));
	}

	public function test_Ensure_that_bits_at_int_boundaries_can_be_set_and_retrieved() {
		var bitMap = new BitMap(100);
		assertEquals(0, bitMap.count);

		var bits = [0, 1, 30, 31, 32, 62, 63, 64];
		for(b in bits) bitMap.set(b);
		assertEquals(bits.length, bitMap.count);
		for(i in bits) assertTrue(bitMap.isSet(i));
	}

	public function test_Ensure_that_a_BitMap_can_be_cloned() {
		var bitMap = new BitMap(100);
		assertEquals(0, bitMap.count);

		for(i in 0...4) bitMap.set(20 + i * 20);
		assertEquals(4, bitMap.count);

		var clonedBitMap = bitMap.clone();
		assertEquals(bitMap.count, clonedBitMap.count);
		assertEquals(bitMap.capacity, clonedBitMap.capacity);
		for (i in 0...4) assertTrue(clonedBitMap.isSet(20 + i * 20));
		for (i in 0...100) assertEquals(bitMap.isSet(i), clonedBitMap.isSet(i));
		assertTrue(bitMap.equals(clonedBitMap));

		var existingBitMap = new BitMap(100);
		bitMap.clone(existingBitMap);
		assertTrue(bitMap.equals(existingBitMap));
		assertTrue(clonedBitMap.equals(existingBitMap));
		assertEquals(4, existingBitMap.count);
		for (i in 0...4) assertTrue(existingBitMap.isSet(20 + i * 20));
	}

	public function test_Ensure_that_equals_returns_false_when_two_BitMaps_are_not_equals() {
		var b1 = new BitMap(2);
		var b2 = new BitMap(3);
		assertFalse(b1.equals(b2));

		b1 = new BitMap(3);
		b1.set(0);
		b2 = new BitMap(3);
		b2.set(1);
		assertFalse(b1.equals(b2));

		b1 = new BitMap(3);
		b1.set(1);
		b2 = new BitMap(3);
		b2.set(1);
		b2.set(2);
		assertFalse(b1.equals(b2));
	}

	public function test_Ensure_that_BitMap_toString_returns_the_correct_representation() {
		var bitMap = new BitMap(10);
		for (i in 0...10) if (i % 2 == 0) bitMap.set(i);
		assertEquals("1010101010", bitMap.toString());

		bitMap = new BitMap(40);
		bitMap.set(29);
		bitMap.set(30);
		bitMap.set(31);
		bitMap.set(32);
		bitMap.set(33);
		assertEquals("0".rpad("0", 29) + "11111000000", bitMap.toString());
	}
}