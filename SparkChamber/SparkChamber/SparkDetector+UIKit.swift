/**
 *  SparkDetector+UIKit.swift
 *  SparkChamber
 *
 *  Created by Steve Elliott on 01/27/2016.
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

import UIKit


// MARK: Extensions

/**
These Spark Detector iOS client (UIKit) extensions provide functionality based on UIKit objects.

Functions allow the tracking of a view's appearance, disappearance, touches (ended), scrolling (began), target action, selection, and deselection.
*/
#if os(iOS)
extension SparkDetector {
	// MARK: - Public
	
	/**
	Takes a collection of UIView-based objects and triggers any attached DidAppear events.
	
	- parameter views: An Array of UIViews to process
	- returns: A boolean flag indicating if any supplied views successfully triggered an DidAppear event
	*/
	@discardableResult public class func trackDisplay(forViews views: NSArray?) -> Bool {
		return track(views: views, trigger: SparkTriggerType.didAppear)
	}
	
	/**
	Takes a collection of UIView-based objects and triggers any attached DidDisappear events.
	
	- parameter views: An Array of UIViews to process
	- returns: A boolean flag indicating if any supplied views successfully triggered a DidDisappear event
	*/
	@discardableResult public class func trackEndDisplaying(forViews views: NSArray?) -> Bool {
		return track(views: views, trigger: SparkTriggerType.didDisappear)
	}
	
	/**
	Takes a UIScrollView-based object and triggers any attached DidBeginScroll events.
	
	- parameter views: A UIScrollView to process
	- returns: A boolean flag indicating if the supplied view successfully triggered a DidBeginScroll event
	*/
	@discardableResult public class func trackBeganScrolling(forScrollView scrollView: UIScrollView?) -> Bool {
		return track(scrollView: scrollView, trigger: SparkTriggerType.didBeginScroll)
	}
	
	/**
	Takes a collection of touches, finds their associated views, and triggers any attached DidEndTouch events.
	
	- parameter touches: An NSSet of UITouch objects to process
	- returns: A boolean flag indicating if any supplied touches successfully triggered a DidEndTouch event
	*/
	@discardableResult public class func trackEnded(withTouches touches: NSSet?) -> Bool {
		return track(touches: touches, phase: UITouchPhase.ended)
	}
	
	/**
	Takes a UIView-based object and triggers any attached TargetAction events.
	
	- parameter view: A UIView to process
	- returns: A boolean flag indicating if the supplied view successfully triggered a TargetAction event
	*/
	@discardableResult public class func trackTargetAction(forView view: UIView?) -> Bool {
		return track(view: view, trigger: SparkTriggerType.targetAction)
	}
	
	/**
	Takes a UIControl-based object and triggers any attached DidSelect events.
	
	- parameter view: A UIControl to process
	- returns: A boolean flag indicating if the supplied control successfully triggered a DidSelect event
	*/
	@discardableResult public class func trackDidSelect(forControl control: UIControl?) -> Bool {
		return track(view: control, trigger: SparkTriggerType.didSelect)
	}
	
	/**
	Takes a UIControl-based object and triggers any attached DidDeselect events.
	
	- parameter view: A UIControl to process
	- returns: A boolean flag indicating if the supplied control successfully triggered a DidDeselect event
	*/
	@discardableResult public class func trackDidDeselect(forControl control: UIControl?) -> Bool {
		return track(view: control, trigger: SparkTriggerType.didDeselect)
	}
	
	// MARK: - Private
	
	fileprivate class func track(views: NSArray?, trigger: SparkTriggerType) -> Bool {
		guard let views = views as? Array<UIView> else {
			return false
		}
		
		var result = false
		
		for view in views {
			let success = track(view: view, trigger: trigger)
			if success {
				result = success
			}
		}
		
		return result
	}
	
	fileprivate class func track(touches: NSSet?, phase: UITouchPhase) -> Bool {
		guard let touch = touches?.anyObject() as? UITouch , touch.phase == phase,
			  let view = touch.view , view.isUserInteractionEnabled else {
				return false
		}
		
		if let control = view as? UIControl {
			guard control.isTouchInside else {
				return false
			}
		} else {
			guard view.point(inside: touch.location(in: view), with: nil) else {
				return false
			}
		}
		
		return track(view: view, trigger: SparkTriggerType.didEndTouch)
	}
	
	fileprivate class func track(scrollView: UIScrollView?, trigger: SparkTriggerType) -> Bool {
		guard let scrollView = scrollView as UIScrollView?, scrollView.isTracking else {
			return false
		}
		
		return track(view: scrollView, trigger: trigger)
	}
	
	fileprivate class func track(view: UIView?, trigger: SparkTriggerType = SparkTriggerType.none) -> Bool {
		guard let events = view?.sparkEvents(for: trigger) else {
			return false
		}
		
		return send(events)
	}
}

// MARK: - Private UIView extensions

private extension UIView {
	/**
	Returns an Array of SparkEvents attached to the view matching the supplied trigger.
	
	- parameter trigger: A SparkTriggerType that will be used to filter the view's SparkEvents Array
	- returns: An Array of Spark Events for the view matched to the supplied trigger
	*/
	func sparkEvents(for trigger: SparkTriggerType) -> [SparkEvent]? {
		func matchingTrigger(_ event: SparkEvent) -> Bool {
			return trigger == event.trigger
		}
		
		func findSuperviewCell() -> UIView? {
			var view: UIView? = self
			
			while view != nil {
				if view is UITableViewCell || view is UICollectionViewCell {
					return view
				} else {
					view = view?.superview
				}
			}
			return nil
		}
		
		func events() -> [SparkEvent]? {
			if let viewEvents = sparkEvents {
				return viewEvents.filter(matchingTrigger)
			} else if trigger == SparkTriggerType.didEndTouch {
				// UITableViewCells often generate events from views embedded within the cell.
				return findSuperviewCell()?.sparkEvents?.filter(matchingTrigger)
			}
			return nil
		}
		
		guard let result = events(), !result.isEmpty else {
			return nil
		}
		
		return result
	}
}

#endif
