package knapsack;

class FloatTools {
	public inline static function compareTo(me: Float, other: Float, equalsValue = 0): Int {
			var diff = me - other;
			if (diff < 0) equalsValue = -1;
			if (diff > 0) equalsValue = 1;
			return equalsValue;
	}
}