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


	Functions pertaining to manipulating other functions.
--->
<cfscript>
	/**
	 * Curry a function from left to right.
	 * @func the function/closure you want to curry
	 * @args the array of arguments you wish to curry with.
	 */
	public function function _curry(required function func, required array args)
	{
		var argMap = {};
		var counter = 1;
		ArrayEach(args, function(it) { argMap[counter++] = it; });

		return function()
				{
					//we will assume positional arguments
					var newArgs = StructCopy(argMap);
					var len = StructCount(argMap);
					//mix it all toghether
					StructEach(arguments, function(key, value)
						{
							newArgs[len + key] = value;
						});

					return func(argumentCollection=newArgs);
				};
	}
</cfscript>