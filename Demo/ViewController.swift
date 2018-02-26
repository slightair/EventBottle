import EventBottle
import UIKit

class ViewController: UIViewController {
    var eventDataStore: FileEventDataStore = EventBottleFileEventDataStore.shared

    var event1count = 0
    var event2count = 0
    var event3count = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "View"

        print(eventDataStore.fileURL)
    }

    @IBAction func didTapEvent1Button(_: Any) {
        event1count += 1
        eventDataStore.putEvent("event1", labels: ["event", "test"])
    }

    @IBAction func didTapEvent2Button(_: Any) {
        event2count += 1
        eventDataStore.putEvent(["event": "event2", "count": event2count], labels: ["event", "test", "count"])
    }

    @IBAction func didTapEvent3Button(_: Any) {
        event3count += 1
        let veryLongBody = (0 ..< 100).map { _ in "0" }.joined()
        eventDataStore.putEvent(["event": "event3", "allCount": event1count + event2count + event3count, "body": veryLongBody], labels: ["event", "test", "count", "all"])
    }
}
