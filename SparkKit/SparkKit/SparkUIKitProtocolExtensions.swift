/**
 *  SparkUIKitProtocolExtensions.swift
 *  SparkKit
 *
 *  Created by Steve Elliott on 03/02/2016.
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

import SparkChamber


// MARK: - Extensions

// Optional UIApplication support for touchesEnded()

public struct UIApplicationExtensionSupport {
#if UIAPPLICATION_EXTENSION_ENABLED
	static let enabled = true
#else
	static let enabled = false
#endif
}

#if UIAPPLICATION_EXTENSION_ENABLED
extension UIApplication {
	override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		SparkDetector.trackEndedTouches(touches)
		
		super.touchesEnded(touches, withEvent: event)
	}
}
#endif

// SparkViewController UITableViewDelegate default implementations

typealias SparkTableViewDelegate = SparkViewController
extension SparkTableViewDelegate {
	// Will display: cells, header and footer views
	
	@objc(tableView:willDisplayCell:forRowAtIndexPath:) open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		SparkDetector.trackDisplay(forViews: [cell])
	}
	
	@objc(tableView:willDisplayHeaderView:forSection:) open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		SparkDetector.trackDisplay(forViews: [view])
	}
	
	@objc(tableView:willDisplayFooterView:forSection:) open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		SparkDetector.trackDisplay(forViews: [view])
	}

	// Did end displaying: cells, header and footer views
	
	@objc(tableView:didEndDisplayingCell:forRowAtIndexPath:) open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		SparkDetector.trackEndDisplaying(forViews: [cell])
	}
	
	@objc(tableView:didEndDisplayingHeaderView:forSection:) open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
		SparkDetector.trackEndDisplaying(forViews: [view])
	}
	
	@objc(tableView:didEndDisplayingFooterView:forSection:) open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
		SparkDetector.trackEndDisplaying(forViews: [view])
	}
	
	// Did select: cells
	
	@objc(tableView:didSelectRowAtIndexPath:) open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		SparkDetector.trackTargetAction(forView: tableView.cellForRow(at: indexPath))
	}
}

// SparkViewController UICollectionViewDelegate default implementations

typealias SparkCollectionViewDelegate = SparkViewController
extension SparkCollectionViewDelegate {
	// Will display: cells and supplementary views

	@objc(collectionView:willDisplayCell:forItemAtIndexPath:) open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		SparkDetector.trackDisplay(forViews: [cell])
	}
	
	@objc(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:) open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
		SparkDetector.trackDisplay(forViews: [view])
	}
	
	// Did end displaying: cells and supplementary views

	@objc(collectionView:didEndDisplayingCell:forItemAtIndexPath:) open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		SparkDetector.trackEndDisplaying(forViews: [cell])
	}
	
	@objc(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:) open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
		SparkDetector.trackEndDisplaying(forViews: [view])
	}
	
	// Did select: cells
	
	@objc(collectionView:didSelectItemAtIndexPath:) open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		SparkDetector.trackTargetAction(forView: collectionView.cellForItem(at: indexPath))
	}
}

// SparkViewController UIScrollViewDelegate default implementations

typealias SparkScrollViewDelegate = SparkViewController
extension SparkScrollViewDelegate {
	open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		SparkDetector.trackBeganScrolling(forScrollView: scrollView)
	}
}
