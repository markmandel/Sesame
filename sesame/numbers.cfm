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


	Functions for use with numbers
--->

<cfscript>
	/**
	 * Iterates from a given number, up to a given number, using a step increment. Each number is passed through to
	 * the closure.
	 *
	 * @numberFrom the number to start at
	 * @numberTo the number to go to
	 * @stepNumber the step to take between iterations
	 * @closure the closure to call with the current count.
	 */
	public void function _step(required numeric numberFrom, required numeric numberTo, required numeric stepNumber, required function closure)
	{
		for(var counter = arguments.numberFrom; counter < arguments.numberTo; counter+= arguments.stepNumber)
		{
			arguments.closure(counter);
		}
	}

	/**
	 * Iterates from this number up to the given number, inclusive, incrementing by one each time.
	 * Each number is passed through to the closure.
	 *
	 * @numberFrom the number to start at
	 * @numberTo the number to go to
	 * @closure the closure to call with the current count.
	 */
	public void function _upto(required numeric numberFrom, required numeric numberTo, required function closure)
	{
		_step(arguments.numberFrom, arguments.numberTo, 1, arguments.closure);
	}

	/**
	 * Executes the closure this many times, starting from zero. The current index is passed to the closure each time
	 *
	 * @number the number of times to execute the given closure
	 * @closure the closure to execute.
	 */
	public void function _times(required numeric number, required function closure)
	{
		_step(0, arguments.number, 1, arguments.closure);
	}
</cfscript>