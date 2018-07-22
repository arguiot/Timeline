//
//  New.swift
//  Timeline
//
//  Created by Arthur Guiot on 21/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit
import Hero

class New: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate {

    @IBOutlet weak var TopBar: TopBar!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var desc: UITextView!
    
    
    var LandingVC: Landing?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TopBar.add.isHidden = true
        
        desc.delegate = self
        desc.textColor = .lightGray
        
        
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if desc.textColor == .lightGray {
            desc.text = nil
            desc.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if desc.text.isEmpty {
            desc.text = "Description"
            desc.textColor = .lightGray
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Name
        var border = CALayer()
        var width = CGFloat(2.0)
        border.borderColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        border.frame = CGRect(x: 0,
                              y: name.frame.size.height - width,
                              width: name.frame.size.width,
                              height: name.frame.size.height)
        
        border.borderWidth = width
        name.layer.addSublayer(border)
        name.layer.masksToBounds = true
        
        // Description
        border = CALayer()
        width = CGFloat(2.0)
        border.borderColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        border.frame = CGRect(x: 0,
                              y: desc.frame.size.height - width,
                              width: desc.frame.size.width,
                              height: desc.frame.size.height)
        
        border.borderWidth = width
        desc.layer.addSublayer(border)
        desc.layer.masksToBounds = true
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