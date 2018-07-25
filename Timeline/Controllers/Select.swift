//
//  Select.swift
//  Timeline
//
//  Created by Arthur Guiot on 24/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit
import CloudKit

class Select: UIViewController {

    @IBOutlet weak var bluredBG: UIImageView!
    
    var cell: ToDos?
    
    var img = UIImage()
    
    var LandingVC: Landing?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bluredBG.image = img
        bluredBG.blurView.setup(style: .dark, alpha: 0.9).enable()
        
        
        LandingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingVC") as? Landing
        LandingVC?.hero.isEnabled = true
        LandingVC?.hero.modalAnimationType = .zoomOut
        
        print(cell?.name)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func LandingVCmove(_ sender: Any) {
        self.hero.replaceViewController(with: LandingVC!)
    }
    
    let db = CKContainer.default().privateCloudDatabase
    @IBAction func deleteToDo() {
        
        db.delete(withRecordID: (cell?.record)!) { (id, error) in
            print("Deleted row \(id): \(error)")
        }
        LandingVCmove(self)
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
