//: # Spark Playground
//:
//: Here is a playground that demonstrates Spark Events in action using table and collection views. Be sure to have the Assistant Editor visible to show the view, and make sure the console is visible to see the logging of the various events.

import SparkChamber
import SparkKit

extension PlaygroundTableViewController {
	override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! SparkTableViewCell
		cell.textLabel?.text = tableViewData[indexPath.row]
		
		var appearTime: Date = Date()
		
		let appearEvent = SparkEvent(trigger: SparkTriggerType.didAppear) {
			timestamp in
			appearTime = timestamp
		}
		
		let disappearEvent = SparkEvent(trigger: SparkTriggerType.didDisappear) {
			timestamp in
			print("Time on screen for ", cell.textLabel?.text ?? "unknown cell", ": ", timestamp.timeIntervalSince(appearTime), separator: "")
		}
		
		let touchEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch) {
			timestamp in
			print("Cell touched:", cell.textLabel?.text ?? "unknown cell")
		}
		
		let targetActionEvent = SparkEvent(trigger: SparkTriggerType.targetAction) {
			timestamp in
			print("Cell target action for:", cell.textLabel?.text ?? "unknown cell")
		}
		
		cell.sparkEvents = [appearEvent, disappearEvent, touchEvent, targetActionEvent]
		
		return cell
	}
}

extension PlaygroundCollectionViewController {
	override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! SparkCollectionViewCellWithTextLabel
		cell.textLabel?.text = String(indexPath.row)
		
		var appearTime: Date = Date()
		
		let appearEvent = SparkEvent(trigger: SparkTriggerType.didAppear) {
			timestamp in
			appearTime = timestamp
		}
		
		let disappearEvent = SparkEvent(trigger: SparkTriggerType.didDisappear) {
			timestamp in
			print("Time on screen for cell ", cell.textLabel?.text ?? "unknown cell", ": ", timestamp.timeIntervalSince(appearTime), separator: "")
		}
		
		let touchEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch) {
			timestamp in
			print("Cell touched:", cell.textLabel?.text ?? "unknown cell")
		}
		
		let targetActionEvent = SparkEvent(trigger: SparkTriggerType.targetAction) {
			timestamp in
			print("Cell target action for:", cell.textLabel?.text ?? "unknown cell")
		}
		
		cell.sparkEvents = [appearEvent, disappearEvent, touchEvent, targetActionEvent]
		
		return cell
	}
}

mainScene.display()
