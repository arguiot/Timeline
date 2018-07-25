//
//  ToDos.swift
//  Timeline
//
//  Created by Arthur Guiot on 23/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import Foundation
import CloudKit

class ToDos: Equatable {
    static func == (lhs: ToDos, rhs: ToDos) -> Bool {
        if (lhs.record == rhs.record && lhs.name == rhs.name) {
            return true
        }
        return false
    }
    
    var name: String
    var desc: String
    var date: Date
    var initDate: Date
    var record: CKRecordID?
    init(name: String, desc: String, date: Date, initDate: Date, record: CKRecordID?) {
        self.name = name
        self.desc = desc
        self.date = date
        self.initDate = initDate
        self.record = record
    }
}
