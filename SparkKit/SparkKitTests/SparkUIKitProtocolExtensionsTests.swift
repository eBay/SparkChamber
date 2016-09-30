/**
 *  SparkUIKitProtocolExtensionsTests.swift
 *  SparkKitTests
 *
 *  Created by Steve Elliott on 05/04/2016.
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
import SparkChamber
@testable import SparkKit


class SparkUIKitProtocolExtensionsTests: XCTestCase {
	override func setUp() {
		super.setUp()
		
	}
	
	override func tearDown() {
		super.tearDown()
	}

	func testSparkKitUIApplicationTouchesEnded() {
		guard UIApplicationExtensionSupport.enabled else {
			return
		}
		
		let view = PointInsideViewMock()
		
		let expectation: XCTestExpectation = expectationWithDescription("A Spark Event's action failed to execute.")
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.DidEndTouch, trace: "UIApplication touch event") {
			_ in
			expectation.fulfill()
		}
		view.sparkEvents = [sparkEvent]
		
		let touch = UITouchMock()
		touch.view = view
		let fakeTouches: Set<UITouch> = [touch]
		
		UIApplication.sharedApplication().keyWindow?.addSubview(view)
		
		UIApplication.sharedApplication().touchesEnded(fakeTouches, withEvent:nil)
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
	
	func testSparkKitTableViewWillDisplayCell() {
		let viewController = SparkViewController()
		UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
		
		let tableView = UITableView()
		tableView.delegate = viewController
		viewController.view = tableView
		let cell = UITableViewCell()
		
		let expectation: XCTestExpectation = expectationWithDescription("A Spark Event's action failed to execute.")
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.DidAppear, trace: nil) {
			_ in
			expectation.fulfill()
		}
		cell.sparkEvents = [sparkEvent]
		
		viewController.tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
	
	func testSparkKitTableViewDidEndDisplayingCell() {
		let viewController = SparkViewController()
		UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
		
		let tableView = UITableView()
		tableView.delegate = viewController
		viewController.view = tableView
		let cell = UITableViewCell()
		
		let expectation: XCTestExpectation = expectationWithDescription("A Spark Event's action failed to execute.")
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.DidDisappear, trace: nil) {
			_ in
			expectation.fulfill()
		}
		cell.sparkEvents = [sparkEvent]
		
		viewController.tableView(tableView, didEndDisplayingCell: cell, forRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
	
	func testSparkKitTableViewWillDisplayHeaderView() {
		let viewController = SparkViewController()
		UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
		
		let tableView = UITableView()
		tableView.delegate = viewController
		viewController.view = tableView
		let headerView = UIView()
		
		let expectation: XCTestExpectation = expectationWithDescription("A Spark Event's action failed to execute.")
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.DidAppear, trace: nil) {
			_ in
			expectation.fulfill()
		}
		headerView.sparkEvents = [sparkEvent]
		
		viewController.tableView(tableView, willDisplayHeaderView: headerView, forSection: 0)
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
	
	func testSparkKitTableViewDidEndDisplayingHeaderView() {
		let viewController = SparkViewController()
		UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
		
		let tableView = UITableView()
		tableView.delegate = viewController
		viewController.view = tableView
		let headerView = UIView()
		
		let expectation: XCTestExpectation = expectationWithDescription("A Spark Event's action failed to execute.")
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.DidDisappear, trace: nil) {
			_ in
			expectation.fulfill()
		}
		headerView.sparkEvents = [sparkEvent]
		
		viewController.tableView(tableView, didEndDisplayingHeaderView: headerView, forSection: 0)
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
	
	func testSparkKitTableViewWillDisplayFooterView() {
		let viewController = SparkViewController()
		UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
		
		let tableView = UITableView()
		tableView.delegate = viewController
		viewController.view = tableView
		let footerView = UIView()
		
		let expectation: XCTestExpectation = expectationWithDescription("A Spark Event's action failed to execute.")
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.DidAppear, trace: nil) {
			_ in
			expectation.fulfill()
		}
		footerView.sparkEvents = [sparkEvent]
		
		viewController.tableView(tableView, willDisplayFooterView: footerView, forSection: 0)
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
	
	func testSparkKitTableViewDidEndDisplayingFooterView() {
		let viewController = SparkViewController()
		UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
		
		let tableView = UITableView()
		tableView.delegate = viewController
		viewController.view = tableView
		let footerView = UIView()
		
		let expectation: XCTestExpectation = expectationWithDescription("A Spark Event's action failed to execute.")
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.DidDisappear, trace: nil) {
			_ in
			expectation.fulfill()
		}
		footerView.sparkEvents = [sparkEvent]
		
		viewController.tableView(tableView, didEndDisplayingFooterView: footerView, forSection: 0)
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
	
	func testSparkKitCollectionViewWillDisplayCell() {
		let viewController = SparkViewController()
		UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
		
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSizeMake(100, 100)
		let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
		collectionView.delegate = viewController
		viewController.view = collectionView
		let cell = UICollectionViewCell()
		
		let expectation: XCTestExpectation = expectationWithDescription("A Spark Event's action failed to execute.")
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.DidAppear, trace: nil) {
			_ in
			expectation.fulfill()
		}
		cell.sparkEvents = [sparkEvent]
		
		viewController.collectionView(collectionView, willDisplayCell: cell, forItemAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
	
	func testSparkKitCollectionViewDidEndDisplayingCell() {
		let viewController = SparkViewController()
		UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
		
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSizeMake(100, 100)
		let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
		collectionView.delegate = viewController
		viewController.view = collectionView
		let cell = UICollectionViewCell()
		
		let expectation: XCTestExpectation = expectationWithDescription("A Spark Event's action failed to execute.")
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.DidDisappear, trace: nil) {
			_ in
			expectation.fulfill()
		}
		cell.sparkEvents = [sparkEvent]
		
		viewController.collectionView(collectionView, didEndDisplayingCell: cell, forItemAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
	
	func testSparkKitCollectionViewWillDisplaySupplementaryView() {
		let viewController = SparkViewController()
		UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
		
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSizeMake(100, 100)
		let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
		collectionView.delegate = viewController
		viewController.view = collectionView
		let supplementaryView = UICollectionReusableView()
		
		let expectation: XCTestExpectation = expectationWithDescription("A Spark Event's action failed to execute.")
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.DidAppear, trace: nil) {
			_ in
			expectation.fulfill()
		}
		supplementaryView.sparkEvents = [sparkEvent]
		
		
		viewController.collectionView(collectionView, willDisplaySupplementaryView: supplementaryView, forElementKind: "foo", atIndexPath: NSIndexPath(forRow: 1, inSection: 0))
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
	
	func testSparkKitCollectionViewDidEndDisplayingSupplementaryView() {
		let viewController = SparkViewController()
		UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
		
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSizeMake(100, 100)
		let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
		collectionView.delegate = viewController
		viewController.view = collectionView
		let supplementaryView = UICollectionReusableView()
		
		let expectation: XCTestExpectation = expectationWithDescription("A Spark Event's action failed to execute.")
		let sparkEvent = SparkEvent(trigger: SparkTriggerType.DidDisappear, trace: nil) {
			_ in
			expectation.fulfill()
		}
		supplementaryView.sparkEvents = [sparkEvent]
		
		viewController.collectionView(collectionView, didEndDisplayingSupplementaryView: supplementaryView, forElementKind: "foo", atIndexPath: NSIndexPath(forRow: 1, inSection: 0))
		
		waitForExpectationsWithTimeout(3.0, handler: nil)
	}
}
