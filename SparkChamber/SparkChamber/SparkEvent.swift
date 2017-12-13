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


// MARK: SparkTrigger

/**
An event's trigger type.

- none: The event has no trigger
- didAppear: The event's action will trigger if attached to a view that has appeared
- didDisappear: The event's action will trigger if attached to a view that has disappeared
- didEndTouch: The event's action will trigger if attached to a responder that has received a touch event with phase 'Ended'
- didBeginScroll: The event's action will trigger if attached to a scroll view after scrolling has begun
- didBecomeFirstResponder: The event's action will trigger if attached to a view that has become a first responder
- didResignFirstResponder: The event's action will trigger if attached to a view that has resigned its status as a first responder
- targetAction: The event's action will trigger if attached to a responder that has an event action tied to the Detector
*/

/* NB: To add custom/additional triggers, please create a new file in your project and use the following pattern:

	public extension SparkTriggerType {
		public static let myCustomTrigger = SparkTrigger("myCustomTriggerDescription")
	}

Once a trigger is fully supported by the SparkChamber and SparkKit frameworks and offers an example in SparkPlayground, it can be considered for promotion to the root list.
*/

@objcMembers final public class SparkTriggerType: SparkTrigger {
	public static let none = SparkTrigger("none")
	public static let didAppear = SparkTrigger("didAppear")
	public static let didDisappear = SparkTrigger("didDisappear")
	public static let didEndTouch = SparkTrigger("didEndTouch")
	public static let didBeginScroll = SparkTrigger("didBeginScroll")
	public static let didBecomeFirstResponder = SparkTrigger("didBecomeFirstResponder")
	public static let didResignFirstResponder = SparkTrigger("didResignFirstResponder")
	public static let targetAction = SparkTrigger("targetAction")
}

/**
An event's trigger.
*/
@objc public class SparkTrigger: NSObject {
	private var _description = ""
	
	override public var description: String {
		get {
			return _description
		}
		
		set {
			_description = newValue
		}
	}
	
	internal convenience init(_ description: String) {
		self.init()

		self.description = description
	}
	
	override private init() {} // Do not allow initialization via init()
}

/**
An event's action closure/block type definition.

- returns: A NSDate-based timestamp when the action was executed
*/
public typealias SparkEventActionBlock = @convention(block) (_ timestamp: Date) -> Void


// MARK: - Classes

/**
A Spark Event model object, composed of a trigger (enum), action (closure), trace (string), and identifier (string).
*/
@objcMembers open class SparkEvent: NSObject, NSCopying {
	// MARK: - Public
	
	/**
	The event's trigger, represented as a SparkTrigger.
	*/
	final public var trigger: SparkTrigger = SparkTriggerType.none
	
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
	Returns a unique identifier string if none has been assigned.
	*/
	final public var identifier: UUID? = UUID()
	
	// Designated initializer
	
	/**
	Initializes a new SparkEvent object with supplied parameters.
	
	- parameter trigger: The event's trigger, supplied as a SparkTrigger
	- parameter trace: An optional String that will print to the console after the event's action has executed
	- parameter action: An optional completion closure/block that will execute when the event's trigger conditions have been met
	
	- returns: An initialized object, or nil if an object could not be created
	*/
	public init(trigger: SparkTrigger, trace: String?, action: SparkEventActionBlock?) {
		self.trigger = trigger
		self.trace = trace
		self.action = action
		
		super.init()
	}
	
	/**
	Initializer that creates a new SparkEvent object with supplied parameters.
	
	- parameter trigger: The event's trigger, supplied as a SparkTrigger
	- parameter trace: An optional String that will print to the console after the event's action has executed
	- parameter identifier: An optional UUID that may be assigned to allow the event to be uniquely identified
	- parameter action: An optional completion closure/block that will execute when the event's trigger conditions have been met
	
	- returns: An initialized object, or nil if an object could not be created
	*/
	public convenience init(trigger: SparkTrigger, trace: String?, identifier: UUID?, action: SparkEventActionBlock?) {
		self.init(trigger: trigger, trace: trace, action: action)
		
		self.identifier = identifier;
	}
	
	/**
	Initializer that creates a new SparkEvent object with supplied parameters.
	
	- parameter trigger: The event's trigger, supplied as a SparkTrigger
	- parameter action: An optional completion closure/block that will execute when the event's trigger conditions have been met
	
	- returns: An initialized object, or nil if an object could not be created
	*/
	public convenience init(trigger: SparkTrigger, action: SparkEventActionBlock?) {
		self.init(trigger: trigger, trace: nil, action: action)
	}
	
	// CustomStringConvertible protocol
	
	override open var description: String {
		return("\(super.description)\n   trigger = \(trigger.description)\n   trace = \(trace ?? "nil")\n   identifier = \(identifier?.uuidString ?? "nil")\n   action = \(String(describing: action))")
	}
	
	// NSCopying protocol
	
	open func copy(with zone: NSZone?) -> Any {
		let event = SparkEvent(trigger: trigger, trace: trace, identifier: identifier, action: action)

		return event
	}
	
	// Equivalence
	
	override open func isEqual(_ object: Any?) -> Bool {
		if let rhs = object as? SparkEvent {
			guard trigger == rhs.trigger else {
				return false
			}
			
			guard identifier == rhs.identifier else {
				return false
			}
			
			guard trace == rhs.trace else {
				return false
			}
			
			guard let lhsAction = action else {
				return rhs.action == nil
			}
			
			guard let rhsAction = rhs.action else {
				return false
			}
			
			return unsafeBitCast(lhsAction as SparkEventActionBlock, to: AnyObject.self) === unsafeBitCast(rhsAction as SparkEventActionBlock, to: AnyObject.self)
		}
		
		return false
	}
	
	// MARK: - Internal
	
	/**
	Executes the event's action and trace, if present. A current timestamp will be sent to the event's action closure/block.
	
	- returns: A boolean flag indicating successful execution of the function
	*/
	@discardableResult final func send() -> Bool {
		action?(Date())
		
		if trace != nil {
			SparkTrace.print("Traced event:", self.description)
		}
		
		return true
	}
}
