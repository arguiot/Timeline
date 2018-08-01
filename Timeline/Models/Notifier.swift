//
//  Notifier.swift
//  Timeline
//
//  Created by Arthur Guiot on 1/8/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import Foundation
import OneSignal

class Notifier {
    let id = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId
    func createNotification(todo: ToDos, callback: @escaping ([AnyHashable: Any]) -> Void) {
        
        // compute date
        let diff = todo.date.timeIntervalSince(todo.initDate) * 0.9 // Notification at 90%
        let finalDate = todo.initDate.addingTimeInterval(diff)
        
        OneSignal.postNotification([
            "contents": ["en": "Your todo titled \"\(todo.name)\" is almost finished. Make sure everything is done in time."],
            "include_player_ids": [id],
            "send_after": finalDate.description
            ], onSuccess: { (data) in
                callback(data!)
        }) { (error) in
            print("OneSignal: \(error)")
        }
    }
}
