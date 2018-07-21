//
//  New.swift
//  Timeline
//
//  Created by Arthur Guiot on 21/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit
import Hero

class New: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var TopBar: TopBar!
    
    var LandingVC: Landing?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TopBar.add.isHidden = true
        
        LandingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingVC") as? Landing
        
        LandingVC?.hero.isEnabled = true
        LandingVC?.hero.modalAnimationType = .pull(direction: .right)
        
        let edgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        edgeGestureRecognizer.edges = .left
        edgeGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(edgeGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func LandingVCmove() {
        self.hero.replaceViewController(with: LandingVC!)
    }
    @objc func handlePan(_ sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.hero.replaceViewController(with: LandingVC!)
        case .changed:
            let translation = sender.translation(in: nil)
            let progress = translation.x / 2 / view.bounds.width
            
            Hero.shared.update(progress)
        default:
            Hero.shared.finish()
        }
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
