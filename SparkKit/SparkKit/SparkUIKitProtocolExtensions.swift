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


// MARK: - Protocol extensions

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

extension SparkViewController: UITableViewDelegate {
	// Will display: cells, header and footer views
	
	public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		SparkDetector.trackDisplayViews([cell])
	}
	
	public func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		SparkDetector.trackDisplayViews([view])
	}
	
	public func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		SparkDetector.trackDisplayViews([view])
	}

	// Did end displaying: cells, header and footer views
	
	public func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		SparkDetector.trackEndDisplayingViews([cell])
	}
	
	public func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
		SparkDetector.trackEndDisplayingViews([view])
	}
	
	public func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
		SparkDetector.trackEndDisplayingViews([view])
	}
}

extension SparkViewController: UICollectionViewDelegate {
	// Will display: cells and supplementary views

	public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		SparkDetector.trackDisplayViews([cell])
	}
	
	public func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
		SparkDetector.trackDisplayViews([view])
	}
	
	// Did end displaying: cells and supplementary views

	public func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		SparkDetector.trackEndDisplayingViews([cell])
	}
	
	public func collectionView(collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
		SparkDetector.trackEndDisplayingViews([view])
	}
}
