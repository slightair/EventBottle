import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let path = NSTemporaryDirectory() + "hoge.events"
        let fileURL = URL(fileURLWithPath: path)
        print(path)

        let eventDataStore = EventBottleFileEventDataStore(fileURL: fileURL)
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController() as! ViewController
        viewController.eventDataStore = eventDataStore
        viewController.title = "View"

        let eventDataSource = EventBottleFileEventDataSource(fileURL: fileURL)
        let eventBottleViewController = EventBottleViewController(eventDataSource: eventDataSource)
        eventBottleViewController.title = "Events"

        let tabController = UITabBarController()
        tabController.viewControllers = [
            viewController,
            eventBottleViewController,
        ].map { UINavigationController(rootViewController: $0) }
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()

        return true
    }
}
