import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customisation after application launch.
        let screenWindow = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        screenWindow.rootViewController = navigationController
        
        let moduleFactory = ModuleFactory()
        let coord = AppCoordinator(navigationController: navigationController, moduleFactory: moduleFactory)
        coord.start()
        
        appCoordinator = coord
        window = screenWindow
        
        screenWindow.makeKeyAndVisible()
        
        return true
    }
}
