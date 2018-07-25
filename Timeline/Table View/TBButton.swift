//
//  Button.swift
//  Timeline
//
//  Created by Arthur Guiot on 25/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class TBButton: UIButton {
    var row: Int?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
