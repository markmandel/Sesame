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
	 * test each in parrallel with an array
	 */
	public void function testEachParrallelwithArrayWithPool()
	{
		var data = [1, 2, 3, 4];
		var collected = [];

		//gate
		assertFalse(structKeyExists(request, "sesame-concurrency-es"));

		_withPool(10, function()
		{
			assertTrue(structKeyExists(request, "sesame-concurrency-es"));

			_eachParallel(data, function(it) { ArrayAppend(collected, 2*it); });
		});

		assertFalse(structKeyExists(request, "sesame-concurrency-es"));

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
	 * test ClosureConcurrent
	 */
	public void function testClosureConcurrentNoArguments()
	{
		var func = function() { request.foo = "bar"; };

		var runnable = new sesame.concurrency.ClosureConcurrent(func);

		assertFalse(structKeyExists(request, "foo"));

		runnable.run();

		assertTrue(structKeyExists(request, "foo"));
		assertEquals("bar", request.foo);

		var func = function() { return "Hello World"; };

		var callable = new sesame.concurrency.ClosureConcurrent(func);
		assertEquals(func(), callable.call());
	}

	/**
	 * test ClosureConcurrent
	 */
	public void function testClosureConcurrentWithArguments()
	{
		var func = function(it) { request.testClosureConcurrentWithArguments = it; };

		var runnable = new sesame.concurrency.ClosureConcurrent(func, {1="bar"});

		assertFalse(structKeyExists(request, "testClosureConcurrentWithArguments"));

		runnable.run();

		assertTrue(structKeyExists(request, "testClosureConcurrentWithArguments"));
		assertEquals("bar", request.testClosureConcurrentWithArguments);

		var func = function(it) { return "Hello World #it#"; };
		var callable = new sesame.concurrency.ClosureConcurrent(func, {1="GOATS!"});

		assertEquals(func("GOATS!"), callable.call());
	}

	/**
	 * test thread with a return value
	 */
	public void function testThreadWithReturnValue()
	{
		_withPool(5, function()
		{
			var future = _thread(function() {  return "Hello World!"; });

			assertEquals("Hello World!", future.get());
		});
	}

	/**
	 * test thread without a return value
	 */
	public void function testThreadWithoutReturnValue()
	{
		var key = createUUID();
		var result = {};
		var future = 0;
		_withPool(5, function()
		{
			future = _thread(function() { result[key] = 1; });
		});

		future.get();

		AssertTrue(structKeyExists(result, key));
	}
}
