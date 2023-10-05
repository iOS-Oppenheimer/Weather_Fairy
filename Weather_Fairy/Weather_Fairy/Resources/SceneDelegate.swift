import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var timer: Timer?
    var notificationCounter = 0
    var window: UIWindow?
    var currentWeatherData: WeatherData?

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

    // MARK: - 어플 실행후 화면이 백그라운드 상태여도 알림이 뜰수있게함

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

    //MARK: - 백그라운드 실시간 온도알림을 위한 api대이터 받기

    func dataForNotificationForBackground(with data: WeatherData) {
        let temperature = Int(data.main.temp)
        currentWeatherData = data
        topView.celsiusLabel.text = "\(temperature)"
//        print("api 온도 가져오기 : \(Int(data.main.temp))")
        let humide = Int(data.main.humidity)
//        print("api 습도 가져오기 : \(Int(data.main.humidity))")
        currentWeatherData = data
        currentLocationViewItem.humidityValue.text = "\(data.main.humidity)%"

        backgroundAPInotification(temperature: temperature, humide: humide)
    }
    
    //MARK: - 백그라운드 실시간 알림

    func backgroundAPInotification(temperature: Int, humide: Int) {
//        print("함수 온도: \(temperature)") // for checking notificiation

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            var title: String = ""
            var body: String = ""

            if temperature > -100, temperature < 100 {
                title = "ウェザ フェアリー(웨쟈 페아리)"
                body = """
                현재 온도 \(temperature)°C
                """
            }
            self.backgroundAPIdataNotificationForWeather(title: title, body: body)
        }
    }
    //MARK: - 백그라운드 알림 생성

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
                print("일간 오전 오후 푸시 알림 ON")
            }
        }
    }
    //MARK: - 백그라운드 특정시간간격으로 실시간 기온 알림 생성

    func backgroundAPIdataNotificationForWeather(title: String, body: String) {
        let backgroundNotification = UNMutableNotificationContent()
        backgroundNotification.title = title
        backgroundNotification.body = body
        backgroundNotification.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true) //1분마다 실시간 백그라운드 알림 한시간 간격으로 하기위한건대 테스트겸 1분으로 해둠

        let request = UNNotificationRequest(identifier: "APIforNotificationForWeather_Fairy", content: backgroundNotification, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("푸시 알림 Error: \(error.localizedDescription)")
            } else {
                print("백그라운드 실시간 온도 한시간 간격 푸시 알림 ON")
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
