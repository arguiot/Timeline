//
//  Button.swift
//  Timeline
//
//  Created by Arthur Guiot on 22/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class Button: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bg: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("button", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        bg.layer.masksToBounds = true
        bg.layer.cornerRadius = 5
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
