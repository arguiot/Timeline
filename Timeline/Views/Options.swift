//
//  Options.swift
//  Timeline
//
//  Created by Arthur Guiot on 25/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class Options: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var edit: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Options", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        done.layer.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        delete.layer.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        edit.layer.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
