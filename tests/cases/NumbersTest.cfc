/**
 * Test for function functions
 */
component extends="tests.AbstractTestCase"
{
	include "../../sesame/numbers.cfm";

	/**
	 * test step
	 */
	public void function testStep()
	{
		var data = [];
		_step(0, 10, 2, function(it) { arrayAppend(data, it); });

		assertEquals([0, 2, 4, 6, 8], data);
	}

	/**
	 * test up to
	 */
	public void function testUpTo()
	{
		var data = [];
		_upto(1, 6, function(it) { arrayAppend(data, it); });

		assertEquals([1,2,3,4,5], data);
	}

	/**
	 * test up to
	 */
	public void function testTimes()
	{
		var data = [];
		_times(6, function(it) { arrayAppend(data, it); });

		assertEquals([0,1,2,3,4,5], data);
	}
}
