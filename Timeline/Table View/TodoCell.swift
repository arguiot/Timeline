//
//  TodoCell.swift
//  Timeline
//
//  Created by Arthur Guiot on 21/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit
import CloudKit

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var button: TBButton!
    @IBOutlet weak var progressView: Progress!
    
    
    weak var timer = Timer()
    
    var Todo: ToDos?
    func setValues(todo: ToDos, row: Int) {
        button.row = row
        Todo = todo
        
        title.text = todo.name
        
        var end = "\n\n\n\n"
        todo.desc.enumerateLines { (str, _) in
            end = String(end.dropLast(2))
        }
        desc.text = todo.desc + end
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "E, dd MMM HH:mm"
        date.text = formatter.string(from: todo.date)
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateBar), userInfo: nil, repeats: true)
        
        style()
    }
    private func style() {
        button.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        button.layer.cornerRadius = 5
        button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2513479313)
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 10
        button.layer.shadowPath = UIBezierPath(rect: button.bounds).cgPath
    }
    
    let db = CKContainer.default().privateCloudDatabase
    var deleted = false
    @objc private func updateBar() {
        let d1d2 = Float((Todo?.date.timeIntervalSince((Todo?.initDate)!))!)
        let nowd2 = Float(Date().timeIntervalSince((Todo?.initDate)!))
        let p = 1 - nowd2 / d1d2  // due to gradient (we're reversing the bar)
        
        if p < 0 && deleted == false {
            db.delete(withRecordID: (Todo?.record)!) { (id, error) in
                if error != nil {
                    Alert().alert("Error", "\(error.debugDescription)", VC: self.parentViewController!)
                } else {
                    self.deleted = true
                }
                print("Deleted row \(id?.recordName): \(error)")
                
                (self.parentViewController as! Landing).loadData()
            }
        }
        progressView.progress.setProgress(p, animated: true)
    }
}
