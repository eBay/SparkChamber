/**
 *  SparkDetectorTests.swift
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


class SparkDetectorTests: XCTestCase {
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testSparkDetectorSendEmptyEvents() {
		let result = SparkDetector.send([])
		XCTAssertFalse(result, "The Spark Detector should have reported failure when sending an empty set of events, and didn't.")
	}
	
	func testSparkDetectorSendEvents() {
		let event: SparkEvent = SparkEvent(trigger: SparkTriggerType.DidAppear, trace: "foo", action: nil)
		
		let result = SparkDetector.send([event])
		XCTAssertTrue(result, "A Spark Event failed to be tracked.")
	}
}
