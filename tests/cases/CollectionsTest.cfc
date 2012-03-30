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

		arraySort(collected, "text");

		assertEquals(["oofbar", "sgnihtgoat"], collected);
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

	/**
	 * test unique collections, no comparatpr
	 */
	public void function testUniqueNoComparatorArray()
	{
		var data = [1, 2, 3, 3, 4, 5, 1, 2, 9];
		var expected = [1, 2, 3, 4, 5, 9];

		var unique = _unique(data);

		assertEquals(expected, unique);
	}

	/**
	 * test unique collections, no comparatpr
	 */
	public void function testUniqueNoComparatorStruct()
	{
		var data = {a=1, b=2, c=3, d=3, e=4, f=5, g=1, h=2, i=9};
		var expected = [1, 2, 3, 4, 5, 9];

		var unique = _unique(data);
		ArraySort(unique, "numeric");

		assertEquals(expected, unique);
	}

	/**
	 * test unique collections with a comparator
	 */
	public void function testUniqueComparatorArray()
	{
		var data = [2, 3, 3, 2, 4, 5, 6, 4, 6, 3];
		var expected = [2, 3, 4, 5, 6];

		var comparator = function(a, b)
							{
								if(a == b) { return 0; }
								return 1;
							};

		assertEquals(0, comparator(1, 1));
		assertEquals(1, comparator(2, 1));

		var unique = _unique(data, comparator);

		debug(unique);
		debug(expected);

		assertEquals(expected, unique);
	}

	/**
	 * test unique collections with a comparator
	 */
	public void function testUniqueComparatorArrayByReference()
	{
		var data = createObject("java", "java.util.ArrayList").init([2, 3, 3, 2, 4, 5, 6, 4, 6, 3]);
		var expected = [2, 3, 4, 5, 6];

		var comparator = function(a, b)
		{
			if(a == b) { return 0; }
			return 1;
		};

		assertEquals(0, comparator(1, 1));
		assertEquals(1, comparator(2, 1));

		var unique = _unique(data, comparator);

		debug(unique);
		debug(expected);

		assertEquals(expected, unique);
	}

	/**
	 * test unique collections with a comparator
	 */
	public void function testUniqueComparatorStruct()
	{
		var data = {a=2, b=3, c=3, d=2, e=4, f=5, g=6, h=4, i=6, j=3};
		var expected = [2, 3, 4, 5, 6];

		var comparator = function(a, b)
							{
								if(a == b) { return 0; }
								return 1;
							};

		assertEquals(0, comparator(1, 1));
		assertEquals(1, comparator(2, 1));

		var unique = _unique(data, comparator);

		arraySort(unique, "numeric");

		debug(unique);
		debug(expected);

		assertEquals(expected, unique);
	}
}
