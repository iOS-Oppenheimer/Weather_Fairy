import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let rootViewController = MainViewController()
        let rootNavigationController = UINavigationController(rootViewController: rootViewController)
        
        self.window?.rootViewController = rootNavigationController
        self.window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                /*
                 로컬 알림을 발송할 수 있는 상태이면
                 - 유저의 동의를 구한다.
                 */
                let nContent = UNMutableNotificationContent() // 로컬알림에 대한 속성 설정 가능
                nContent.title = "🦠오늘의 코로나 현황 알림⏰"
                nContent.subtitle = "총 확진자 : \n 우리지역 확진자 : "
                nContent.body = "총 확진자 : \n 우리지역 확진자 : "
                nContent.sound = UNNotificationSound.default
                nContent.userInfo = ["name": "lgvv"]
                
                var date = DateComponents()
                date.hour = 22
                date.minute = 15
                
                // 알림 발송 조건 객체
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
                // 알림 요청 객체
                let request = UNNotificationRequest(identifier: "wakeup", content: nContent, trigger: trigger)
                // NotificationCenter에 추가
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            } else {
                NSLog("User not agree")
            }
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
