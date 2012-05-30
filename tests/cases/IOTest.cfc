/**
 * Test for io
 */
component extends="tests.AbstractTestCase"
{
	include "../../sesame/io.cfm";

	/**
	 * test fileLineEach
	 */
	public void function testFileLineEach()
	{
		var buffer = "";
		var theFile = getCurrentTemplatePath();
		_fileLineEach(theFile, function(line) {
			buffer &= line;
		});

		assertTrue(find("_fileReadLine", buffer));
	}

	/**
	 * test fileLineEach with a file ob
	 */
	public void function testFileLineEachObject()
	{
		var buffer = "";
		var theFile = fileOpen(getCurrentTemplatePath());
		_fileLineEach(theFile, function(line) {
			buffer &= line;
		});

		assertTrue(find("_fileReadLine", buffer));
	}

}
