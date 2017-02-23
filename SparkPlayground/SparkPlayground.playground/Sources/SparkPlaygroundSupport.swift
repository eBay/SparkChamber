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
	
	public init() {
		let viewController = UIViewController()
		viewController.title = "Spark Chamber Playground"
		viewController.view.backgroundColor = .white
		
		self.viewController = viewController
		self.navigationController = UINavigationController(rootViewController: viewController)
	}
	
	public func display() {
		let tableViewButton = SparkButton(type: .system) as SparkButton
		tableViewButton.setTitle("Present table view", for: UIControlState.normal)
		tableViewButton.sizeToFit()
		tableViewButton.center = viewController.view.center
		tableViewButton.center.y -= 20
		tableViewButton.addTarget(self, action: #selector(presentTableView(sender:)), for: UIControlEvents.touchUpInside)
		
		let collectionViewButton = SparkButton(type: .system) as SparkButton
		collectionViewButton.setTitle("Present collection view", for: UIControlState.normal)
		collectionViewButton.sizeToFit()
		collectionViewButton.center = viewController.view.center
		collectionViewButton.center.y += 20
		collectionViewButton.addTarget(self, action: #selector(presentCollectionView(sender:)), for: UIControlEvents.touchUpInside)
		
		let stackView = UIStackView(arrangedSubviews: [tableViewButton, collectionViewButton])
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.alignment = .center
		stackView.spacing = 4
		stackView.translatesAutoresizingMaskIntoConstraints = false
		viewController.view.addSubview(stackView)
		
		let viewsDictionary = ["stackView": stackView]
		let stackView_H = NSLayoutConstraint.constraints(
			withVisualFormat: "H:|[stackView]|",
			options: NSLayoutFormatOptions(rawValue: 0),
			metrics: nil,
			views: viewsDictionary)
		let stackView_V = NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-200-[stackView]-200-|",
			options: NSLayoutFormatOptions(rawValue:0),
			metrics: nil,
			views: viewsDictionary)
		viewController.view.addConstraints(stackView_H)
		viewController.view.addConstraints(stackView_V)
		
		//Run playground
		let window = UIWindow(frame: screenBounds)
		window.rootViewController = self.navigationController
		window.makeKeyAndVisible()
				
		PlaygroundPage.current.liveView = window
		PlaygroundPage.current.needsIndefiniteExecution = true
	}
	
	@objc func presentTableView(sender:UIButton) {
		navigationController.pushViewController(PlaygroundTableViewController(), animated: true)
	}
	
	@objc func presentCollectionView(sender:UIButton) {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		layout.itemSize = CGSize(width: 135, height: 135)
		
		navigationController.pushViewController(PlaygroundCollectionViewController(), animated: true)
	}
}

open class TableViewController: SparkViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
	public let tableViewData = ["Apple", "Apricot", "Banana", "Blackberry", "Blueberry", "Clementine", "Fig", "Grape", "Grapefruit", "Kiwi", "Lemon", "Lime", "Mango", "Marionberry", "Orange", "Papaya", "Peach", "Pear", "Pineapple", "Plum", "Pomegranate", "Raspberry", "Strawberry", "Tangerine", "Tomato", "Watermelon"]
	public var tableView: UITableView?
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Table View"
		
		let tableView = UITableView(frame: screenBounds, style: UITableViewStyle.plain)
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
	
	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

open class PlaygroundTableViewController: TableViewController {}

public class SparkCollectionViewCellWithTextLabel: SparkCollectionViewCell {
	public var textLabel: UILabel?
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = .orange
		
		let label = UILabel(frame: CGRect(x:0.0, y:60.0, width:150.0, height:30.0))
		label.textColor = .white
		label.textAlignment = NSTextAlignment.center
		label.backgroundColor = .clear
		textLabel = label
		self.contentView.addSubview(label)
	}
	
	required public init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
	}
}

open class CollectionViewController: SparkViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
	public var collectionView: UICollectionView!
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Collection View"
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
		flowLayout.minimumInteritemSpacing = 10.0
		flowLayout.minimumLineSpacing = 10.0
		flowLayout.itemSize = CGSize(width:145.0, height:145.0)
		
		self.collectionView = UICollectionView(frame: screenBounds, collectionViewLayout: flowLayout)
		self.collectionView.register(SparkCollectionViewCellWithTextLabel.self, forCellWithReuseIdentifier: "collectionViewCell")
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		self.collectionView.backgroundColor = .white
		self.view.addSubview(self.collectionView)
	}
	
	open func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 42
	}
	
	open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! SparkCollectionViewCellWithTextLabel

		return cell
	}
}

open class PlaygroundCollectionViewController: CollectionViewController {}

public let screenBounds = CGRect(x: 0, y: 0, width: 320, height: 480)
public let mainScene = MainScene()
