//
//  ViewController.swift
//  Timeline
//
//  Created by Arthur Guiot on 20/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class Landing: UIViewController {

    @IBOutlet weak var TopBar: TopBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        TopBar.back.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

