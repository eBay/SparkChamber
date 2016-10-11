/**
 *  SparkDetector+UIKitTests.swift
 *  SparkChamberTests
 *
 *  Created by Steve Elliott on 02/10/2016.
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


private class UITouchMock : UITouch {
	var _phase: UITouchPhase = UITouchPhase.ended
	var _view: UIView = UIView()
	
	override var phase: UITouchPhase {
		get {
			return _phase
		}
		
		set {
			_phase = newValue
		}
	}
	
	override var view: UIView {
		get {
			return _view
		}
		
		set {
			_view = newValue
		}
	}
}

private class TouchInsideButtonMock: UIButton {
	override var isTouchInside: Bool {
		get {
			return true
		}
	}
}

private class PointInsideViewMock: UIView {
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return true
	}
}

private class PointInsideTableViewCellMock: UITableViewCell {
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return true
	}
}

private class UIScrollViewTrackingMock: UIScrollView {
	override var isTracking: Bool {
		get {
			return true
		}
	}
}

class SparkDetectorUIKitTests: XCTestCase {
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}

	func testSparkDetectorUIControlOutOfBoundTouchesReceived() {
		let button = UIButton()
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch, trace: "foo") {
			_ in
			XCTFail("A Spark Event's action block was triggered when it shouldn't have been.")
		}
		button.sparkEvents = [sparkEvent]
		
		let touch = UITouchMock()
		touch.view = button
		let fakeTouches: NSSet = [touch]
		
		let result = SparkDetector.trackEnded(touches: fakeTouches)
		XCTAssertFalse(result, "A Spark Event was tracked when it should have been ignored.")
	}
	
	func testSparkDetectorUIControlTouchesReceived() {
		let button = TouchInsideButtonMock()
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch, trace: "foo", action: nil)
		button.sparkEvents = [sparkEvent]
		
		let touch = UITouchMock()
		touch.view = button
		let fakeTouches: NSSet = [touch]
		
		let result = SparkDetector.trackEnded(touches: fakeTouches)
		XCTAssertTrue(result, "A Spark Event failed to be tracked.")
	}

	func testSparkDetectorUITableViewCellTouchesReceived() {
		let tableView = UITableView()
		let cell = UITableViewCell()
		tableView.addSubview(cell)
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch, trace: "foo", action: nil)
		cell.sparkEvents = [sparkEvent]
		
		let touch = UITouchMock()
		touch.view = cell.contentView
		let fakeTouches: NSSet = [touch]
		
		let result = SparkDetector.trackEnded(touches: fakeTouches)
		XCTAssertTrue(result, "A Spark Event failed to be tracked.")
	}

	func testSparkDetectorUIKitTrackTouches() {
		let touch = UITouchMock()
		let fakeTouches: NSSet = [touch]
		
		touch.view = PointInsideViewMock()
		touch.view.isUserInteractionEnabled = true
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch, trace: "foo", action: nil)
		touch.view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackEnded(touches: fakeTouches)
		XCTAssertTrue(result, "A Spark Event failed to be tracked.")
	}
	
	func testSparkDetectorUIKitTrackTouchesOutOfBound() {
		let touch = UITouchMock()
		let fakeTouches: NSSet = [touch]
		
		touch.view.isUserInteractionEnabled = true
		touch.view.bounds = CGRect.zero
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch, trace: "foo") {
			_ in
			XCTFail("A Spark Event's action block was triggered when it shouldn't have been.")
		}
		touch.view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackEnded(touches: fakeTouches)
		XCTAssertFalse(result, "A Spark Event was tracked when it should have been ignored.")
	}
	
	func testSparkDetectorUIKitTrackEmptyTouches() {
		let result = SparkDetector.trackEnded(touches: NSSet())
		XCTAssertFalse(result, "The Detector tracked touches when none were present.")
	}
	
	func testSparkDetectorUIKitTrackNonTouches() {
		let fakeTouches: NSSet = ["foo"]
		
		let result = SparkDetector.trackEnded(touches: fakeTouches)
		XCTAssertFalse(result, "The Detector tracked touches when none were present.")
	}
	
	func testSparkDetectorUIKitTrackTouchesWithUserInteractionDisabled() {
		let touch = UITouchMock()
		let fakeTouches: NSSet = [touch]
		
		touch.view = PointInsideViewMock()
		touch.view.isUserInteractionEnabled = false
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch, trace: "foo") {
			_ in
			XCTFail("A Spark Event's action block was triggered when it shouldn't have been.")
		}
		touch.view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackEnded(touches: fakeTouches)
		XCTAssertFalse(result, "A Spark Event was tracked when it should have been ignored.")
	}
	
	func testSparkDetectorUIKitTrackTouchesUnsupportedPhase() {
		let touch = UITouchMock()
		let fakeTouches: NSSet = [touch]
		
		touch.view = PointInsideViewMock()
		touch.view.isUserInteractionEnabled = true
		touch.phase = UITouchPhase.began
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch, trace: "foo") {
			_ in
			XCTFail("A Spark Event's action block was triggered when it shouldn't have been.")
		}
		touch.view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackEnded(touches: fakeTouches)
		XCTAssertFalse(result, "A Spark Event was tracked when it should have been ignored.")
	}
	
	func testSparkDetectorUIKitTrackTouchesWithEmptyViewStructure() {
		let touch = UITouchMock()
		let fakeTouches: NSSet = [touch]
		
		touch.view = PointInsideViewMock()
		touch.view.isUserInteractionEnabled = true
		
		let result = SparkDetector.trackEnded(touches: fakeTouches)
		XCTAssertFalse(result, "A Spark Event was tracked when it should have been ignored.")
	}
	
	func testSparkDetectorUIKitTrackTargetActionForView() {
		let view = UIView()
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.targetAction, trace: "foo", action: nil)
		view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackTargetAction(for: view)
		XCTAssertTrue(result, "A Spark Event failed to make a trip through the chamber.")
	}
	
	func testSparkDetectorUIKitTrackTargetActionForViewNil() {
		let result = SparkDetector.trackTargetAction(for: nil)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackTargetActionForViewWithEmptyEvents() {
		let view = UIView()
		view.sparkEvents = []
		
		let result = SparkDetector.trackTargetAction(for: view)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackTargetActionForViewWithNilEvents() {
		let view = UIView()
		view.sparkEvents = nil
		
		let result = SparkDetector.trackTargetAction(for: view)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackDisplayForViews() {
		let view = UIView()
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didAppear, trace: "foo", action: nil)
		view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackDisplay(views: [view])
		XCTAssertTrue(result, "A Spark Event failed to make a trip through the chamber.")
	}
	
	func testSparkDetectorUIKitTrackDisplayForViewsEmpty() {
		let result = SparkDetector.trackDisplay(views: [])
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackDisplayForViewsNil() {
		let result = SparkDetector.trackDisplay(views: nil)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackDisplayForNonViews() {
		let result = SparkDetector.trackDisplay(views: ["foo"])
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackDisplayForView() {
		let view = UIView()
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didAppear, trace: "foo", action: nil)
		view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackDisplay(views: [view])
		XCTAssertTrue(result, "A Spark Event failed to make a trip through the chamber.")
	}
	
	func testSparkDetectorUIKitTrackDisplayForViewWithEmptyEvents() {
		let view = UIView()
		view.sparkEvents = []
		
		let result = SparkDetector.trackDisplay(views: [view])
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackDisplayForViewWithNilEvents() {
		let view = UIView()
		view.sparkEvents = nil
		
		let result = SparkDetector.trackDisplay(views: [view])
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackDisplayForViewIgnored() {
		let view = UIView()
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch, trace: "foo") {
			_ in
			XCTFail("A Spark Event's action block was triggered when it shouldn't have been.")
		}
		view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackDisplay(views: [view])
		XCTAssertFalse(result, "A Spark Event was tracked when it should have been ignored.")
	}
	
	func testSparkDetectorUIKitTrackEndDisplayingViews() {
		let view = UIView()
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didDisappear, trace: "foo", action: nil)
		view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackEndDisplaying(views: [view])
		XCTAssertTrue(result, "A Spark Event failed to make a trip through the chamber.")
	}
	
	func testSparkDetectorUIKitTrackEndDisplayingViewsEmpty() {
		let result = SparkDetector.trackEndDisplaying(views: [])
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackEndDisplayingViewsNil() {
		let result = SparkDetector.trackEndDisplaying(views: nil)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackEndDisplayingNonViews() {
		let result = SparkDetector.trackEndDisplaying(views: ["foo"])
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackEndDisplayingView() {
		let view = UIView()
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didDisappear, trace: "foo", action: nil)
		view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackEndDisplaying(views: [view])
		XCTAssertTrue(result, "A Spark Event failed to make a trip through the chamber.")
	}
	
	func testSparkDetectorUIKitTrackEndDisplayingViewWithEmptyEvents() {
		let view = UIView()
		view.sparkEvents = []
		
		let result = SparkDetector.trackDisplay(views: [view])
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackEndDisplayingViewIgnored() {
		let view = UIView()
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch, trace: "foo") {
			_ in
			XCTFail("A Spark Event's action block was triggered when it shouldn't have been.")
		}
		view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackEndDisplaying(views: [view])
		XCTAssertFalse(result, "A Spark Event was tracked when it should have been ignored.")
	}
	
	func testSparkDetectorUIKitTrackBeganScrollingView() {
		let view = UIScrollViewTrackingMock()
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didBeginScroll, trace: "foo", action: nil)
		view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackBeganScrolling(scrollView: view)
		XCTAssertTrue(result, "A Spark Event failed to make a trip through the chamber.")
	}
	
	func testSparkDetectorUIKitTrackBeganScrollingViewNil() {
		let result = SparkDetector.trackBeganScrolling(scrollView: nil)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackBeganScrollingViewWithEmptyEvents() {
		let view = UIScrollViewTrackingMock()
		view.sparkEvents = []
		
		let result = SparkDetector.trackBeganScrolling(scrollView: view)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackBeganScrollingViewWithNilEvents() {
		let view = UIScrollViewTrackingMock()
		view.sparkEvents = nil
		
		let result = SparkDetector.trackBeganScrolling(scrollView: view)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackBeganScrollingViewIgnored() {
		let view = UIScrollView()
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didBeginScroll, trace: "foo") {
			_ in
			XCTFail("A Spark Event's action block was triggered when it shouldn't have been.")
		}
		view.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackBeganScrolling(scrollView: view)
		XCTAssertFalse(result, "A Spark Event was tracked when it should have been ignored.")
	}
	
	func testSparkDetectorUIKitTrackDidSelectControl() {
		let control = UIControl()
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didSelect, trace: "foo", action: nil)
		control.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackDidSelect(control: control)
		XCTAssertTrue(result, "A Spark Event failed to make a trip through the chamber.")
	}
	
	func testSparkDetectorUIKitTrackDidSelectControlNil() {
		let result = SparkDetector.trackDidSelect(control: nil)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackTrackDidSelectControlWithEmptyEvents() {
		let control = UIControl()
		control.sparkEvents = []
		
		let result = SparkDetector.trackDidSelect(control: control)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackDidSelectControlWithNilEvents() {
		let control = UIControl()
		control.sparkEvents = nil
		
		let result = SparkDetector.trackDidSelect(control: control)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackDidDeselectControl() {
		let control = UIControl()
		
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.didDeselect, trace: "foo", action: nil)
		control.sparkEvents = [sparkEvent]
		
		let result = SparkDetector.trackDidDeselect(control: control)
		XCTAssertTrue(result, "A Spark Event failed to make a trip through the chamber.")
	}
	
	func testSparkDetectorUIKitTrackDidDeselectControlNil() {
		let result = SparkDetector.trackDidDeselect(control: nil)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackTrackDidDeselectControlWithEmptyEvents() {
		let control = UIControl()
		control.sparkEvents = []
		
		let result = SparkDetector.trackDidDeselect(control: control)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
	
	func testSparkDetectorUIKitTrackDidDeselectControlWithNilEvents() {
		let control = UIControl()
		control.sparkEvents = nil
		
		let result = SparkDetector.trackDidDeselect(control: control)
		XCTAssertFalse(result, "A Spark Event was detected when none were present.")
	}
}
