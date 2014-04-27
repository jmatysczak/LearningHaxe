package knapsack;

import haxe.ds.Vector.Vector;
import haxe.unit.TestCase;

class BitMapTest extends TestCase {
	public function test_Ensure_that_a_bit_can_be_set_and_retrieved() {
		var bitMap = new BitMap(32);
		assertEquals(0, bitMap.count);

		bitMap.set(10);
		assertEquals(1, bitMap.count);

		var map = new Vector(32);
		var expected = map[10] = "Some value.";
		var mappedVector = bitMap.toMappedVector(map);

		assertEquals(1, mappedVector.length);
		assertEquals(expected, mappedVector[0]);
	}

	public function test_Ensure_that_bits_that_span_int_boundaries_can_be_set_and_retrieved() {
		var bitMap = new BitMap(100);
		assertEquals(0, bitMap.count);

		for(i in 1...10) bitMap.set(i*10);
		assertEquals(9, bitMap.count);

		var map = new Vector(100);
		for(i in 1...10) map[i*10] = 'Some value: ${i*10}';
		var mappedVector = bitMap.toMappedVector(map);

		assertEquals(9, mappedVector.length);
		for(i in 1...10) assertEquals('Some value: ${i*10}', mappedVector[i-1]);
	}

	public function test_Ensure_that_bits_at_int_boundaries_can_be_set_and_retrieved() {
		var bitMap = new BitMap(100);
		assertEquals(0, bitMap.count);

		var bits = [0, 1, 30, 31, 32, 62, 63, 64];
		for(b in bits) bitMap.set(b);
		assertEquals(bits.length, bitMap.count);

		var map = new Vector(100);
		for (i in bits) map[i] = 'Some value: $i';
		var mappedVector = bitMap.toMappedVector(map);

		assertEquals(bits.length, mappedVector.length);
		for(i in 0...bits.length) assertEquals('Some value: ${bits[i]}', mappedVector[i]);
	}

	public function test_Ensure_that_a_BitMap_can_be_cloned() {
		var bitMap = new BitMap(100);
		assertEquals(0, bitMap.count);

		for(i in 0...4) bitMap.set(20 + i * 20);
		assertEquals(4, bitMap.count);

		var clonedBitMap = bitMap.clone();
		assertEquals(4, clonedBitMap.count);

		var map = new Vector(100);
		for(i in 0...4) map[20 + i * 20] = 'Some value: ${20 + i * 20}';
		var mappedVector = clonedBitMap.toMappedVector(map);

		assertEquals(4, mappedVector.length);
		for (i in 0...4) assertEquals('Some value: ${20 + i * 20}', mappedVector[i]);

		var existingBitMap = new BitMap(100);
		bitMap.clone(existingBitMap);
		mappedVector = existingBitMap.toMappedVector(map);
		assertEquals(4, mappedVector.length);
		for (i in 0...4) assertEquals('Some value: ${20 + i * 20}', mappedVector[i]);
	}
}