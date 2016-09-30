/**
*  SparkTableViewCell.swift
*  SparkKit
*
*  Created by Steve Elliott on 09/30/2016.
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
import UIKit

import SparkChamber


public class SparkTableViewCell : UITableViewCell {
	override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		SparkDetector.trackEndedTouches(touches)
		
		super.touchesEnded(touches, withEvent: event)
	}
}