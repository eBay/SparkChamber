## Spark Chamber - an event tracking framework for iOS

[![Build Status](https://travis-ci.org/eBay/SparkChamber.svg?branch=master)](https://travis-ci.org/eBay/SparkChamber) [![codecov](https://codecov.io/gh/eBay/SparkChamber/branch/master/graph/badge.svg)](https://codecov.io/gh/eBay/SparkChamber)

Spark Chamber is a lightweight asynchronous trigger-action framework for iOS, designed to be used for automating analytics, tracking, and/or logging.

* [Introduction](#introduction "What is Spark Chamber, and what is it useful for?")
* [Installation](#installation "How to install and setup the SparkChamber framework in your project")
* [Adding Events](#adding-events)
	* [Spark Events](#spark-events)
	* [Event triggers](#event-triggers)
* [Event Examples](#event-examples)
	* [Attaching a single event](#attaching-a-single-event)
	* [Attaching multiple events](#attaching-multiple-events)
	* [Single-fire events](#single-fire-events)
	* [Tracking on-screen viewing time](#tracking-on-screen-viewing-time)
* [Detecting Events](#detecting-events)
	* [Spark Detector](#spark-events) 
	* [Appearance events](#appearance-events "What are appearance events, and how are they triggered?")
	* [Disappearance events](#disappearance-events "What are disappearance events, and how are they triggered?")
	* [Touch events](#touch-events "What are touch events, and how are they triggered?")
	* [Scrolling events](#scrolling-events "What are scrolling events, and how are they triggered?")
	* [Target Action events](#target-action-events "What are target action events, and how are they triggered?")
	* [Selection events](#selection-events "What are selection events, and how are they triggered?")
* [SparkKit](#sparkkit)
	* [SparkKit Introduction](#sparkkit-introduction "What is SparkKit, and why/when will you need it?")
	* [SparkKit Installation and Use](#sparkkit-installation-and-use "How to install and setup the SparkKit framework in your project")
	* [Classes available](#classes-available "What SparkKit classes are available, and what triggers do they support?")
	* [Enabling UIApplication-level touch tracking support](#enabling-uiapplication-level-touch-tracking-support "How to enable UIApplication-level touch tracking support")

### Introduction
Spark Chamber is built as a trigger-action event tracking system. Its purpose is to allow the attachment of event objects to various UI elements and then execute the event's `action` (code) asynchronously when the event's trigger condition is met. The optional value `trace` (String) allows debugging, and the optional value `identifier` (String) allows identification and correlation.

### Installation
1. In Xcode, add the SparkChamber.xcodeproj file by selecting your project and choosing 'Add Files to...' from the File menu
2. Next, select your project in Xcode from the project navigator on the left side of the project window
2. Select the target to which you want to add frameworks in the project settings editor
3. Select the “Build Phases” tab, and click the small triangle next to “Link Binary With Libraries” to view all of the frameworks in your application
4. To add the SparkChamber framework, click the “+” below the list of frameworks

### Adding Events
#### Spark Events
At the heart of the system is a Spark Event, composed of a `trigger` and an `action`. Events can be set to trigger under the following conditions: `didAppear`, `didDisappear`, `didEndTouch`, `didBeginScroll`, `targetAction`, `didSelect`, and `didDeselect`.

Spark Events can optionally include a `trace` (String) for debugging purposes, and a `identifier` (String) to allow for identification and correlation.

Events are attached to any subclass of NSObject using the `sparkEvents` property, which stores an Array/NSArray composed of Spark Event objects. Multiple independent events may be attached to any given UI component to allow for the construction of complex tracking behaviors. 

Utilizing these tools, a diverse set of tracking scenarios can be solved: viewing, click-through, time on screen, etc.

Since the events are tied directly to a UI element's object lifecycle, there is no need for managing an event's lifecycle independently.
 
#### Event triggers
Events are triggered using the `trigger` property, a `SparkTriggerType` enum which supports the following values:  

| enum Value | Object Class | Description |
| ------------- | ------------- | ------------- |
| `none` | `NSObject` | The event has no trigger |
| `didAppear` | `UIView` | Triggered when the UI element receives a 'didAppear' or 'willDisplay' message, as appropriate |
| `didDisappear` | `UIView` | Triggered when the UI element receives a 'didDisappear' or 'didEndDisplaying' message, as appropriate |
| `didEndTouch` | `UIView` | Triggered when attached to a responder that has received a touch event with phase 'Ended' |
| `didBeginScroll` | `UIScrollView` | Triggered when attached to a scroll view after scrolling has begun |
| `targetAction` | `UIView` | Triggered when attached to a responder that has an event action tied to the Detector |
| `didSelect` | `UIControl` | Triggered when attached to a control that has been selected |
| `didDeselect` | `UIControl` | Triggered when attached to a control that has been deselected |

### Event Examples
#### Attaching a single event
```swift
// Swift
let event = SparkEvent(trigger: SparkTriggerType.didAppear) {
	_ in
	// Your code to send data to a tracking/analytics solution goes here.
}

view.sparkEvents = [event]
```
```obj-c
// Objective-C
SparkEvent* event = [[SparkEvent alloc] initWithTrigger: SparkTriggerTypeDidAppear
												 action: ^(NSDate* _Nonnull timestamp)
{
	// Your code to send data to a tracking/analytics solution goes here.
};

view.sparkEvents = @[event];
```

#### Attaching multiple events
```swift
// Swift
let appearEvent = SparkEvent(trigger: SparkTriggerType.didAppear) {
	_ in
	// Your code to send data to a tracking/analytics solution for the view event goes here.
}
		
let touchEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch) {
	_ in
	// Your code to send data to a tracking/analytics solution for the touch event goes here.
}

view.sparkEvents = [appearEvent, touchEvent]
```
```obj-c
// Objective-C
SparkEvent* appearEvent = [[SparkEvent alloc] initWithTrigger: SparkTriggerTypeDidAppear
													   action: ^(NSDate* _Nonnull timestamp)
{
	// Your code to send data to a tracking/analytics solution for the view event goes here.
};

SparkEvent* touchEvent = [[SparkEvent alloc] initWithTrigger: SparkTriggerTypeDidEndTouch
													  action: ^(NSDate* _Nonnull timestamp)
{
	// Your code to send data to a tracking/analytics solution for the touch event goes here.
};

view.sparkEvents = @[appearEvent, touchEvent];
```

#### Single-fire events
If your event's UI element has a long object lifecycle, then the following code will construct an event that only triggers once:
```swift
// Swift
let event = SparkEvent(trigger: SparkTriggerType.didAppear, action: nil)
event.action = {
	_ in
	event.trigger = SparkTriggerType.none
}

view.sparkEvents = [event]
```
```obj-c
// Objective-C
__block SparkEvent* event = [[SparkEvent alloc] initWithTrigger: SparkTriggerTypeDidAppear
														 action: ^(NSDate* _Nonnull timestamp)
{
	event.trigger = SparkTriggerTypeNone;
};

view.sparkEvents = @[event];
```

If your event's UI element has a short object lifecycle (collection & table view cells, for instance) then in the action block you'd instead want to invalidate the event's data, possibly by utilizing a lookup table or a long-lived model object. This could then be referenced to prevent the re-creation of the event when the appropriate UI element is being reconstructed.

#### Tracking on-screen viewing time
Creating a pair of events that track a UI element's time on screen is achieved by utilizing the `Appear` and `Disappear` triggers in tandem:
```swift
// Swift
var startTime: Date = Date()
		
let appearEvent = SparkEvent(trigger: SparkTriggerType.didAppear) {
	timestamp in
	startTime = timestamp
}
		
let disappearEvent = SparkEvent(trigger: SparkTriggerType.didDisappear) {
	timestamp in
	print("Time on screen:", timestamp.timeIntervalSince(startTime))
}

view.sparkEvents = [appearEvent, disappearEvent]
```
```obj-c
// Objective-C
__block NSDate* startTime;

SparkEvent* appearEvent = [[SparkEvent alloc] initWithTrigger: SparkTriggerTypeDidAppear
													   action: ^(NSDate* _Nonnull timestamp)
{
	startTime = timestamp;
};

SparkEvent* disappearEvent = [[SparkEvent alloc] initWithTrigger: SparkTriggerTypeDidDisappear
														  action: ^(NSDate* _Nonnull timestamp)
{
	NSLog(@"Time on screen: %f", [timestamp timeIntervalSinceDate:startTime]);
};

view.sparkEvents = @[appearEvent, disappearEvent];
```

### Detecting Events
#### Spark Detector
While Spark Events define the trigger-action-trace events for the system, the Spark Detector is the engine that acts as a discriminator and executor for appropriate event actions. The Spark detector is either invoked from your app's UIKit subclasses to process events, or through the [SparkKit](#sparkkit) framework.

**Note:** When using subclasses of UI components from SparkKit - the appearance, disappearance, touch, and target action methods will automatically be invoked by the superclass or protocol extension provided in SparkKit _(scrolling and selection event support available soon)_. You're not required to manually implement the code in the following sections unless your UI component requires unique support.

#### Appearance events
Appearance events are triggered by calling Spark Detector's class method: 
```swift
// Swift
class func trackDisplay(forViews views: NSArray?) -> Bool
```
```obj-c
// Objective-C
+ (BOOL)trackDisplayForViews: (NSArray<__kindof UIView *>*) views
```

This method accepts an optional NSArray of UIViews and returns a boolean value of true if any supplied view triggers a `didAppear` event.

#### Disappearance events
Disappearance events are triggered by calling Spark Detector's class method: 
```swift
// Swift
class func trackEndDisplaying(forViews views: NSArray?) -> Bool
```
```obj-c
// Objective-C
+ (BOOL)trackEndDisplayingForViews: (NSArray<__kindof UIView *>*) views
```

This method accepts an optional NSArray of UIViews and returns a boolean value of true if any supplied view triggers a `didDisappear` event.

#### Touch events
Disappearance events are triggered by calling Spark Detector's class method: 
```swift
// Swift
class func trackEnded(withTouches touches: NSSet?) -> Bool
```
```obj-c
// Objective-C
+ (BOOL)trackEndedWithTouches: (NSSet*) touches
```

This method accepts an optional NSSet and returns a boolean value of true if any of the touches in the set  triggers a `didEndTouch` event.

A `didEndTouch` event will be triggered if supplied`UITouch` objects with a phase of `UITouchPhase.Ended` are attached to a view with the `userInteractionEnabled` property set to true when the touch registers either as a `touchInside` a `UIControl`, or as a `pointInside` a `UIView`.

#### Scrolling events
Scrolling events are triggered by calling Spark Detector's class method: 
```swift
// Swift
class func trackBeganScrolling(forScrollView scrollView: UIScrollView?) -> Bool 
```
```obj-c
// Objective-C
+ (BOOL)trackBeganScrollingForScrollView: (UIScrollView*) view
```

This method accepts an optional UIScrollView and returns a boolean value of true if the supplied scroll view triggers a `didBeginScroll` event.

A `didBeginScroll` event will be triggered if the supplied UIScrollView's `tracking` property is true when this method is called.

#### Target Action events
Target Action events are triggered by calling Spark Detector's class method: 
```swift
// Swift
class func trackTargetAction(forView view: UIView?) -> Bool 
```
```obj-c
// Objective-C
+ (BOOL)trackTargetActionForView: (UIView*) view
```

This method accepts an optional UIView and returns a boolean value of true if the supplied view triggers a `targetAction` event through the Detector.

Target Action events are especially useful to tie in to a control's target-action mechanism.

#### Selection events
Selection events come in two flavors, select and deselect. They are triggered by calling Spark Detector's class methods: 
```swift
// Swift
class func trackDidSelect(forControl control: UIControl?) -> Bool 
class func trackDidDeselect(forControl control: UIControl?) -> Bool 
```
```obj-c
// Objective-C
+ (BOOL)trackDidSelectForControl: (UIControl*) control
+ (BOOL)trackDidDeselectForControl: (UIControl*) control
```

This method accepts an optional UIControl and returns a boolean value of true if the supplied control triggers an appropriate `didSelect` or `didDeselect` event.

Selection events are especially useful when the `selected` state of a UIControl needs to be measured.

### SparkKit
#### SparkKit Introduction
Spark Kit ties Spark Chamber's mechanisms to Apple's UIKit and allows UI to automatically notify the Detector portions of the Spark Chamber framework for seamless event processing.

#### SparkKit Installation and Use
1. In Xcode, add the SparkKit.xcodeproj and SparkChamber.xcodeproj files by selecting your project and choosing 'Add Files to...' from the File menu
2. Next, select your project in Xcode from the project navigator on the left side of the project window
3. Select the target to which you want to add frameworks in the project settings editor
4. Select the “Build Phases” tab, and click the small triangle next to “Link Binary With Libraries” to view all of the frameworks in your application
5. To add the SparkKit framework, click the “+” below the list of frameworks

#### Classes available
| Class Name | Root Class Name | Spark Event Support | Spark Detector Integration |
| ------------- | ------------- | ------------- | ------------- |
| `SparkButton` | `UIButton`  | `didEndTouch` | `trackEnded(withTouches:)` |
| `SparkCollectionViewCell` | `UICollectionViewCell`  | `didEndTouch`, `didAppear`, `didDisappear` | `trackEnded(withTouches:)`, `trackDisplay(forViews:)`, `trackEndDisplaying(forViews:)` |
| `SparkTableViewCell` | `UITableViewCell`  | `didEndTouch`, `didAppear`, `didDisappear` | `trackEnded(withTouches:)`, `trackDisplay(forViews:)`, `trackEndDisplaying(forViews:)` |
| `SparkViewController` | `UIViewController`  | `didAppear`, `didDisappear` | `trackDisplay(forViews:)`, `trackEndDisplaying(forViews:)` |

#### Enabling UIApplication-level touch tracking support
If desired, UIApplication-level touch support can be enabled in SparkKit for processing of most touches app-wide. Some responders don't forward touch events, so this support can be unpredictable at times.

To enable this feature: select the SparkKit project in Xcode, choose the SparkKit (framework) target, then in the Build Settings tab find the 'Swift Compiler - Custom Flags' section and add this value to the 'Other Swift Flags' key: `-DUIAPPLICATION_EXTENSION_ENABLED`