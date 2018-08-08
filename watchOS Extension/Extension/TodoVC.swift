//
//  TodoVC.swift
//  watchOS Extension
//
//  Created by Arthur Guiot on 8/8/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import Foundation
import WatchKit

class TodoVC: WKInterfaceController {
    @IBOutlet var name: WKInterfaceLabel!
    @IBOutlet var desc: WKInterfaceLabel!
    @IBOutlet var date: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let t = context as! ToDos
        name.setText(t.name)
        desc.setText(t.desc)
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "M/d/yy, hh:mm"
        date.setText(formatter.string(from: t.date))
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
