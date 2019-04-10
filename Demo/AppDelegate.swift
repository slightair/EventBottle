import EventBottle
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController() as! ViewController
        let eventBottleViewController = EventBottleViewController()

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
