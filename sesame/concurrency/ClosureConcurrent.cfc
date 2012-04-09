/*
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
*/

/**
 * Implementation of java.util.Runnable and java.util.concurrent.Callable that takes a closure and runs it.
 */
component accessors="true"
{
	property func;
	property args;

	/**
	 * Constructor
	 *
	 * @func The function/closure to be called.
	 * @args the arguments to pass through. Defaults to none.
	 */
	public ClosureConcurrent function init(required function func, struct args={})
	{
		setFunc(arguments.func);
		setArgs(args);
		return this;
	}

	/**
	 * Call the function, and returns nothing.
	 */
	public void function run()
	{
		variables.func(argumentCollection=variables.args);
	}

	/**
	 * Call the function, and returns it's value
	 */
	public any function call()
	{
		return variables.func(argumentCollection=variables.args);
	}

	/**
	 * convert to runnable
	 */
	public any function toRunnable()
	{
		return createDynamicProxy(this, ["java.lang.Runnable"]);
	}

	/**
	 * convert to Callable
	 */
	public any function toCallable()
	{
		return createDynamicProxy(this, ["java.util.concurrent.Callable"]);
	}
}