//
//  ViewController.swift
//  Timeline
//
//  Created by Arthur Guiot on 20/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit
import Hero
import CloudKit

class Landing: UIViewController {

    @IBOutlet weak var TopBar: TopBar!
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var nTodos: UILabel!
    
    let NewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewVC") as! New
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hero.isEnabled = true
        
        TopBar.back.isHidden = true
        
        NewVC.hero.isEnabled = true
        NewVC.hero.modalAnimationType = .pull(direction: .left)
        
        SelectVC.hero.isEnabled = true
        SelectVC.hero.modalAnimationType = .zoom
        
        TableView.contentInset = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0)
        
        if todos.isEmpty {
            loadData()
        }
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.loadData), userInfo: nil, repeats: true) // Refresh every 5 seconds
        
        
        nTodos.text = "You have \(todos.count) todos"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func NewVCmove() {
        NewVC.todos = todos
        
        self.hero.replaceViewController(with: NewVC)
    }
    
    var todos = [ToDos]()
    
    let db = CKContainer.default().privateCloudDatabase
    
    @objc func loadData() {
        let query = CKQuery(recordType: "ToDos", predicate: NSPredicate(value: true))
        // Last created first
        query.sortDescriptors = [NSSortDescriptor(key: "initDate", ascending: false)]
        
        db.perform(query, inZoneWith: nil) { (records, error) in
            if error != nil {
                print("Log: \(String(describing: error))")
                Alert().alert("Error", "\(error.debugDescription)", VC: self)
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
            DispatchQueue.main.async {
                self.TableView.reloadData()
                
                self.nTodos.text = "You have \(self.todos.count) todos"
            }
        }
    }
    let SelectVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectVC") as! Select
    
    let impact = UIImpactFeedbackGenerator()
    @IBAction func SelectVCmode(_ sender: TBButton) {
        SelectVC.img = self.view.asImage()
        SelectVC.cell = todos[sender.row!]
        SelectVC.todos = todos
        
        impact.impactOccurred()
        
        self.hero.replaceViewController(with: SelectVC)
    }
    

}

extension Landing: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = todos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodoCell
        
        cell.setValues(todo: todo, row: indexPath.row)
        return cell
    }
    
    
}

