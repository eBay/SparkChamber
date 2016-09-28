/**
 *  SparkEvent.swift
 *  SparkChamber
 *
 *  Created by Steve Elliott on 02/04/2016.
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


// MARK: SparkTriggerType enum

/**
An event's trigger type.

- None: The event has no trigger
- DidAppear: The event's action will trigger if attached to a view that has appeared
- DidDisappear: The event's action will trigger if attached to a view that has disappeared
- DidEndTouch: The event's action will trigger if attached to a responder that has received a touch event with phase 'Ended'
- DidBeginScroll: The event's action will trigger if attached to a scroll view after scrolling has begun
- TargetAction: The event's action will trigger if attached to a responder that has an event action tied to the Detector

*/
@objc public enum SparkTriggerType: Int {
	case None
	case DidAppear
	case DidDisappear
	case DidEndTouch
	case TargetAction
	case DidBeginScroll
	case DidSelect
	case DidDeselect
	
	public var description: String {
		switch self {
		case .None: return "None"
		case .DidAppear: return "DidAppear"
		case .DidDisappear: return "DidDisappear"
		case .DidEndTouch: return "DidEndTouch"
		case .DidBeginScroll: return "DidBeginScroll"
		case .TargetAction: return "TargetAction"
		case .DidSelect: return "DidSelect"
		case .DidDeselect: return "DidDeselect"
		}
	}
}

/**
An event's action closure/block type definition.

- returns: A NSDate-based timestamp when the action was executed
*/
public typealias SparkEventActionBlock = @convention(block) (timestamp: NSDate) -> Void


// MARK: - Classes

/**
A Spark Event model object, composed of a trigger (enum), action (closure), trace (string), and identifier (string).
*/
@objc public class SparkEvent: NSObject, NSCopying {
	// MARK: - Public
	
	/**
	The event's trigger, represented as a SparkTriggerType.
	*/
	final public var trigger: SparkTriggerType = SparkTriggerType.None
	
	/**
	A completion closure/block that will execute when the event's trigger condition has been met.
	*/
	final public var action: SparkEventActionBlock?
	
	/**
	The event's trace, printed to console after the event's action has executed.
	*/
	final public var trace: String?
	
	/**
	The event's identifier, assignable for identification purposes.
	*/
	final public var identifier: String?
	
	// Designated initializer
	
	/**
	Initializes a new SparkEvent object with supplied parameters.
	
	- parameter trigger: The event's trigger, supplied as a SparkTriggerType
	- parameter trace: An optional String that will print to the console after the event's action has executed
	- parameter identifier: An optional String that may be assigned to allow the event to be uniquely identified
	- parameter action: An optional completion closure/block that will execute when the event's trigger conditions have been met
	
	- returns: An initialized object, or nil if an object could not be created
	*/
	public init(trigger: SparkTriggerType, trace: String?, identifier: String?, action: SparkEventActionBlock?) {
		self.trigger = trigger
		self.trace = trace
		self.identifier = identifier
		self.action = action
		
		super.init()
	}
	
	/**
	Initializer that creates a new SparkEvent object with supplied parameters.
	
	- parameter trigger: The event's trigger, supplied as a SparkTriggerType
	- parameter trace: An optional String that will print to the console after the event's action has executed
	- parameter action: An optional completion closure/block that will execute when the event's trigger conditions have been met
	
	- returns: An initialized object, or nil if an object could not be created
	*/
	public convenience init(trigger: SparkTriggerType, trace: String?, action: SparkEventActionBlock?) {
		self.init(trigger: trigger, trace: trace, identifier: nil, action: action)
	}
	
	/**
	Initializer that creates a new SparkEvent object with supplied parameters.
	
	- parameter trigger: The event's trigger, supplied as a SparkTriggerType
	- parameter action: An optional completion closure/block that will execute when the event's trigger conditions have been met
	
	- returns: An initialized object, or nil if an object could not be created
	*/
	public convenience init(trigger: SparkTriggerType, action: SparkEventActionBlock?) {
		self.init(trigger: trigger, trace: nil, identifier: nil, action: action)
	}
	
	// CustomStringConvertible protocol
	
	override public var description: String {
		return("\(super.description)\n   trigger = \(trigger.description)\n   trace = \(trace ?? "nil")\n   identifier = \(identifier ?? "nil")\n   action = \(action)")
	}
	
	// NSCopying protocol
	
	public func copyWithZone(zone: NSZone) -> AnyObject {
		let event = SparkEvent(trigger: trigger, trace: trace, identifier: identifier, action: action)

		return event
	}
	
	// Equivalence
	
	override public func isEqual(object: AnyObject?) -> Bool {
		if let rhs = object as? SparkEvent {
			guard trigger == rhs.trigger else {
				return false
			}
			
			guard trace == rhs.trace else {
				return false
			}
			
			guard identifier == rhs.identifier else {
				return false
			}
			
			guard let lhsAction = action else {
				return rhs.action == nil
			}
			
			guard let rhsAction = rhs.action else {
				return false
			}
			
			return unsafeBitCast(lhsAction as SparkEventActionBlock, AnyObject.self) === unsafeBitCast(rhsAction as SparkEventActionBlock, AnyObject.self)
		}
		
		return false
	}
	
	// MARK: - Internal
	
	/**
	Executes the event's action and trace, if present. A current timestamp will be sent to the event's action closure/block.
	
	- returns: A boolean flag indicating successful execution of the function
	*/
	final func send() -> Bool {
		action?(timestamp: NSDate())
		
		if trace != nil {
			SparkTrace.print("Traced event:", self.description)
		}
		
		return true
	}
}
