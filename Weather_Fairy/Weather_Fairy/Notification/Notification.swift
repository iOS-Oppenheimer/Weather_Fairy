

import CoreLocation
import Foundation
import UIKit
import UserNotifications

let topView = TopView() // 메인페이지 온도 label에 접근하기위함
let currentLocationViewItem = CurrentLocationViewItem()
let myLocationUIView = MyLocationUIView()

// MARK: - 알림

class NotificationForWeather_Fairy {
    var timer: Timer?
    var notificationCounter = 0
    var location: CLLocation?
    var celsius: Double?

    // MARK: - 메인페이지 로드시 딱한번만 나올 알림

    func openingNotification() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: now)
            if (0..<24).contains(components.hour!) {
                notificationForWeather(title: "ウェザ フェアリー(웨쟈 페아리)", body: "오늘 날씨를 확인해보세요 !")
                self.timer?.invalidate()
            }
        }
    }

    func apiForNotification(latitude _: Double, longitude _: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let location = self.location else { return }
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: now)
            let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(geoAPIKey)&units=metric&lang=kr"

            guard let url = URL(string: urlStr) else { return }

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("실패 ", error)
                    return
                }
                guard let data = data else { return }

                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                        if let mainDict = jsonResult["main"] as? [String: Any],
                           let tempValue = mainDict["temp"] as? Double
                        {
                            DispatchQueue.main.async {
                                print("가져온 온도: \(tempValue)")
                                self.updateCelsiusLabel(Double(tempValue))
                            }
                        }
                    }
                } catch {
                    print("실패 ", error)
                }
            }

            task.resume()
        }
    }

    func updateCelsiusLabel(_ celsius: Double) {
        DispatchQueue.main.async {
            topView.celsiusLabel.text = "\(Int(celsius))"
            self.celsius = celsius
            print("asdfa \(celsius)")
            self.sendingPushNotification()
        }
    }

    func sendingPushNotification() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let celsius = self.celsius else { return }
            print(celsius)
            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: now)
            if (0..<24).contains(components.hour!), (0..<60).contains(components.minute!) {
                if celsius >= 12, celsius <= 20 {
                    self.notificationForWeather(title: "ウェザ フェアリー(웨쟈 페아리)", body: "겉 옷 챙기는것도 좋을거같습니다!")
                } else if celsius >= 35, celsius <= 42 {
                    self.notificationForWeather(title: "ウェザ フェアリー(웨쟈 페아리)", body: "나가면 진짜 후회할지도")
                } else if celsius >= -10, celsius <= 10 {
                    self.notificationForWeather(title: "ウェザ フェアリー(웨쟈 페아리)", body: "따뜻한 옷 챙겨 입어야합니다.")
                }
            } else {
                print("뭔가가 안되는중")
            }
        }
    }

    // MARK: - 알람 배너 설정 배너 내용-트리거-생성

    func notificationForWeather(title: String, body: String) {
        let pushNotification = UNMutableNotificationContent()
        pushNotification.title = title
        pushNotification.body = body
        pushNotification.sound = UNNotificationSound.default

        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false )
        let request = UNNotificationRequest(identifier: " NotificationForWeather_Fairy ", content: pushNotification, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(" 푸시 알림 Error: \(error.localizedDescription) ")
            } else {
                print(" 푸시 알림 ON ")
            }
        }
    }
}
