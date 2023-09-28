//
//  Notification.swift
//  Weather_Fairy
//
//  Created by t2023-m0081 on 2023/09/26.
//

import Foundation
import UIKit
import UserNotifications

let topView = TopView()

class NotificationForUmbrella {
    var timer: Timer?
    var notificationCounter = 0
    func sendingPushNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: now)
            if (0..<24).contains(components.hour!), (0..<60).contains(components.minute!) {
                if let celsiusText = topView.celsiusLabel.text, let celsius = Int(celsiusText) {
                    if celsius >= 20 && celsius <= 25 {
                        notificationForUmbrella(title: "비 올 확률이 높아요!", body: "홀딱 젖지말고 우산 챙겨요!!!")
                    
                        // timer.invalidate()
                    } else if celsius >= 35 && celsius <= 42 {
                        notificationForUmbrella(title: "오늘 엄청 더워요!", body: "집에서 !")
                    
                        // timer.invalidate()
                    } else if celsius >= -10 && celsius <= 10 {
                        notificationForUmbrella(title: "얼어 죽어요!", body: "너무 추워요. 따뜻하게 입고 나가세요!")
                    
                        // timer.invalidate()
                    }
                }
            }
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: now)
        
            if (0..<24).contains(components.hour!), (0..<60).contains(components.minute!) {
                if let celsiusText = topView.celsiusLabel.text, let celsius = Int(celsiusText) {
                    if celsius >= 20 && celsius <= 25 {
                        notificationForUmbrella(title: "비 올 확률이 높아요!", body: "홀딱 젖지말고 우산 챙겨요!!!")
                        self.notificationCounter += 1
                        if self.notificationCounter == 2 {
                            self.timer?.invalidate()
                        }
                       
                    } else if celsius >= 35 && celsius <= 42 {
                        notificationForUmbrella(title: "오늘 엄청 더워요!", body: "집에서 !")
                        self.notificationCounter += 1
                        if self.notificationCounter == 1 {
                            self.timer?.invalidate()
                        }
                    
                    } else if celsius >= -10 && celsius <= 10 {
                        notificationForUmbrella(title: "얼어 죽어요!", body: "너무 추워요. 따뜻하게 입고 나가세요!")
                        self.notificationCounter += 1
                        if self.notificationCounter == 1 {
                            self.timer?.invalidate()
                        }
                    }
                }
            }
        }
    
        func notificationForUmbrella(title: String, body: String) {
            let pushNotification = UNMutableNotificationContent()
            pushNotification.title = title
            pushNotification.body = body
            pushNotification.sound = UNNotificationSound.default
            
            // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false )
            let request = UNNotificationRequest(identifier: " NotificationForUmbrella ", content: pushNotification, trigger: nil)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(" 푸시 알림 Error: \(error.localizedDescription) ")
                } else {
                    print(" 푸시 알림 ON ")
                }
            }
        }
    }
}
