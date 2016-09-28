/**
 *  SparkEventTests.swift
 *  SparkChamberTests
 *
 *  Created by Steve Elliott on 02/09/2016.
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


class SparkEventTests: XCTestCase {
	static var expectation: XCTestExpectation = XCTestExpectation()

	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testSparkEventConvenienceInitWithTriggerAndAction() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.None, action: nil)
		
		XCTAssertNotNil(sparkEvent, "A Spark Event wasn't returned when using the convenience initializer.")
	}
	
	func testSparkEventConvenienceInitWithTriggerActionAndTrace() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.None, trace: nil, action: nil)
		
		XCTAssertNotNil(sparkEvent, "A Spark Event wasn't returned when using the convenience initializer.")
	}
	
	func testSparkEventInitWithoutTrace() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.None, trace: nil, identifier: nil, action: nil)
		
		XCTAssertNotNil(sparkEvent, "A Spark Event wasn't returned after having been set without a trace.")
	}
	
	func testSparkEventInitWithoutClosure() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: nil, action: nil)
		
		XCTAssertNotNil(sparkEvent, "A Spark Event wasn't returned after having been set without a closure.")
	}
	
	func testSparkEventInitWithParams() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar") {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		
		XCTAssertNotNil(sparkEvent, "A Spark Event wasn't returned after having been set with parameters.")
	}
	
	func testSparkEventCopyWithZone() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar") {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		let sparkEventCopy = sparkEvent.copy() as! SparkEvent
		
		XCTAssert(sparkEvent == sparkEventCopy, "A Spark Event didn't copy correctly using copy()/copyWithZone().")
	}
	
	func testSparkEventIsEqual() {
		let sparkAction: SparkEventActionBlock = {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}

		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar", action: sparkAction)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar", action: sparkAction)
		
		XCTAssert(sparkEventOne == sparkEventTwo, "Two Spark Events with the same data didn't prove equivalent using ==, and should have.")
		XCTAssert(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with the same data didn't prove equivalent using isEqual(), and should have.")
	}
	
	func testSparkEventTriggerIsNotEqual() {
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.DidAppear, trace: "foo", identifier: "bar", action: nil)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar", action: nil)
		
		XCTAssertFalse(sparkEventOne == sparkEventTwo, "Two Spark Events with dissimilar data didn't fail equivalence using ==, and should have.")
		XCTAssertFalse(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with dissimilar data didn't fail equivalence using isEqual(), and should have.")
	}
	
	func testSparkEventRightActionIsNil() {
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar")  {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar", action: nil)

		
		XCTAssertFalse(sparkEventOne == sparkEventTwo, "Two Spark Events with dissimilar data didn't fail equivalence using ==, and should have.")
		XCTAssertFalse(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with dissimilar data didn't fail equivalence using isEqual(), and should have.")
	}
	
	func testSparkEventLeftActionIsNil() {
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar", action: nil)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar") {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		
		XCTAssertFalse(sparkEventOne == sparkEventTwo, "Two Spark Events with dissimilar data didn't fail equivalence using ==, and should have.")
		XCTAssertFalse(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with dissimilar data didn't fail equivalence using isEqual(), and should have.")
	}
	
	func testSparkEventBothActionsAreNil() {
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar", action: nil)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar", action: nil)
		
		XCTAssert(sparkEventOne == sparkEventTwo, "Two Spark Events with the same data didn't prove equivalent using ==, and should have.")
		XCTAssert(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with the same data didn't prove equivalent using isEqual(), and should have.")
	}
	
	func testSparkEventTraceIsNotEqual() {
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar", action: nil)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.None, trace: "oof", identifier: "bar", action: nil)
		
		XCTAssertFalse(sparkEventOne == sparkEventTwo, "Two Spark Events with dissimilar data didn't fail equivalence using ==, and should have.")
		XCTAssertFalse(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with dissimilar data didn't fail equivalence using isEqual(), and should have.")
	}
	
	func testSparkEventIdentifierIsNotEqual() {
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "rab", action: nil)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar", action: nil)
		
		XCTAssertFalse(sparkEventOne == sparkEventTwo, "Two Spark Events with dissimilar data didn't fail equivalence using ==, and should have.")
		XCTAssertFalse(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with dissimilar data didn't fail equivalence using isEqual(), and should have.")
	}
	
	func testSparkEventIsNotEqualToObject() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar") {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		
		let object = NSObject()
		
		XCTAssertFalse(sparkEvent == object, "A Spark Pulsar Event and an NSObject didn't fail equivalence using ==, and should have.")
		XCTAssertFalse(sparkEvent.isEqual(object), "A Spark Pulsar Event and an NSObject didn't fail equivalence using isEqual:, and should have.")
	}
	
	func testSparkEventDescription() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", identifier: "bar") {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		
		let description = sparkEvent.description
		let expectedDescription = "trigger = \(sparkEvent.trigger.description)\n   trace = \(sparkEvent.trace ?? "nil")\n   identifier = \(sparkEvent.identifier ?? "nil")\n   action = \(sparkEvent.action)"
		
		XCTAssert(description.containsString(expectedDescription), "A Spark Event didn't return its description correctly.")
	}
	
	func testSparkEventDescriptionWithNilTrace() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.None) {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}

		let description = sparkEvent.description
		let expectedDescription = "trigger = \(sparkEvent.trigger.description)\n   trace = \(sparkEvent.trace ?? "nil")\n   identifier = \(sparkEvent.identifier ?? "nil")\n   action = \(sparkEvent.action)"
		
		XCTAssert(description.containsString(expectedDescription), "A Spark Event didn't return its description correctly.")
	}
	
	func testSparkEventTriggerTypeDescription() {
		let eventTypeNone = SparkTriggerType.None.description
		XCTAssert(eventTypeNone == "None", "The Spark Event's description for the event type '.None' was returned incorrectly.")
		
		let eventTypeDidAppear = SparkTriggerType.DidAppear.description
		XCTAssert(eventTypeDidAppear == "DidAppear", "The Spark Event's description for the event type '.DidAppear' was returned incorrectly.")
		
		let eventTypeDidDisappear = SparkTriggerType.DidDisappear.description
		XCTAssert(eventTypeDidDisappear == "DidDisappear", "The Spark Event's description for the event type '.DidDisappear' was returned incorrectly.")
		
		let eventTypeDidEndTouch = SparkTriggerType.DidEndTouch.description
		XCTAssert(eventTypeDidEndTouch == "DidEndTouch", "The Spark Event's description for the event type '.DidEndTouch' was returned incorrectly.")
		
		let eventTypeDidBeginScroll = SparkTriggerType.DidBeginScroll.description
		XCTAssert(eventTypeDidBeginScroll == "DidBeginScroll", "The Spark Event's description for the event type '.DidBeginScroll' was returned incorrectly.")
		
		let eventTypeTargetAction = SparkTriggerType.TargetAction.description
		XCTAssert(eventTypeTargetAction == "TargetAction", "The Spark Event's description for the event type '.TargetAction' was returned incorrectly.")
		
		let eventTypeDidSelect = SparkTriggerType.DidSelect.description
		XCTAssert(eventTypeDidSelect == "DidSelect", "The Spark Event's description for the event type '.DidSelect' was returned incorrectly.")
		
		let eventTypeDidDeselect = SparkTriggerType.DidDeselect.description
		XCTAssert(eventTypeDidDeselect == "DidDeselect", "The Spark Event's description for the event type '.DidDeselect' was returned incorrectly.")
}
	
	func testSparkEventSendWithAction() {
		let expectation: XCTestExpectation = expectationWithDescription("A Spark Event's action failed to execute.")
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.None) {
			_ in
			expectation.fulfill()
		}
		
		sparkEvent.send()
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
	
	func testSparkEventSendWithTrace() {
		SparkEventTests.expectation = expectationWithDescription("A Spark Trace with a single item failed to make it to its delegate.")
		
		class SparkTraceDelegateMock: SparkTraceDelegate {
			@objc func print(trace: String) {
				SparkEventTests.expectation.fulfill()
			}
		}
		
		SparkTrace.sharedInstance.delegate = SparkTraceDelegateMock()
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.None, trace: "foo", action: nil)
		sparkEvent.send()
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
}
