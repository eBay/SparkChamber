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
	
	func testSparkEventDefaultInit() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.none, trace: "foo") {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		
		XCTAssertNotNil(sparkEvent, "A Spark Event wasn't returned after having been set using the default initializer.")
		XCTAssertNotNil(sparkEvent.trigger, "A Spark Event's trigger wasn't returned after having been set using the default initializer.")
		XCTAssert(sparkEvent.trigger == SparkTriggerType.none, "A Spark Event's trigger didn't match what was set using the default initializer.")
		XCTAssertNotNil(sparkEvent.trace, "A Spark Event's trace wasn't returned after having been set using the default initializer.")
		XCTAssert(sparkEvent.trace == "foo", "A Spark Event's trace didn't match what was set using the default initializer.")
		XCTAssertNotNil(sparkEvent.identifier, "A Spark Event's default identifier value wasn't returned after having been set using the default initializer.")
		XCTAssertNotNil(sparkEvent.action, "A Spark Event's action wasn't returned after having been set using the default initializer.")
	}
	
	func testSparkEventConvenienceInitWithTriggerTraceIdentifierAndAction() {
		let identifier = UUID()
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.none, trace: "foo", identifier: identifier) {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		
		XCTAssertNotNil(sparkEvent, "A Spark Event wasn't returned when using a convenience initializer.")
		XCTAssertNotNil(sparkEvent.trigger, "A Spark Event's trigger wasn't returned after having been set using a convenience initializer.")
		XCTAssert(sparkEvent.trigger == SparkTriggerType.none, "A Spark Event's trigger didn't match what was set using a convenience initializer.")
		XCTAssertNotNil(sparkEvent.trace, "A Spark Event's trace wasn't returned after having been set using a convenience initializer.")
		XCTAssert(sparkEvent.trace == "foo", "A Spark Event's trace didn't match what was set using a convenience initializer.")
		XCTAssertNotNil(sparkEvent.identifier, "A Spark Event's identifier wasn't returned after having been set using a convenience initializer.")
		XCTAssert(sparkEvent.identifier == identifier, "A Spark Event's identifier didn't match what was set using a convenience initializer.")
		XCTAssertNotNil(sparkEvent.action, "A Spark Event's action wasn't returned after having been set using a convenience initializer.")
	}
	
	func testSparkEventConvenienceInitWithTriggerAndAction() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.none) {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}

		XCTAssertNotNil(sparkEvent, "A Spark Event wasn't returned when using the convenience initializer.")
		XCTAssertNotNil(sparkEvent.trigger, "A Spark Event's trigger wasn't returned after having been set using a convenience initializer.")
		XCTAssert(sparkEvent.trigger == SparkTriggerType.none, "A Spark Event's trigger didn't match what was set using a convenience initializer.")
		XCTAssertNil(sparkEvent.trace, "A Spark Event's trace didn't return nil after having been set using a convenience initializer.")
		XCTAssertNotNil(sparkEvent.identifier, "A Spark Event's default identifier value wasn't returned after having been set using  a convenience initializer.")
		XCTAssertNotNil(sparkEvent.action, "A Spark Event's action wasn't returned after having been set using a convenience initializer.")
	}
	
	func testSparkEventInitWithNilTrace() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.none, trace: nil) {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		
		XCTAssertNotNil(sparkEvent, "A Spark Event wasn't returned after having been set without a trace.")
		XCTAssertNotNil(sparkEvent.trigger, "A Spark Event's trigger wasn't returned after having been set using a convenience initializer.")
		XCTAssert(sparkEvent.trigger == SparkTriggerType.none, "A Spark Event's trigger didn't match what was set using a convenience initializer.")
		XCTAssertNil(sparkEvent.trace, "A Spark Event's trace didn't return nil after having been set using a convenience initializer.")
		XCTAssertNotNil(sparkEvent.identifier, "A Spark Event's default identifier value wasn't returned after having been set using  a convenience initializer.")
		XCTAssertNotNil(sparkEvent.action, "A Spark Event's action wasn't returned after having been set using a convenience initializer.")
	}
	
	func testSparkEventInitWithNilIdentifier() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.none, trace: "foo", identifier: nil) {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		
		XCTAssertNotNil(sparkEvent, "A Spark Event wasn't returned after having been set without a trace.")
		XCTAssertNotNil(sparkEvent.trigger, "A Spark Event's trigger wasn't returned after having been set using a convenience initializer.")
		XCTAssert(sparkEvent.trigger == SparkTriggerType.none, "A Spark Event's trigger didn't match what was set using a convenience initializer.")
		XCTAssertNotNil(sparkEvent.trace, "A Spark Event's trace wasn't returned after having been set using a convenience initializer.")
		XCTAssert(sparkEvent.trace == "foo", "A Spark Event's trace didn't match what was set using a convenience initializer.")
		XCTAssertNil(sparkEvent.identifier, "A Spark Event's identifier didn't return nil after having been set using a convenience initializer.")
		XCTAssertNotNil(sparkEvent.action, "A Spark Event's action wasn't returned after having been set using a convenience initializer.")
	}
	
	func testSparkEventInitWithNilAction() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.none, trace: "foo", action: nil)
		
		XCTAssertNotNil(sparkEvent, "A Spark Event wasn't returned after having been set without a closure.")
		XCTAssertNotNil(sparkEvent.trigger, "A Spark Event's trigger wasn't returned after having been set using a convenience initializer.")
		XCTAssert(sparkEvent.trigger == SparkTriggerType.none, "A Spark Event's trigger didn't match what was set using a convenience initializer.")
		XCTAssertNotNil(sparkEvent.trace, "A Spark Event's trace wasn't returned after having been set using a convenience initializer.")
		XCTAssert(sparkEvent.trace == "foo", "A Spark Event's trace didn't match what was set using a convenience initializer.")
		XCTAssertNotNil(sparkEvent.identifier, "A Spark Event's default identifier value wasn't returned after having been set using  a convenience initializer.")
		XCTAssertNil(sparkEvent.action, "A Spark Event's action didn't return nil after having been set using a convenience initializer.")
	}
	
	func testSparkEventCopyWithZone() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.none, trace: "foo") {
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

		let identifier = UUID()
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.none, trace: "foo", identifier: identifier, action: sparkAction)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.none, trace: "foo", identifier: identifier, action: sparkAction)
		
		XCTAssert(sparkEventOne == sparkEventTwo, "Two Spark Events with the same data didn't prove equivalent using ==, and should have.")
		XCTAssert(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with the same data didn't prove equivalent using isEqual(), and should have.")
	}
	
	func testSparkEventTriggerIsNotEqual() {
		let identifier = UUID()
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.didAppear, trace: "foo", identifier: identifier, action: nil)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.none,  trace: "foo", identifier: identifier, action: nil)
		
		XCTAssertFalse(sparkEventOne == sparkEventTwo, "Two Spark Events with dissimilar data didn't fail equivalence using ==, and should have.")
		XCTAssertFalse(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with dissimilar data didn't fail equivalence using isEqual(), and should have.")
	}
	
	func testSparkEventRightActionIsNil() {
		let identifier = UUID()
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.none, trace: nil, identifier: identifier) {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.none, trace: nil, identifier: identifier, action: nil)

		
		XCTAssertFalse(sparkEventOne == sparkEventTwo, "Two Spark Events with dissimilar data didn't fail equivalence using ==, and should have.")
		XCTAssertFalse(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with dissimilar data didn't fail equivalence using isEqual(), and should have.")
	}
	
	func testSparkEventLeftActionIsNil() {
		let identifier = UUID()
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.none, trace: nil, identifier: identifier, action: nil)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.none, trace: nil, identifier: identifier) {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		
		XCTAssertFalse(sparkEventOne == sparkEventTwo, "Two Spark Events with dissimilar data didn't fail equivalence using ==, and should have.")
		XCTAssertFalse(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with dissimilar data didn't fail equivalence using isEqual(), and should have.")
	}
	
	func testSparkEventBothActionsAreNil() {
		let identifier = UUID()
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.none, trace: nil, identifier: identifier, action: nil)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.none, trace: nil, identifier: identifier, action: nil)
		
		XCTAssert(sparkEventOne == sparkEventTwo, "Two Spark Events with the same data didn't prove equivalent using ==, and should have.")
		XCTAssert(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with the same data didn't prove equivalent using isEqual(), and should have.")
	}
	
	func testSparkEventTraceIsNotEqual() {
		let identifier = UUID()
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.none, trace: "foo", identifier: identifier, action: nil)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.none, trace: "oof", identifier: identifier, action: nil)
		
		XCTAssertFalse(sparkEventOne == sparkEventTwo, "Two Spark Events with dissimilar data didn't fail equivalence using ==, and should have.")
		XCTAssertFalse(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with dissimilar data didn't fail equivalence using isEqual(), and should have.")
	}
	
	func testSparkEventIdentifierIsEqual() {
		let identifier = UUID()
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.none, trace: nil, identifier: identifier, action: nil)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.none, trace: nil, identifier: identifier, action: nil)
		
		XCTAssert(sparkEventOne == sparkEventTwo, "Two Spark Events with the same data didn't prove equivalent using ==, and should have.")
		XCTAssert(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with the same data didn't prove equivalent using isEqual(), and should have.")
	}
	
	func testSparkEventIdentifierIsNotEqual() {
		let sparkEventOne = SparkEvent(trigger: SparkTriggerType.none, action: nil)
		let sparkEventTwo = SparkEvent(trigger: SparkTriggerType.none, action: nil)
		
		XCTAssertFalse(sparkEventOne == sparkEventTwo, "Two Spark Events with dissimilar data didn't fail equivalence using ==, and should have.")
		XCTAssertFalse(sparkEventOne.isEqual(sparkEventTwo), "Two Spark Events with dissimilar data didn't fail equivalence using isEqual(), and should have.")
	}
	
	func testSparkEventIsNotEqualToObject() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.none, trace: "foo") {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		
		let object = NSObject()
		
		XCTAssertFalse(sparkEvent == object, "A Spark Event and an NSObject didn't fail equivalence using ==, and should have.")
		XCTAssertFalse(sparkEvent.isEqual(object), "A Spark Event and an NSObject didn't fail equivalence using isEqual:, and should have.")
	}
	
	func testSparkEventDescription() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.none, trace: "foo") {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}
		
		let description = sparkEvent.description
		let expectedDescription = "trigger = \(sparkEvent.trigger.description)\n   trace = \(sparkEvent.trace ?? "nil")\n   identifier = \(sparkEvent.identifier?.uuidString ?? "nil")\n   action = \(String(describing: sparkEvent.action))"
		
		XCTAssert(description.contains(expectedDescription), "A Spark Event didn't return its description correctly.")
	}
	
	func testSparkEventDescriptionWithNilTrace() {
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.none) {
			_ in
			print("success") // This is only here to make sure a non-empty action closure is present for the event.
		}

		let description = sparkEvent.description
		let expectedDescription = "trigger = \(sparkEvent.trigger.description)\n   trace = \(sparkEvent.trace ?? "nil")\n   identifier = \(sparkEvent.identifier?.uuidString ?? "nil")\n   action = \(String(describing: sparkEvent.action))"
		
		XCTAssert(description.contains(expectedDescription), "A Spark Event didn't return its description correctly.")
	}
	
	func testSparkTriggerDescription() {
		let eventTypeNone = SparkTriggerType.none.description
		XCTAssert(eventTypeNone == "none", "The Spark Event's description for the event type '.none' was returned incorrectly.")
		
		let eventTypeDidAppear = SparkTriggerType.didAppear.description
		XCTAssert(eventTypeDidAppear == "didAppear", "The Spark Event's description for the event type '.didAppear' was returned incorrectly.")
		
		let eventTypeDidDisappear = SparkTriggerType.didDisappear.description
		XCTAssert(eventTypeDidDisappear == "didDisappear", "The Spark Event's description for the event type '.didDisappear' was returned incorrectly.")
		
		let eventTypeDidEndTouch = SparkTriggerType.didEndTouch.description
		XCTAssert(eventTypeDidEndTouch == "didEndTouch", "The Spark Event's description for the event type '.didEndTouch' was returned incorrectly.")
		
		let eventTypeDidBeginScroll = SparkTriggerType.didBeginScroll.description
		XCTAssert(eventTypeDidBeginScroll == "didBeginScroll", "The Spark Event's description for the event type '.didBeginScroll' was returned incorrectly.")
		
		let eventTypeDidBecomeFirstResponder = SparkTriggerType.didBecomeFirstResponder.description
		XCTAssert(eventTypeDidBecomeFirstResponder == "didBecomeFirstResponder", "The Spark Event's description for the event type '.didBecomeFirstResponder' was returned incorrectly.")

		let eventTypeDidResignFirstResponder = SparkTriggerType.didResignFirstResponder.description
		XCTAssert(eventTypeDidResignFirstResponder == "didResignFirstResponder", "The Spark Event's description for the event type '.didResignFirstResponder' was returned incorrectly.")
		
		let eventTypeTargetAction = SparkTriggerType.targetAction.description
		XCTAssert(eventTypeTargetAction == "targetAction", "The Spark Event's description for the event type '.targetAction' was returned incorrectly.")
	}
	
	func testSparkTriggerIsEqual() {
		let triggerOne = SparkTriggerType.didAppear
		let triggerTwo = SparkTriggerType.didAppear
		
		XCTAssertTrue(triggerOne == triggerTwo, "Two of the same Spark Triggers didn't prove equivalent using ==, and should have.")
	}
	
	func testSparkTriggerIsNotEqualToObject() {
		let trigger = SparkTriggerType.didAppear
		let object = NSObject()
		
		XCTAssertFalse(trigger == object, "A Spark Trigger and an NSObject didn't fail equivalence using ==, and should have.")
	}
	
	func testSparkEventSendWithAction() {
		let expectation: XCTestExpectation = self.expectation(description: "A Spark Event's action failed to execute.")
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.none) {
			_ in
			expectation.fulfill()
		}
		
		sparkEvent.send()
		
		waitForExpectations(timeout: 3.0, handler: nil)
	}
	
	func testSparkEventSendWithTrace() {
		SparkEventTests.expectation = self.expectation(description: "A Spark Trace with a single item failed to make it to its delegate.")
		
		class SparkTraceDelegateMock: SparkTraceDelegate {
			@objc func print(_ trace: String) {
				SparkEventTests.expectation.fulfill()
			}
		}
		
		SparkTrace.sharedInstance.delegate = SparkTraceDelegateMock()
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.none, trace: "foo", action: nil)
		sparkEvent.send()
		
		waitForExpectations(timeout: 3.0, handler: nil)
	}
}
