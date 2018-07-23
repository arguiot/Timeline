//
//  ToDos.swift
//  Timeline
//
//  Created by Arthur Guiot on 23/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import Foundation

class ToDos {
    var name: String
    var desc: String
    var date: Date
    var initDate: Date
    init(name: String, desc: String, date: Date, initDate: Date) {
        self.name = name
        self.desc = desc
        self.date = date
        self.initDate = initDate
    }
}
