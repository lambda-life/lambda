import SwiftUI

final class Scene: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo: UISceneSession, options: UIScene.ConnectionOptions) {
        let window = UIWindow(windowScene: scene as! UIWindowScene)
        window.rootViewController = Launch()
        window.makeKeyAndVisible()
        (UIApplication.shared.delegate as! App).windows.insert(window)
    }
}
