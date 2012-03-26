/**
 * Test for collections functions
 */
component extends="tests.AbstractTestCase"
{
	include "../../sesame/collections.cfm";

	/**
	* test collecting an array
	*/
	public void function testCollectArray()
	{
		var array = [1, 2, 3, 4];
		var collected = _collect(array, function(it) { return it * 2; });

		assertEquals([2, 4, 6, 8], collected);
	}

	/**
	* test collecting an array
	*/
	public void function testCollectStruct()
	{
		var data = {foo="bar", things="goat"};
		var collected = _collect(data, function(k, v) { return reverse(k) & v; });

		assertEquals(["sgnihtgoat", "oofbar"], collected);
	}

	/**
	 * test collect entries array
	 */
	public void function testCollectEntriesArrayWithArrayKey()
	{
		var data = [1, 2, 3, 4];

		var collected = _collectEntries(data, function(it) { return [it * 2, it]; });

		assertEquals({2=1, 4=2, 6=3, 8=4}, collected);
	}

	/**
	 * test collect entries array
	 */
	public void function testCollectEntriesArrayWithStructKey()
	{
		var data = [1, 2, 3, 4];

		var collected = _collectEntries(data, function(it)
					{
						entry = {};
						entry[it * 2] = it;
						return entry;
					});

		assertEquals({2=1, 4=2, 6=3, 8=4}, collected);
	}

	/**
	 * testCollectEntriesStruct With array Key
	 */
	public void function testCollectEntriesStructWithArrayKey()
	{
		var data = {foo="bar", things="goat"};
		var collected = _collectEntries(data, function(k, v) { return [v, k]; });

		assertEquals({bar="foo", goat="things"}, collected);
	}

	/**
	 * testCollectEntriesStruct With struct Key
	 */
	public void function testCollectEntriesStructWithStructKey()
	{
		var data = {foo="bar", things="goat"};
		var collected = _collectEntries(data, function(k, v) { return {"#v#"= k}; });

		assertEquals({bar="foo", goat="things"}, collected);
	}

	/**
	 * test group by with an array
	 */
	public void function testGroupByWithArray()
	{
		var data = [1, 2, 3, 4, 5, 6, 7, 8, 9];

		var grouped = _groupBy(data, function(it) { return it % 2; });

		assertEquals({1=[1, 3, 5, 7, 9], 0=[2,4,6,8]}, grouped);
	}

	/**
	 * test group by with Struct
	 */
	public void function testGroupByWithStruct()
	{
		var data = {a=1, b=2, c=3, d=4, e=5, f=6};

		var grouped = _groupBy(data, function(k, v) { return v % 2; });

		assertEquals({1={a=1, c=3, e=5}, 0={b=2, d=4, f=6}}, grouped);
	}
}
