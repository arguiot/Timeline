//
//  VC2Image.swift
//  Timeline
//
//  Created by Arthur Guiot on 24/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
