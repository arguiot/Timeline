//
//  InterfaceController.swift
//  watchOS Extension
//
//  Created by Arthur Guiot on 7/8/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import WatchKit
import Foundation
import CloudKit

class InterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        loadTodos()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    var todos = [ToDos]()
    
    let db = CKContainer.default().privateCloudDatabase
    
    func fetchItems(completionHandler: @escaping ([ToDos]) -> Void) {
        let query = CKQuery(recordType: "ToDos", predicate: NSPredicate(value: true))
        // Last created first
        query.sortDescriptors = [NSSortDescriptor(key: "initDate", ascending: false)]
        
        db.perform(query, inZoneWith: nil) { (records, error) in
            if error != nil {
                print("Log: \(String(describing: error))")
            }
            
            guard let records = records else { return }
            self.todos = [] // Emptying todos
            for record in records {
                self.todos.append(ToDos(name: record.value(forKey: "name") as! String,
                                        desc: record.value(forKey: "desc") as! String,
                                        date: record.value(forKey: "date") as! Date,
                                        initDate: record.value(forKey: "initDate") as! Date,
                                        record: record.recordID))
            }
            DispatchQueue.main.sync {
               completionHandler(self.todos)
            }
        }
    }
    func loadTodos() {
        fetchItems { (data) in
            self.table.setNumberOfRows(data.count, withRowType: "Todo")
            
            let rowCount = self.table.numberOfRows
            for i in 0...rowCount {
                let row = self.table.rowController(at: i) as! Cell
                
                row.name.setText(data[i].name)
                
                // compute progress
                let d1d2 = Float(
                    data[i].date.timeIntervalSince((data[i].initDate))
                )
                let nowd2 = Float(
                    Date().timeIntervalSince(data[i].initDate)
                )
                let p = Int((nowd2 / d1d2) * 100)
                
                row.progress.setText(String(p))
                
            }
        }
    }
}
