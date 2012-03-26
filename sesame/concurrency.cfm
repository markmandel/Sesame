<!---
	Copyright 2012 Mark Mandel

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	   http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.



	Make it easier to do things in parrallel.
	These functions often used the variables scope to perform what they do in UUID'd scoped contexts.
--->

<cfscript>
	/**
	 * Do each iteration in it's own thread, and then join it all back again at the end.
	 *
	 * @data the array/struct to perform a closure on
	 * @closure the closure to pass through the elements from data to.
	 */
	public void function _eachParallel(required any data, required function closure)
	{
		var threads = [];
		var scope = "_eachParallel" & createUUID();
		variables[scope] = {};

		if(isArray(arguments.data))
		{
			var len = ArrayLen(arguments.data);
			for(var counter = 1; counter lte len; counter++)
			{
				var threadname = "each-#createUUID()#";
				arrayAppend(threads, threadname);
				variables[scope][threadname] = {item = arguments.data[counter], closure=arguments.closure};

				thread action="run" name="#threadname#" scope="#scope#"
				{
					var scope = variables[scope][thread.name];
					scope.closure(scope.item);
				}
			}
		}

		if(isStruct(arguments.data))
		{
			for(var key in arguments.data)
			{
				var threadname = "each-#createUUID()#";
				arrayAppend(threads, threadname);
				variables[scope][threadname] = {key = key, value=arguments.data[key], closure=arguments.closure};

				thread action="run" name="#threadname#" scope="#scope#"
				{
					var scope = variables[scope][thread.name];
					scope.closure(scope.key, scope.value);
				}
			}
		}

		//join it all back up
		ArrayEach(threads, function(it) { threadJoin(it); });

		structDelete(variables, scope);
	}

</cfscript>