/**
 *  SparkPlaygroundSupport.swift
 *  SparkPlayground
 *
 *  Created by Steve Elliott on 10/18/2016.
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
import PlaygroundSupport
import SparkChamber
import SparkKit


public class MainScene {
	public let viewController: UIViewController
	public let navigationController: UINavigationController
	public let tableViewButton: SparkButton = SparkButton(type: .system) as SparkButton

	public init() {
		let viewController = UIViewController()
		viewController.title = "Spark Chamber Playground"
		viewController.view.backgroundColor = .white
		
		self.viewController = viewController
		self.navigationController = UINavigationController(rootViewController: viewController)
	}
	
	public func display() {
		tableViewButton.setTitle("Present table view", for: UIControl.State.normal)

		let stackView = UIStackView(arrangedSubviews: [tableViewButton])
		stackView.axis = .vertical
		stackView.distribution = .fillProportionally
		stackView.alignment = .center
		stackView.spacing = 4
		stackView.translatesAutoresizingMaskIntoConstraints = false
		viewController.view.addSubview(stackView)
	
		let viewsDictionary = ["stackView": stackView]
		let stackView_H = NSLayoutConstraint.constraints(
			withVisualFormat: "H:|[stackView]|",
			options: NSLayoutConstraint.FormatOptions(rawValue: 0),
			metrics: nil,
			views: viewsDictionary)
		let stackView_V = NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-200-[stackView]-200-|",
			options: NSLayoutConstraint.FormatOptions(rawValue:0),
			metrics: nil,
			views: viewsDictionary)
		viewController.view.addConstraints(stackView_H)
		viewController.view.addConstraints(stackView_V)
		
		addButtonTargetActions()
		
		//Run playground
		let window = UIWindow(frame: screenBounds)
		window.rootViewController = self.navigationController
		window.makeKeyAndVisible()
				
		PlaygroundPage.current.liveView = window
		PlaygroundPage.current.needsIndefiniteExecution = true
	}

	func addButtonTargetActions() {
		tableViewButton.addTarget(self, action: #selector(presentTableView(sender:)), for: UIControl.Event.touchUpInside)
	}
	
	@objc func presentTableView(sender:UIButton) {
		navigationController.pushViewController(PlaygroundTableViewController(), animated: true)
	}
}

open class PlaygroundTableViewController: TableViewController { }

open class TableViewController: SparkViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
	public let tableViewData = ["Apple", "Apricot", "Banana", "Blackberry", "Blueberry", "Clementine", "Fig", "Grape", "Grapefruit", "Kiwi", "Lemon", "Lime", "Mango", "Marionberry", "Orange", "Papaya", "Peach", "Pear", "Pineapple", "Plum", "Pomegranate", "Raspberry", "Strawberry", "Tangerine", "Tomato", "Watermelon"]
	public var tableView: UITableView?
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Table View"
		
		let tableView = UITableView(frame: screenBounds, style: UITableView.Style.plain)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(SparkTableViewCell.self, forCellReuseIdentifier: "tableViewCell")
		self.tableView = tableView
		self.view.addSubview(tableView)
	}
	
	open func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableViewData.count
	}
	
	dynamic open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! SparkTableViewCell

		return cell
	}
	
	// SparkViewController has a default implementation for tableView(didSelectRowAt:) that triggers Spark Detector
	// So we override, call super, and implement our code here
	override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		super.tableView(tableView, didSelectRowAt: indexPath)
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

public let screenBounds = CGRect(x: 0, y: 0, width: 320, height: 480)
public let mainScene = MainScene()
