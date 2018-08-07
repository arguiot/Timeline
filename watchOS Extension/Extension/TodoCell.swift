//
//  TodoCell.swift
//  watchOS Extension
//
//  Created by Arthur Guiot on 7/8/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import Foundation
import WatchKit

class Cell: NSObject {
    @IBOutlet weak var name: WKInterfaceLabel!
    @IBOutlet weak var progress: WKInterfaceLabel!
}
