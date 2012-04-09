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



	Make it easier to do things in parallel.
	They can put objects in the request scope, under the key 'sesame-concurrency-es'
--->

<cfscript>
	/**
	 * Do each iteration in it's own thread, and then join it all back again at the end.
	 *
	 * @data the array/struct to perform a closure on
	 * @closure the closure to pass through the elements from data to.
	 * @numberOfThreads number of threads to use in the thread pool for processing. (Only needed if you aren't using _withPool())
	 */
	public void function _eachParallel(required any data, required function closure, numeric numberOfThreads=5)
	{
		var futures = [];
		var _closure = arguments.closure;

		if(!structKeyExists(request, "sesame-concurrency-es"))
		{
			var executorService = createObject("java", "java.util.concurrent.Executors").newFixedThreadPool(arguments.numberOfThreads);
			var shutDownEs = true;
		}
		else
		{
			var executorService = request["sesame-concurrency-es"];
			var shutDownEs = false;
		}

		try
		{
			if(isArray(arguments.data))
			{
				for(var item in arguments.data)
				{
					var args ={1=item};
					var runnable = new sesame.concurrency.ClosureConcurrent(_closure, args);

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
					var runnable = new sesame.concurrency.ClosureConcurrent(_closure, args);

					var future = executorService.submit(runnable.toRunnable());

					arrayAppend(futures, future);
				}
			}

			//join it all back up
			ArrayEach(futures, function(it) { it.get(); });
		}
		catch(Any exc)
		{
			rethrow;
		}
		finally
		{
			if(shutDownEs)
			{
				executorService.shutdown();
			}
		}
	}
	
	/**
	 * This function allows you to share the underlying ExecutorService with multiple concurrent methods.<br/>
	 * For example, this shares a threadpool of 10 threads across multiple _eachParrallel calls:<br/>
	 * _withPool( 10, function() {<br/>
	 * _eachParrallel(array, function() { ... });<br/>
	 * _eachParrallel(array, function() { ... });<br/>
	 * _eachParrallel(array, function() { ... });<br/>
	 * });
	 *
	 * @numberOfThreads the number of threads to use in the thread pool for processing.
	 * @closure the closure that contains the calls to other concurrent library functions.
	 */
	public void function _withPool(required numeric numberOfThreads, required function closure)
	{
		request["sesame-concurrency-es"] = createObject("java", "java.util.concurrent.Executors").newFixedThreadPool(arguments.numberOfThreads);

		try
		{
			arguments.closure();
		}
		catch(Any exc)
		{
			rethrow;
		}
		finally
		{
			request["sesame-concurrency-es"].shutdown();
			StructDelete(request, "sesame-concurrency-es");
		}
	}
	
	/**
	 * Run the closure in a thread. Must be run inside a _withPool() block to set up the ExecutorService, and close it off at the end.
	 * For example:<br/>
	 * _withPool( 10, function() {<br/>
	 * _thread(function() { ... });<br/>
	 * _thread(function() { ... });<br/>
	 * });
	 *<br/>
	 * Return an instance of java.util.concurrent.Future to give you control over the closure, and/or retrieve the value returned from the closure.
	 *
	 * @closure the closure to call asynchronously
	 */
	public any function _thread(required function closure)
	{
		var executorService = request["sesame-concurrency-es"];
		var callable = new sesame.concurrency.ClosureConcurrent(arguments.closure);

		return executorService.submit(callable.toCallable());
	}
</cfscript>