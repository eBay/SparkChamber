/**
 *  SparkMetaDataTests.swift
 *  SparkChamberTests
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

import XCTest
@testable import SparkChamber


class SparkEventDataTests: XCTestCase {
	let object = NSObject()
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		object.sparkEvents = nil
		
		super.tearDown()
	}
	
	func testSparkEvents() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didAppear, trace: "foo", action: nil)
		object.sparkEvents = [sparkEvent]
		
		let events = object.sparkEvents
		XCTAssert(events! == [sparkEvent], "Spark events weren't returned after having been set.")
	}
	
	func testSparkEventsWithOtherAssociatedObjectsPresent() {
		// First, attach an unrelated associated object
		let foo = "foo"
		var fooKey = "fooKey"
		objc_setAssociatedObject(object, &fooKey, foo, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
		
		// Second, set the spark events for the object
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didAppear, trace: "foo", action: nil)
		object.sparkEvents = [sparkEvent]
		
		let events = object.sparkEvents
		XCTAssert(events! == [sparkEvent], "Spark events weren't returned after having been set.")
		
		let otherAasociatedObjects = objc_getAssociatedObject(object, &fooKey) as? String
		XCTAssert(otherAasociatedObjects == foo, "Other associated objects weren't in place when they shouldn't have been.")
	}
	
	func testNilSparkEvents() {
		// First, set the spark events for the object
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didAppear, trace: "foo", action: nil)
		object.sparkEvents = [sparkEvent]
		
		// Then, nil it out
		object.sparkEvents = nil

		let events = object.sparkEvents
		XCTAssertNil(events, "A nil events object wasn't returned when expected.")
	}
	
	func testNilSparkEventsWithOtherAssociatedObjectsPresent() {
		// First, attach an unrelated associated object
		let foo = "foo"
		var fooKey = "fooKey"
		objc_setAssociatedObject(object, &fooKey, foo, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)

		// Second, set the spark events for the object
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didAppear, trace: "foo", action: nil)
		object.sparkEvents = [sparkEvent]
		
		// Then, nil out the spark events
		object.sparkEvents = nil
		
		let events = object.sparkEvents
		XCTAssertNil(events, "A nil events object wasn't returned when expected.")
		
		let otherAasociatedObjects = objc_getAssociatedObject(object, &fooKey) as? String
		XCTAssert(otherAasociatedObjects == foo, "Other associated objects weren't in place when they shouldn't have been.")
	}
}
