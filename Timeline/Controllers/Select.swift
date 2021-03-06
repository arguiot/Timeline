//
//  Select.swift
//  Timeline
//
//  Created by Arthur Guiot on 24/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit
import CloudKit
import Hero

class Select: UIViewController {

    @IBOutlet weak var bluredBG: UIImageView!
    
    var cell: ToDos?
    var todos = [ToDos]()
    
    var img = UIImage()
    
    var LandingVC: Landing?
    var NewVC: New?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bluredBG.image = img
        bluredBG.blurView.setup(style: .dark, alpha: 0.9).enable()
        
        
        LandingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingVC") as? Landing
        LandingVC?.hero.isEnabled = true
        LandingVC?.hero.modalAnimationType = .zoomOut
        
        NewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewVC") as? New
        NewVC?.hero.isEnabled = true
        NewVC?.hero.modalAnimationType = .pageIn(direction: .left)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let impact = UIImpactFeedbackGenerator()
    @IBAction func LandingVCmove(_ sender: Any) {
        impact.impactOccurred()
        
        self.hero.replaceViewController(with: LandingVC!)
    }
    
    let db = CKContainer.default().privateCloudDatabase
    @IBAction func deleteToDo() {
        let i = LandingVC?.todos.index(of: cell!) ?? 0
        db.delete(withRecordID: (cell?.record)!) { (id, error) in
            if error != nil {
                Alert().alert("Error", "\(error.debugDescription)", VC: self)
            }
            print("Deleted row \(id): \(error)")
        }
        
        todos.remove(at: Int(i))
        
        LandingVC?.todos = todos
        LandingVCmove(self)
    }
    
    
    @IBAction func editToDo() {
        NewVC?.todo = cell
        NewVC?.todos = todos
        NewVC?.editMode = true
        
        self.hero.replaceViewController(with: NewVC!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
