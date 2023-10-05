

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
    var currentWeatherData: WeatherData?

    // MARK: - 메인페이지 로드시 딱한번만 나올 알림

    func openingNotification() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: now)
            if (0 ..< 24).contains(components.hour!) {
                notificationForWeather(title: "ウェザ フェアリー(웨쟈 페아리)", body: "오늘 날씨를 확인해보세요 !")
                self.timer?.invalidate()
            }
        }
    }

    // MARK: - api정보 ( 지금 온도)

    func dataForNotification(with data: WeatherData) {
        let temperature = Int(data.main.temp)
        currentWeatherData = data
        topView.celsiusLabel.text = "\(temperature)"
//        print("api 온도 가져오기 : \(Int(data.main.temp))")
        let humide = Int(data.main.humidity)
//        print("api 습도 가져오기 : \(Int(data.main.humidity))")
        currentWeatherData = data
        currentLocationViewItem.humidityValue.text = "\(data.main.humidity)%"

        showTemperatureAlert(temperature: temperature, humide: humide)
    }

    // MARK: - api정보받아서 조건 처리 (받은 정보 temp, humidity)

    func showTemperatureAlert(temperature: Int, humide: Int) {
//        print("함수 온도: \(temperature)") // for checking notificiation

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            var title: String = ""
            var body: String = ""

            //MARK: -  낮은 습도일때 온도별 조건

            if humide <= 45 {
                if temperature >= 36 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 거의 아프리카인대요?
                    현재 습도 \(humide)%
                    """
                } else if temperature >= 24, temperature < 36 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도\(temperature)°C. 덥네요!
                    현재 습도 \(humide)%
                    """
                } else if temperature < 24, temperature >= 18 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 적당한 기온입니다!
                    현재 습도 \(humide)%
                    """
                } else if temperature < 18, temperature >= 9 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 겉옷을 챙기는게 좋아요!
                    현재 습도 \(humide)%
                    """
                } else if temperature < 9, temperature >= 0 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 날씨가 쌀쌀해요!
                    현재 습도 \(humide)%
                    """
                } else if temperature <= 0 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body =
                        """
                        현재 온도 \(temperature)°C. 많이 추워요!!
                        현재 습도 \(humide)%
                        """
                }
                self.notificationForWeather(title: title, body: body)
                
                //MARK: -  적정습도구간때 온도별 조건

            } else if humide > 45, humide < 55 {
                if temperature >= 36 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 거의 아프리카인대요?
                    "현재 습도 \(humide)% 적정 습도입니다.
                    """
                } else if temperature >= 24, temperature < 36 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도\(temperature)°C. 덥네요!
                    현재 습도 \(humide)% 적정 습도입니다.
                    """
                } else if temperature < 24, temperature >= 18 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 적당한 기온입니다!
                    현재 습도 \(humide)% 적정 습도입니다.
                    """
                } else if temperature < 18, temperature >= 9 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 겉옷을 챙기는게 좋아요!
                    현재 습도 \(humide)% 적정 습도입니다.
                    """
                } else if temperature < 9, temperature >= 0 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 날씨가 쌀쌀해요!
                    현재 습도 \(humide)% 적정 습도입니다.
                    """
                } else if temperature <= 0 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body =
                        """
                        현재 온도 \(temperature)°C. 많이 추워요!!
                        현재 습도 \(humide)% 적정 습도입니다.
                        """
                }
                self.notificationForWeather(title: title, body: body)

                
                //MARK: - 좀 높은 습도때 온도별 조건

            } else if humide >= 55, humide <= 75 {
                if temperature >= 36 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 거의 아프리카인대요?
                    "현재 습도 \(humide)% 습도가 좀 높습니다.
                    """
                } else if temperature >= 24, temperature < 36 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도\(temperature)°C. 덥네요!
                    현재 습도 \(humide)% 습도가 좀 높습니다.
                    """
                } else if temperature < 24, temperature >= 18 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 적당한 기온입니다!
                    현재 습도 \(humide)% 습도가 좀 높습니다.
                    """
                } else if temperature < 18, temperature >= 9 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 겉옷을 챙기는게 좋아요!
                    현재 습도 \(humide)% 습도가 좀 높습니다.
                    """
                } else if temperature < 9, temperature >= 0 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 날씨가 쌀쌀해요!
                    현재 습도 \(humide)% 습도가 좀 높습니다.
                    """
                } else if temperature <= 0 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body =
                        """
                        현재 온도 \(temperature)°C. 많이 추워요!!
                        현재 습도 \(humide)% 습도가 좀 높습니다.
                        """
                }
                self.notificationForWeather(title: title, body: body)

                //MARK: - 높은 습도일때 온도별 조건

            } else if humide > 75, humide <= 100 {
                if temperature >= 36 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 거의 아프리카인대요?
                    "현재 습도 \(humide)% 습도가 많이 높습니다.
                    """
                } else if temperature >= 24, temperature < 36 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도\(temperature)°C. 덥네요!
                    현재 습도 \(humide)% 습도가 많이 높습니다.
                    """
                } else if temperature < 24, temperature >= 18 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 적당한 기온입니다!
                    현재 습도 \(humide)% 습도가 많이 높습니다.
                    """
                } else if temperature < 18, temperature >= 9 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 겉옷을 챙기는게 좋아요!
                    현재 습도 \(humide)% 습도가 많이 높습니다.
                    """
                } else if temperature < 9, temperature >= 0 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body = """
                    현재 온도 \(temperature)°C. 날씨가 쌀쌀해요!
                    현재 습도 \(humide)% 습도가 많이 높습니다.
                    """
                } else if temperature <= 0 {
                    title = "ウェザ フェアリー(웨쟈 페아리)"
                    body =
                        """
                        현재 온도 \(temperature)°C. 많이 추워요!!
                        현재 습도 \(humide)% 습도가 많이 높습니다.
                        """
                }
                self.notificationForWeather(title: title, body: body)
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
        let request = UNNotificationRequest(identifier: "NotificationForWeather_Fairy", content: pushNotification, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(" 푸시 알림 Error: \(error.localizedDescription) ")
            } else {
                print(" 푸시 알림 ON ")
            }
        }
    }
}
