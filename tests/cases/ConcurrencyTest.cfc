/**
 * Test for function functions
 */
component extends="tests.AbstractTestCase"
{
	include "../../sesame/concurrency.cfm";


	/**
	 * test each in parrallel with an array
	 */
	public void function testEachParrallelwithArray()
	{
		var data = [1, 2, 3, 4];
		var collected = [];

		_eachParallel(data, function(it) { ArrayAppend(collected, 2*it); });

		debug(data);
		debug(collected);

		arraySort(collected, "numeric");

		assertEquals([2,4,6,8], collected);
	}

	/**
	 * test each in parrallel with a struct
	 */
	public void function testEachParrallelwithStruct()
	{
		var data = {a=1, b=2, c=3, d=4};
		var collected = {};

		_eachParallel(data, function(k, v) { collected[k] = 2*v; });

		assertEquals({a=2, b=4, c=6, d=8}, collected);
	}

	/**
	 * test ClosureRunnable
	 */
	public void function testClosureRunnableNoArguments()
	{
		var func = function() { request.foo = "bar"; };

		var runnable = new sesame.concurrency.ClosureRunnable(func);

		assertFalse(structKeyExists(request, "foo"));

		runnable.run();

		assertTrue(structKeyExists(request, "foo"));
		assertEquals("bar", request.foo);
	}

	/**
	 * test ClosureRunnable
	 */
	public void function testClosureRunnableWithArguments()
	{
		var func = function(it) { request.testClosureRunnableWithArguments = it; };

		var runnable = new sesame.concurrency.ClosureRunnable(func, {1="bar"});

		assertFalse(structKeyExists(request, "testClosureRunnableWithArguments"));

		runnable.run();

		assertTrue(structKeyExists(request, "testClosureRunnableWithArguments"));
		assertEquals("bar", request.testClosureRunnableWithArguments);
	}


}
