//
//  Notifier.swift
//  Timeline
//
//  Created by Arthur Guiot on 1/8/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import Foundation
import OneSignal
import UIKit

class Notifier {
    let id = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId
    func createNotification(todo: ToDos, callback: @escaping ([AnyHashable: Any]) -> Void) {
        
        // compute date
        let diff = todo.date.timeIntervalSince(todo.initDate) * 0.9 // Notification at 90%
        let finalDate = todo.initDate.addingTimeInterval(diff)
        
        OneSignal.postNotification([
            "contents": [
                "en": "Your todo titled \"\(todo.name)\" is almost finished. Make sure everything is done in time.",
                "fr": "Le rappel \"\(todo.name)\" est presque finit, veuillez à ce que tout soit finit en temps et en heure."
            ],
            "include_player_ids": [id],
            "send_after": finalDate.description
            ], onSuccess: { (data) in
                callback(data!)
        }) { (error) in
            print("OneSignal: \(error)")
        }
        
        // Adding second notification
        OneSignal.postNotification([
            "contents": [
                "en": "Your todo titled \"\(todo.name)\" should be done, and was deleted. Here is what you should have done: \(todo.desc)"
            ],
            "include_player_ids": [id],
            "send_after": todo.date.description
            ], onSuccess: { (data) in
                callback(data!)
        }) { (error) in
            print("OneSignal: \(error)")
        }
    }
    
}
