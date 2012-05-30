<!---
	Copyright 2012 Raymond Camden

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	   http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

	Functions pertaining to input/output
--->

<cfscript>
	
	/**
	 * Read a file and call the closure on each line. Works on either a file ob or path
	 *
	 * @file the file to load
	 * @handler closure to take the input
	 */
	public void function _fileLineEach(required any file, required function handler)
	{
		if(isSimpleValue(arguments.file)) arguments.file = fileOpen(arguments.file);

		try
		{
			while(!fileIsEOF(arguments.file)) {
				var line = fileReadLine(arguments.file);
				handler(line);
			}
		}
		finally
		{
			fileClose(arguments.file);
		}
	};

</cfscript>