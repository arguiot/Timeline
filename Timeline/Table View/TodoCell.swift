//
//  TodoCell.swift
//  Timeline
//
//  Created by Arthur Guiot on 21/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var progressView: Progress!
    
    func setValues(todo: ToDos) {
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
        
        let d1d2 = Float(todo.date.timeIntervalSince(todo.initDate))
        let nowd2 = Float(Date().timeIntervalSince(todo.initDate))
        let p = nowd2 / d1d2
        progressView.progress.progress = p
        
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
}
