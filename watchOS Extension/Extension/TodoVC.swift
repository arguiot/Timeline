//
//  TodoVC.swift
//  watchOS Extension
//
//  Created by Arthur Guiot on 8/8/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import Foundation
import WatchKit
import CloudKit

class TodoVC: WKInterfaceController {
    @IBOutlet var name: WKInterfaceLabel!
    @IBOutlet var desc: WKInterfaceLabel!
    @IBOutlet var date: WKInterfaceLabel!
    @IBOutlet var progress: WKInterfaceLabel!
    
    var td: ToDos?
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let t = context as! ToDos
        
        td = t // for later use
        
        name.setText(t.name)
        desc.setText(t.desc)
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "M/d/yy, hh:mm"
        date.setText(formatter.string(from: t.date))
        
        // compute progress
        let d1d2 = Float(
            t.date.timeIntervalSince(t.initDate)
        )
        let nowd2 = Float(
            Date().timeIntervalSince(t.initDate)
        )
        let p = Int((nowd2 / d1d2) * 100)
        progress.setText("\(p)%")
    }
    @IBAction func done() {
        deleteTodo()
    }
    @IBAction func delete() {
        deleteTodo()
    }
    
    let db = CKContainer.default().privateCloudDatabase
    func deleteTodo() {
        db.delete(withRecordID: (td?.record)!) { (recrd, error) in
            if error != nil {
                self.presentAlert(withTitle: "Error", message: "Log: \(String(describing: error))", preferredStyle: .alert, actions: [WKAlertAction(title: "Cancel", style: .cancel) {}])
            }
            self.pop()
        }
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
