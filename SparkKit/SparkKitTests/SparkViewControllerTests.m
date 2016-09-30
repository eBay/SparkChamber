/**
 *  SparkViewControllerTests.m
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

#import <XCTest/XCTest.h>

#import "SparkKitTests-Swift.h"
@import SparkChamber;


@interface SparkViewControllerTests : XCTestCase

@end


@implementation SparkViewControllerTests

- (void)testSparkViewControllerViewDidAppear
{
	SparkViewController *viewController = [SparkViewController new];
	UIView *view = [[UIView alloc] init];
	[viewController.view addSubview:view];
	
	XCTestExpectation *expectation = [self expectationWithDescription:@"A SparkViewController's appear action failed to execute."];
	__block SparkEvent *event = [[SparkEvent alloc] initWithTrigger:SparkTriggerTypeDidAppear
															  trace:@"view displayed"
															 action:^(NSDate * _Nonnull timestamp)
								 {
									 [expectation fulfill];
								 }];
	view.sparkEvents = @[event];
	
	[viewController viewDidAppear:NO];

	[self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testSparkViewControllerViewDidDisppear
{
	SparkViewController *viewController = [SparkViewController new];
	UIView *view = [[UIView alloc] init];
	[viewController.view addSubview:view];
	
	XCTestExpectation *expectation = [self expectationWithDescription:@"A SparkViewController's disappear action failed to execute."];
	__block SparkEvent *event = [[SparkEvent alloc] initWithTrigger:SparkTriggerTypeDidDisappear
															  trace:@"view disappeared"
															 action:^(NSDate * _Nonnull timestamp)
								 {
									 [expectation fulfill];
								 }];
	view.sparkEvents = @[event];
	
	[viewController viewDidDisappear:NO];
	
	[self waitForExpectationsWithTimeout:3.0 handler:nil];
}


@end
