package knapsack;

import haxe.unit.TestCase;

class ValuablesTest extends TestCase {
	public function test_Ensure_that_a_Valuables_can_be_created_from_a_string() {
		var valuables = Valuables.fromString("377.49	2675807.37	1010101010");
		assertEquals(377.49, valuables.Value);
		assertEquals(2675807.37, valuables.Weight);
		for (i in 0...10) assertEquals('$i: ${i%2 == 0}', '$i: ${valuables.Ids.isSet(i)}');

		var valuables = Valuables.fromString("377.49	2675807.37	0101010101");
		for (i in 0...10) assertEquals('$i: ${i%2 == 1}', '$i: ${valuables.Ids.isSet(i)}');
	}
}