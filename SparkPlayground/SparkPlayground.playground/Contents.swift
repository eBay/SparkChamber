/*:
# Spark Playground
Here is a playground that demonstrates Spark Events in action using a simple table view.

- Note: Be sure to show Xcode's Assistant editor so you can manipulate the playground's view, and show the Debug area to see events logged in real-time.
*/
import SparkChamber
import SparkKit
/*:
- Important: You must first build the SparkChamber and SparkKit projects contained in this workspace for the playground to work without errors.

Shown below are methods for view loading and table view cell generation. Changing these will affect the view in the Assistant editor in real-time.

Spark events with the trigger types `didAppear`, `didDisappear`, `didEndTouch`, `didBeginScroll`, and `targetAction` are illustrated.
*/
extension PlaygroundTableViewController {
	override open func viewDidLoad() {
		super.viewDidLoad()
		
		// The didBeginScroll event will be triggered each time the table view begins scrolling
		let scrollEvent = SparkEvent(trigger: SparkTriggerType.didBeginScroll) {
			timestamp in
			print("Table view began scrolling")
		}
		
		self.tableView?.sparkEvents = [scrollEvent]
	}
	
	override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! SparkTableViewCell
		cell.textLabel?.text = tableViewData[indexPath.row]
		
		var appearTime: Date = Date()
		
		// The didAppear and didDissapear events are chained together within the cell's local scope to produce a time-on-screen measurement
		let appearEvent = SparkEvent(trigger: SparkTriggerType.didAppear) {
			timestamp in
			appearTime = timestamp
		}
		
		let disappearEvent = SparkEvent(trigger: SparkTriggerType.didDisappear) {
			timestamp in
			print("Time on screen for ", cell.textLabel?.text ?? "unknown cell", ": ", timestamp.timeIntervalSince(appearTime), separator: "")
		}
		
		// A touch event is triggered by the cell's touchesEnded:withEvent: responder method
		let touchEvent = SparkEvent(trigger: SparkTriggerType.didEndTouch) {
			timestamp in
			print("Cell touched:", cell.textLabel?.text ?? "unknown cell")
		}
		
		// The target action event is triggered by the cell's tableView:didSelectRowAtIndexPath: delegate callback
		let targetActionEvent = SparkEvent(trigger: SparkTriggerType.targetAction) {
			timestamp in
			print("Cell target action for:", cell.textLabel?.text ?? "unknown cell")
		}
		
		cell.sparkEvents = [appearEvent, disappearEvent, touchEvent, targetActionEvent]
		
		return cell
	}
}

mainScene.display()
