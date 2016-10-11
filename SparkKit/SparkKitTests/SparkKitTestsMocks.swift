/**
 *  SparkKitTestsMocks.swift
 *  SparkKitTests
 *
 *  Created by Steve Elliott on 05/05/2016.
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
import SparkKit


class UITouchMock : UITouch {
	var _phase: UITouchPhase = UITouchPhase.ended
	var _view: UIView = UIView()
	
	override var phase: UITouchPhase {
		get {
			return _phase
		}
		
		set {
			_phase = newValue
		}
	}
	
	override var view: UIView {
		get {
			return _view
		}
		
		set {
			_view = newValue
		}
	}
}

class PointInsideViewMock: UIView {
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return true
	}
}

class TouchInsideSparkButtonMock: SparkButton {
	override var isTouchInside: Bool {
		get {
			return true
		}
	}
}

class PointInsideSparkCollectionViewCellMock: SparkCollectionViewCell {
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return true
	}
}

class PointInsideSparkTableViewCellMock: SparkTableViewCell {
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return true
	}
}
