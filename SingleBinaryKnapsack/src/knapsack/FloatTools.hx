package knapsack;

class FloatTools {
	public inline static function compareTo(me: Float, other: Float, returnValue = 0): Int {
		var diff = me - other;
		if (diff < 0) returnValue = -1;
		if (diff > 0) returnValue = 1;
		return returnValue;
	}
}