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
	 * @numberOfThreads number of threads to use in the thread pool for processing.
	 */
	public void function _eachParallel(required any data, required function closure, numeric numberOfThreads=5)
	{
		var futures = [];
		var executorService = createObject("java", "java.util.concurrent.Executors").newFixedThreadPool(arguments.numberOfThreads);
		var _closure = arguments.closure;

		if(isArray(arguments.data))
		{
			for(var item in arguments.data)
			{
				var args ={1=item};
				var runnable = new sesame.concurrency.ClosureRunnable(_closure, args);

				runnable = createDynamicProxy(runnable, ["java.lang.Runnable"]);

				var future = executorService.submit(runnable);

				arrayAppend(futures, future);
			}
		}

		if(isStruct(arguments.data))
		{
			for(var key in arguments.data)
			{
				var args ={1=key, 2=arguments.data[key]};
				var runnable = new sesame.concurrency.ClosureRunnable(_closure, args);

				runnable = createDynamicProxy(runnable, ["java.lang.Runnable"]);

				var future = executorService.submit(runnable);

				arrayAppend(futures, future);
			}
		}

		//join it all back up
		ArrayEach(futures, function(it) { it.get(); });
	}

</cfscript>