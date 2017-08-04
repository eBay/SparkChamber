/**
 *  SparkTrace.swift
 *  SparkChamber
 *
 *  Created by Steve Elliott on 02/26/2016.
 *  Copyright (c) 2016 eBay Software Foundation.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 **/

import Foundation


// MARK: SparkTraceDelegate Protocol

/**
A protocol that defines the necessary function required for a delegate to print/process traces.
*/
@objc public protocol SparkTraceDelegate {
	func print(_ trace: String)
}

// MARK: - Classes

/**
Spark Trace is the engine that enables the printing of Spark Event traces to the standard output, or optionally to a delegate.
*/
@objc final public class SparkTrace: NSObject {
	// MARK: - Public
	
	/**
	The Spark Trace shared instance.
	*/
	public static let sharedInstance = SparkTrace()
	
	/**
	The last output from the class. Used for testing purposes.
	*/
	var lastOutput: String?
	
	/**
	An optional SparkTraceDelegate for the class. Used to redirect output to an external logging infrastructure.
	*/
	public var delegate: SparkTraceDelegate?
	
	/**
	Writes the textual representations of items, separated by separator and terminated by terminator, into either a supplied delegate or the standard output.
	
	The textual representations are obtained for each item via the expression String(item).
	
	- parameter items: Zero or more items to print
	- parameter separator: A string to print between each item - the default is a single space (" ")
	- parameter terminator: The string to print after all items have been printed - the default is a newline ("\n")
	
	- note: To print without a trailing newline, pass terminator: ""
	*/
	class func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
		SparkTrace.sharedInstance.print(items, separator: separator, terminator: terminator)
	}
	
	// MARK: - Private
	
	override fileprivate init() {} // Prevent initialization of our class to guarantee the singleton's singularity.
	
	fileprivate func print(_ items: [Any], separator: String, terminator: String) {
		var output: String = ""
		for (index, item) in items.enumerated() {
			output += String(describing: item)
			if (index + 1 < items.endIndex) {
				output += separator
			}
		}
		
		if let delegate = delegate {
			delegate.print(output)
		} else {
			#if DEBUG
				Swift.print(output)
			#endif
		}
		
		lastOutput = output
	}
}
