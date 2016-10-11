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
	
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let _ = SparkDetector.trackDisplay(views: [cell])
	}
	
	public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let _ = SparkDetector.trackDisplay(views: [view])
	}
	
	public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		let _ = SparkDetector.trackDisplay(views: [view])
	}

	// Did end displaying: cells, header and footer views
	
	public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let _ = SparkDetector.trackEndDisplaying(views: [cell])
	}
	
	public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
		let _ = SparkDetector.trackEndDisplaying(views: [view])
	}
	
	public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
		let _ = SparkDetector.trackEndDisplaying(views: [view])
	}
}

extension SparkViewController: UICollectionViewDelegate {
	// Will display: cells and supplementary views

	public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let _ = SparkDetector.trackDisplay(views: [cell])
	}
	
	public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
		let _ = SparkDetector.trackDisplay(views: [view])
	}
	
	// Did end displaying: cells and supplementary views

	public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let _ = SparkDetector.trackEndDisplaying(views: [cell])
	}
	
	public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: IndexPath) {
		let _ = SparkDetector.trackEndDisplaying(views: [view])
	}
}
