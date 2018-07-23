//
//  Progress.swift
//  Timeline
//
//  Created by Arthur Guiot on 23/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class Progress: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var progress: UIProgressView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Progress", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let transform = CGAffineTransform(scaleX: -1.0, y: -1.0);
        progress.transform = transform;
        
        //create gradient view the size of the progress view
        let gradientView = GradientView(frame: progress.bounds)
        
        //convert gradient view to image , flip horizontally and assign as the track image
        progress.trackImage = UIImage(view: gradientView).withHorizontallyFlippedOrientation()
        
        
        progress.progressTintColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        progress.progress = 1
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension UIImage{
    convenience init(view: UIView) {
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
}

@IBDesignable
class GradientView: UIView {
    
    private var gradientLayer = CAGradientLayer()
    private var vertical: Bool = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        
        //fill view with gradient layer
        gradientLayer.frame = self.bounds
        
        //style and insert layer if not already inserted
        if gradientLayer.superlayer == nil {
            
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
            gradientLayer.colors = GradientsColor().randomColors()
            gradientLayer.locations = [0.0, 1.0]
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
}
