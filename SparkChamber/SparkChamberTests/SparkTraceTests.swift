/**
 *  SparkTraceTests.swift
 *  SparkChamberTests
 *
 *  Created by Steve Elliott on 04/19/2016.
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


class SparkTraceTests: XCTestCase {
	static var expectation: XCTestExpectation = XCTestExpectation()
	let sparkTrace = SparkTrace.sharedInstance

	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		sparkTrace.delegate = nil
		
		super.tearDown()
	}
	
	func testSparkTraceSharedInstance() {
		XCTAssertNotNil(sparkTrace, "The Spark Trace's shared instance wasn't returned correctly.")
	}

	func testSparkTraceDelegate() {
		class SparkTraceDelegateMock: SparkTraceDelegate {
			@objc func print(_ trace: String) {
				// Nothing to do here for this test.
			}
		}
		
		sparkTrace.delegate = SparkTraceDelegateMock()
		
		XCTAssertNotNil(sparkTrace.delegate, "The Spark Trace's delegate wasn't returned correctly.")
	}
	
	func testSparkTracePrint() {
		SparkTrace.print("foo")
		
		XCTAssert(SparkTrace.sharedInstance.lastOutput == "foo", "A Spark Trace with a single item failed to print correctly.")
	}
	
	func testSparkTracePrintMulti() {
		SparkTrace.print("foo", "bar")
		
		XCTAssert(SparkTrace.sharedInstance.lastOutput == "foo bar", "A Spark Trace with a multiple items failed to print correctly.")
	}
	
	func testSparkTracePrintWithDelegate() {
		SparkTraceTests.expectation = self.expectation(description: "A Spark Trace with a single item failed to make it to its delegate.")
		
		class SparkTraceDelegateMock: SparkTraceDelegate {
			@objc func print(_ trace: String) {
				XCTAssert(trace == "foo", "A Spark Trace with a single item failed to print correctly.")
				SparkTraceTests.expectation.fulfill()
			}
		}
		
		sparkTrace.delegate = SparkTraceDelegateMock()
		SparkTrace.print("foo")
		
		waitForExpectations(timeout: 3.0, handler: nil)
	}
	
	func testSparkTracePrintMultiWithDelegate() {
		class SparkTraceDelegateMock: SparkTraceDelegate {
			@objc func print(_ trace: String) {
				XCTAssert(trace == "foo bar", "A Spark Trace with a multiple items failed to print correctly.")
				SparkTraceTests.expectation.fulfill()
			}
		}
		
		SparkTraceTests.expectation = self.expectation(description: "A Spark Trace with multiple items failed to make it to its delegate.")
		
		sparkTrace.delegate = SparkTraceDelegateMock()
		SparkTrace.print("foo", "bar")
		
		waitForExpectations(timeout: 3.0, handler: nil)
	}
}
