import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let path = NSTemporaryDirectory() + "hoge.log"
        let fileURL = URL(fileURLWithPath: path)
        print(path)

        let logStore = FileLogStore(fileURL: fileURL)
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController() as! ViewController
        viewController.logStore = logStore
        viewController.title = "View"

        let logDataSource = BasketFileLogDataSource(fileURL: fileURL)
        let logViewerViewController = LogViewerViewController(logDataSource: logDataSource)
        logViewerViewController.title = "Logs"

        let tabController = UITabBarController()
        tabController.viewControllers = [
            viewController,
            logViewerViewController,
        ].map { UINavigationController(rootViewController: $0 )}
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()

        return true
    }
}
