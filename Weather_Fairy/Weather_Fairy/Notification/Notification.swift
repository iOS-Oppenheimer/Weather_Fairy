//
//  Notification.swift
//  Weather_Fairy
//
//  Created by t2023-m0081 on 2023/09/26.
//

import Foundation
import UIKit
import UserNotifications

class NotificationForUmbrella {
    var timer: Timer?

    func sendingPushNotification(for viewController: MainViewController) {

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in

            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: now)


            if (0..<24).contains(components.hour!), (0..<60).contains(components.minute!) {
                if let celsiusText = viewController.celsiusLabel.text, let celsius = Int(celsiusText) {
                    if celsius >= 20 && celsius <= 25 {
                        self?.notificationForUmbrella(title: "야 밖에 비온다", body: "안갖고나가서  화장지워져서  찡찡대지말고  챙겨!")
                        
                        timer.invalidate()
                    } else if celsius >= 35 && celsius <= 42 {
                        self?.notificationForUmbrella(title: "더워 죽어요!", body: "지금 나가면 너무 더워요!")
                     
                        timer.invalidate()
                    } else if celsius >= -10 && celsius <= 10 {
                        self?.notificationForUmbrella(title: "얼어 죽어요!", body: "너무 추워요. 따뜻하게 입고 나가세요!")

                        timer.invalidate()
                    }
                }
            }
        }
    }

    func notificationForUmbrella(title: String, body: String) {

        let pushNotification = UNMutableNotificationContent()
        pushNotification.title = title
        pushNotification.body = body
        
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests { requests in
            let badgeNumber = requests.count + 1 
            pushNotification.badge = NSNumber(value: badgeNumber)
        }
        
        pushNotification.sound = UNNotificationSound.default

       
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
