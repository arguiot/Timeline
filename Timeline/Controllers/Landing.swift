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
    
    let NewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewVC") as! New
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hero.isEnabled = true
        
        TopBar.back.isHidden = true
        
        NewVC.hero.isEnabled = true
        NewVC.hero.modalAnimationType = .pull(direction: .left)
        
        TableView.contentInset = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0)
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func NewVCmove() {
        self.hero.replaceViewController(with: NewVC)
    }
    
    var todos = [ToDos]()
    
    let db = CKContainer.default().privateCloudDatabase
    func loadData() {
        let query = CKQuery(recordType: "ToDos", predicate: NSPredicate(value: true))
        // Last created first
        query.sortDescriptors = [NSSortDescriptor(key: "initDate", ascending: false)]
        
        db.perform(query, inZoneWith: nil) { (records, error) in
            print("Log: \(error)")
            guard let records = records else { return }
            for record in records {
                self.todos.append(ToDos(name: record.value(forKey: "name") as! String,
                                        desc: record.value(forKey: "desc") as! String,
                                        date: record.value(forKey: "date") as! Date,
                                        initDate: record.value(forKey: "initDate") as! Date))
            }
            DispatchQueue.main.async {
                self.TableView.reloadData()
            }
        }
    }

}

extension Landing: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = todos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! TodoCell
        
        cell.setValues(todo: todo)
        return cell
    }
    
    
}

