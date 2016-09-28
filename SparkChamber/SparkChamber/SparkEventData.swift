/**
 *  SparkEventData.swift
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


// MARK: SparkEventData Protocol

/**
A protocol that defines the attachment of Spark Events to NSObject inheritors by extending NSObjectProtocol.
*/
@objc public protocol SparkEventData : NSObjectProtocol {
	var sparkEvents: [SparkEvent]? { get set }
}

// MARK: - Extensions

extension NSObject: SparkEventData {
	// MARK: - Public
	
	/** 
	An array of Spark events, used for tracking.
	
	- returns: An Array of Spark Events
	*/
	final public var sparkEvents: [SparkEvent]? {
		get {
			if let identifier = objc_getAssociatedObject(self, &SparkKeys.sparkEventsKey) as? [SparkEvent] {
				return identifier
			}
			return nil
		}
		
		set {
			objc_setAssociatedObject(self, &SparkKeys.sparkEventsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
		}
	}
	
	// MARK: - Private
	
	private struct SparkKeys {
		static var sparkEventsKey = "sparkEvents"
	}
}
