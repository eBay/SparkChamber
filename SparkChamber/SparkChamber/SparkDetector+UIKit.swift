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
	public class func trackDisplayViews(views: NSArray?) -> Bool {
		return trackViews(views, trigger: SparkTriggerType.DidAppear)
	}
	
	/**
	Takes a collection of UIView-based objects and triggers any attached DidDisappear events.
	
	- parameter views: An Array of UIViews to process
	- returns: A boolean flag indicating if any supplied views successfully triggered a DidDisappear event
	*/
	public class func trackEndDisplayingViews(views: NSArray?) -> Bool {
		return trackViews(views, trigger: SparkTriggerType.DidDisappear)
	}
	
	/**
	Takes a UIScrollView-based object and triggers any attached DidBeginScroll events.
	
	- parameter views: A UIScrollView to process
	- returns: A boolean flag indicating if the supplied view successfully triggered a DidBeginScroll event
	*/
	public class func trackBeganScrollingView(view: UIScrollView?) -> Bool {
		return trackScrolling(view, trigger: SparkTriggerType.DidBeginScroll)
	}
	
	/**
	Takes a collection of touches, finds their associated views, and triggers any attached DidEndTouch events.
	
	- parameter touches: An NSSet of UITouch objects to process
	- returns: A boolean flag indicating if any supplied touches successfully triggered a DidEndTouch event
	*/
	public class func trackEndedTouches(touches: NSSet?) -> Bool {
		return trackTouches(touches, phase: UITouchPhase.Ended)
	}
	
	/**
	Takes a UIView-based object and triggers any attached TargetAction events.
	
	- parameter view: A UIView to process
	- returns: A boolean flag indicating if the supplied view successfully triggered a TargetAction event
	*/
	public class func trackTargetAction(view: UIView?) -> Bool {
		return track(view, trigger: SparkTriggerType.TargetAction)
	}
	
	/**
	Takes a UIControl-based object and triggers any attached DidSelect events.
	
	- parameter view: A UIControl to process
	- returns: A boolean flag indicating if the supplied control successfully triggered a DidSelect event
	*/
	public class func trackDidSelectControl(control: UIControl?) -> Bool {
		return track(control, trigger: SparkTriggerType.DidSelect)
	}
	
	/**
	Takes a UIControl-based object and triggers any attached DidDeselect events.
	
	- parameter view: A UIControl to process
	- returns: A boolean flag indicating if the supplied control successfully triggered a DidDeselect event
	*/
	public class func trackDidDeselectControl(control: UIControl?) -> Bool {
		return track(control, trigger: SparkTriggerType.DidDeselect)
	}
	
	// MARK: - Private
	
	private class func trackViews(views: NSArray?, trigger: SparkTriggerType) -> Bool {
		guard let views = views as? Array<UIView> else {
			return false
		}
		
		var result = false
		
		for view in views {
			let success = track(view, trigger: trigger)
			if success {
				result = success
			}
		}
		
		return result
	}
	
	private class func trackTouches(touches: NSSet?, phase: UITouchPhase) -> Bool {
		guard let touch = touches?.anyObject() as? UITouch where touch.phase == phase,
			  let view = touch.view where view.userInteractionEnabled else {
				return false
		}
		
		if let control = view as? UIControl {
			guard control.touchInside else {
				return false
			}
		} else {
			guard view.pointInside(touch.locationInView(view), withEvent: nil) else {
				return false
			}
		}
		
		return track(view, trigger: SparkTriggerType.DidEndTouch)
	}
	
	private class func trackScrolling(view: UIScrollView?, trigger: SparkTriggerType) -> Bool {
		guard let scrollView = view as UIScrollView? where scrollView.tracking else {
			return false
		}
		
		return track(scrollView, trigger: trigger)
	}
	
	private class func track(view: UIView?, trigger: SparkTriggerType = SparkTriggerType.None) -> Bool {
		guard let events = view?.sparkEvents(trigger) else {
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
	private func sparkEvents(trigger: SparkTriggerType) -> [SparkEvent]? {
		func matchingTrigger(event: SparkEvent) -> Bool {
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
			} else if trigger == SparkTriggerType.DidEndTouch {
				// UITableViewCells often generate events from views embedded within the cell.
				return findSuperviewCell()?.sparkEvents?.filter(matchingTrigger)
			}
			return nil
		}
		
		guard let result = events() where !result.isEmpty else {
			return nil
		}
		
		return result
	}
}

#endif
