//
//  Notification.swift
//  Weather_Fairy
//
//  Created by t2023-m0081 on 2023/09/26.
//

import Foundation
import UIKit
import UserNotifications

let topView = TopView() // 메인페이지 온도 label에 접근하기위함
let currentLocationViewItem = CurrentLocationViewItem()

// MARK: - 알림

class NotificationForWeather_Fairy {
    var timer: Timer?
    var notificationCounter = 0
    
    // MARK: - 메인페이지 로드시 딱한번만 나올 알림

    func openingNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
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
    
    // MARK: - 조건성립시 즉시 알림 생성

    func sendingPushNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: now)
            if (0..<24).contains(components.hour!), (0..<60).contains(components.minute!) {
                if let celsiusText = topView.celsiusLabel.text, let celsius = Int(celsiusText) {
                    if celsius >= 12 && celsius <= 20 {
                        notificationForWeather(title: "선선한 날씨에요!", body: "겉 옷 챙기는것도 좋을거같습니다!")
                            
                    } else if celsius >= 35 && celsius <= 42 {
                        notificationForWeather(title: "폭 염 주 의", body: "나가면 진짜 후회할지도")
                            
                    } else if celsius >= -10 && celsius <= 10 {
                        notificationForWeather(title: "얼어 죽어요!", body: "따뜻한 옷 챙겨 입어야합니다.")
                    }
                }
            }
            
            if (0..<24).contains(components.hour!), (0..<60).contains(components.minute!) {
                let rainfallText = currentLocationViewItem.sunsetValue.text ?? "0%"
                if rainfallText.hasSuffix("%") {
                    let rainfallPercentage = Int(rainfallText.trimmingCharacters(in: .punctuationCharacters).trimmingCharacters(in: .whitespaces)) ?? 0
                    if rainfallPercentage >= 50, rainfallPercentage <= 100 {
                        notificationForWeather(title: "ウェザ フェアリー(웨쟈 페아리)", body: "비 올 확률이 높아요! 우산을 챙기세요!")
                    }
                }
            }
        }
            
        // MARK: - 즉시알림이 뜬후 두번더 알림 생성
            
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: now)
                
            if (0..<24).contains(components.hour!), (0..<60).contains(components.minute!) {
                if let celsiusText = topView.celsiusLabel.text, let celsius = Int(celsiusText) {
                    if celsius >= 12 && celsius <= 20 {
                        notificationForWeather(title: "선선한 날씨에요!", body: "겉 옷 챙기는것도 좋을거같습니다!")
                        self.notificationCounter += 1
                        if self.notificationCounter == 1 {
                            self.timer?.invalidate()
                        }
                            
                    } else if celsius >= 35 && celsius <= 42 {
                        notificationForWeather(title: "폭 염 주 의", body: "나가면 진짜 후회할지도")
                        self.notificationCounter += 1
                        if self.notificationCounter == 1 {
                            self.timer?.invalidate()
                        }
                            
                    } else if celsius >= -10 && celsius <= 10 {
                        notificationForWeather(title: "얼어 죽어요!", body: "따뜻한 옷 챙겨 입어야합니다.")
                        self.notificationCounter += 1
                        if self.notificationCounter == 1 {
                            self.timer?.invalidate()
                        }
                    }
                }
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
