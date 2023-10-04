import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var timer: Timer?
    var notificationCounter = 0
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
    
    //MARK: - 어플 실행후 화면이 백그라운드 상태여도 알림이 뜰수있게함

    func sceneWillResignActive(_ scene: UIScene) {
        UNUserNotificationCenter.current().getNotificationSettings { backgroundNotification in
            // 알림 설정을 확인합니다.
            if backgroundNotification.authorizationStatus == .authorized {
                let now = Date()
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: now)
                if (6..<9).contains(components.hour!) {
                    self.backgroundNotificationForWeather(title: "ウェザ フェアリー(웨쟈 페아리)", body: " 집 나가기전에 날씨 한번 확인 해볼까요 ? :D ")
                    self.timer?.invalidate()
                }
                if (13..<15).contains(components.hour!) {
                    self.backgroundNotificationForWeather(title: "ウェザ フェアリー(웨쟈 페아리)", body: " 오후 1시~3시 하루중 가장 기온이 높은 시간대 입니다! :( ")
                }
                if (21..<23).contains(components.hour!) {
                    self.backgroundNotificationForWeather(title: "ウェザ フェアリー(웨쟈 페아리)", body: " 내일 날씨를 미리 확인해 볼까요 ? :D ")
                    self.timer?.invalidate()
                }
            }
        }
    }

    func backgroundNotificationForWeather(title: String, body: String) {
        let backgroundNotification = UNMutableNotificationContent()
        backgroundNotification.title = title
        backgroundNotification.body = body
        backgroundNotification.sound = UNNotificationSound.default

        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

       
        let request = UNNotificationRequest(identifier: "NotificationForWeather_Fairy", content: backgroundNotification, trigger: trigger)

        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("푸시 알림 Error: \(error.localizedDescription)")
            } else {
                print("푸시 알림 ON")
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
