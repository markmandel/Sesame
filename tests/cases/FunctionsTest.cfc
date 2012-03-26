/**
 * Test for function functions
 */
component extends="tests.AbstractTestCase"
{
	include "../../sesame/functions.cfm";
	include "../../sesame/collections.cfm";


	/**
	 * test currying
	 */
	public void function testCurrying()
	{
		var data = [1, 2, 3, 4];
		var collectData = _curry(_collect, [data]);

		var collected = collectData(function(it) { return it * 2; });

		assertEquals([2,4,6,8], collected);
	}
	
}
