import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let tabController = UITabBarController()
        tabController.viewControllers = [
            UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController()!,
        ]
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()

        test()

        return true
    }

    func test() {
        let path = NSTemporaryDirectory() + "hoge.log"
        print(path)
        let fileURL = URL(fileURLWithPath: path)

        let store = FileLogStore(fileURL: fileURL)
        do {
            try store.putLog(["hoge": "fuga"], labels: ["aaa", "test"])
            try store.putLog(123, labels: ["aaa", "test"])
            try store.putLog("hello", labels: ["\"aaa", "[hoge][fuga],xxx"])
        } catch {
            print(error)
        }
    }
}
