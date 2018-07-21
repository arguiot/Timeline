//
//  ViewController.swift
//  Timeline
//
//  Created by Arthur Guiot on 20/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit
import Hero

class Landing: UIViewController {

    @IBOutlet weak var TopBar: TopBar!
    
    let NewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewVC") as! New
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hero.isEnabled = true
        
        TopBar.back.isHidden = true
        
        NewVC.hero.isEnabled = true
        NewVC.hero.modalAnimationType = .pull(direction: .left)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func NewVCmove() {
        self.hero.replaceViewController(with: NewVC)
    }

}

