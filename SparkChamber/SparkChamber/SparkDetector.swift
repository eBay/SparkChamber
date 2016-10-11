/**
 *  SparkDetector.swift
 *  SparkChamber
 *
 *  Created by Steve Elliott on 01/27/2016.
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


// MARK: Classes

/**
Spark Detector is the engine that acts as a discriminator and executor for appropriate events. Spark Detector is invoked either from SparkKit or from your app's UIKit subclasses.

The basic implementation of this class provides shared functionality. Extensions provide platform-specific implementations.
*/
@objc final public class SparkDetector: NSObject {
	// MARK: - Internal
	
	/**
	Takes a collection of Spark Events and calls each of their send() functions.
	
	- parameter events: An Array of SparkEvents to send
	- returns: A boolean flag if any incoming event successfully sends
	*/
	class func send(_ events: [SparkEvent]) -> Bool {
		var result = false

		for event in events {
			let success = event.send()
			if success {
				result = success
			}
		}
		
		return result
	}
}
