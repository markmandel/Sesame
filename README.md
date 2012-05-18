Hey Mark
<!--
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
-->

Sesame
======

> *"Then he thought within himself: "I too will try the virtue of those magical words and see if at my bidding the door will open and close." So he called out aloud, "Open, Sesame!" And no sooner had he spoken than straightway the portal flew open and he entered within."*<br/>
>	- [Ali Baba and the Forty Thieves, translated by Sir Richard Burton, 1850][1].

*Sesame* is a library of functions for use with closures.

All functions start with an underscore, so as to not collide with already existing ColdFusion or functions that you may have written in your page or component.

It currently has 4 sections:

- Collections: for the use with arrays and structs
- Functions: for the use with other functions and closures.
- Numbers: for use with numbers and general looping
- Concurrency: To make threading operations easier


## Collections ##

Functions that allow you manipulate and use structs and arrays much easier 

### _collect(any data, function transform) : array ###

collect data from a array, structure or query into a whole new array. Transform closure should return the item that i to be added to the new array. 

* data - the array / struct / query to collect from 
* transform - closure to return the item for the new array 

### _collectEntries(any data, function transform) : struct ###

collect data from an array, struct or query into a new struct. The transform function can return either a Map, with a single key to be used as the key, and a 2nd level struct, or an array, where the 1st index in the key, and the 2nd is the value. 

* data - the array / struct / query to collect from 
* transform - the closure to create the map entry. 

### _groupBy(any data, function grouping) : struct ###

Take an array/struct and group the data into a grouped struct. The closure should return the key that the data should be grouped by. For arrays, this will return a struct of arrays. For structs, this will return a struct of structures. 

* data - the array / struct 
* grouping - the closure to return the group key. 

### _queryEach(query data, [function func]) : any ###

Iterates over a query and executes the closure on each row. 

* data - the query 
* func - the closure 

### _unique(any data, [function comparator]) : any ###

Returns an array with all the duplicates removed (i.e. unique). For structs, this iterates through all the values, and returns an array from that, with duplicates removed. 

* data - the array/struct 
* comparator - optional comparator closure that takes 2 arguments for comparing of objects, and returns 0 if they are the same. If not supplied, then natural comparison will be used. 

## Functions ##

Functions that allow you to manipulate other functions / closures 

### _curry(function func, array args) : function ###

Curry a function from left to right. 

* func - the function/closure you want to curry 
* args - the array of arguments you wish to curry with. 

## Numbers ##

Functions for working with numbers and general looping 

### _step(numeric numberFrom, numeric numberTo, numeric stepNumber, function closure) : void ###

Iterates from a given number, up to a given number, using a step increment. Each number is passed through to the closure. 

* numberFrom - the number to start at 
* numberTo - the number to go to 
* stepNumber - the step to take between iterations 
* closure - the closure to call with the current count. 

### _times(numeric number, function closure) : void ###

Executes the closure this many times, starting from zero. The current index is passed to the closure each time 

* number - the number of times to execute the given closure 
* closure - the closure to execute. 

### _upto(numeric numberFrom, numeric numberTo, function closure) : void ###

Iterates from this number up to the given number, inclusive, incrementing by one each time. Each number is passed through to the closure. 

* numberFrom - the number to start at 
* numberTo - the number to go to 
* closure - the closure to call with the current count. 

## Concurrency ##


Functions for working with threads and concurrent programmings

*Please Note*: To use this concurrency library, there will need to be a mapping to /sesame, or /sesame will need to be in the root of your project, as there are components
that need to be instantiated to interact with the Java concurrency libraries.


### _eachParallel(any data, function closure, [numeric numberOfThreads=5]) : void ###

Do each iteration in it's own thread, and then join it all back again at the end. 

* data - the array/struct to perform a closure on 
* closure - the closure to pass through the elements from data to. 
* numberOfThreads - number of threads to use in the thread pool for processing. (Only needed if you aren't using _withPool()) 

### _thread(function closure) : any ###

Run the closure in a thread. Must be run inside a _withPool() block to set up the ExecutorService, and close it off at the end. For example:<br/> _withPool( 10, function() {<br/> _thread(function() { ... });<br/> _thread(function() { ... });<br/> }); <br/> Return an instance of java.util.concurrent.Future to give you control over the closure, and/or retrieve the value returned from the closure. 

* closure - the closure to call asynchronously 

### _withPool(numeric numberOfThreads, function closure) : void ###

This function allows you to share the underlying ExecutorService with multiple concurrent methods.<br/> For example, this shares a threadpool of 10 threads across multiple _eachParrallel calls:<br/> _withPool( 10, function() {<br/> _eachParrallel(array, function() { ... });<br/> _eachParrallel(array, function() { ... });<br/> _eachParrallel(array, function() { ... });<br/> }); 

* numberOfThreads - the number of threads to use in the thread pool for processing. 
* closure - the closure that contains the calls to other concurrent library functions. 


Contributions
-------------
Please feel free to fork this project and contribute.

Do note that the readme is generated by the `generate.cfm` file, which creates the documentation from the function hint meta data.
So if your functions are properly commented, the documentation can be updated automatically.

Therefore, if you want to contribute to the documentation, please do so in the relevent functions comments, so that it ends up in the README.md on regeneration.

Thanks!!!

[1]: http://classiclit.about.com/library/bl-etexts/arabian/bl-arabian-alibaba.htm
