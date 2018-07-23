//
//  Gradients.swift
//  Timeline
//
//  Created by Arthur Guiot on 23/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class GradientsColor {
    var gradients: [[CGColor]] = [
        [#colorLiteral(red: 0.9019607843, green: 0.8549019608, blue: 0.8549019608, alpha: 1), #colorLiteral(red: 0.1529411765, green: 0.2509803922, blue: 0.2745098039, alpha: 1)],
        [#colorLiteral(red: 0.3647058824, green: 0.2549019608, blue: 0.3411764706, alpha: 1), #colorLiteral(red: 0.6588235294, green: 0.7921568627, blue: 0.7294117647, alpha: 1)],
        [#colorLiteral(red: 0.8666666667, green: 0.8392156863, blue: 0.9529411765, alpha: 1), #colorLiteral(red: 0.9803921569, green: 0.6745098039, blue: 0.6588235294, alpha: 1)],
        [#colorLiteral(red: 0.07058823529, green: 0.7607843137, blue: 0.9137254902, alpha: 1), #colorLiteral(red: 0.9647058824, green: 0.3098039216, blue: 0.3490196078, alpha: 1)],
        [#colorLiteral(red: 0.7254901961, green: 0.168627451, blue: 0.1529411765, alpha: 1), #colorLiteral(red: 0.08235294118, green: 0.3960784314, blue: 0.7529411765, alpha: 1)],
        [#colorLiteral(red: 0.2156862745, green: 0.231372549, blue: 0.2666666667, alpha: 1), #colorLiteral(red: 0.2588235294, green: 0.5254901961, blue: 0.9568627451, alpha: 1)],
        [#colorLiteral(red: 0.1607843137, green: 0.5019607843, blue: 0.7254901961, alpha: 1), #colorLiteral(red: 0.4274509804, green: 0.8352941176, blue: 0.9803921569, alpha: 1)],
        [#colorLiteral(red: 0.2862745098, green: 0.1960784314, blue: 0.2509803922, alpha: 1), #colorLiteral(red: 1, green: 0, blue: 0.6, alpha: 1)],
        [#colorLiteral(red: 0.9450980392, green: 0.1529411765, blue: 0.06666666667, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.6862745098, blue: 0.09803921569, alpha: 1)],
        [#colorLiteral(red: 0.06666666667, green: 0.6, blue: 0.5568627451, alpha: 1), #colorLiteral(red: 0.2196078431, green: 0.937254902, blue: 0.4901960784, alpha: 1)],
        [#colorLiteral(red: 0.1215686275, green: 0.6352941176, blue: 1, alpha: 1), #colorLiteral(red: 0.6509803922, green: 1, blue: 0.7960784314, alpha: 1)],
        [#colorLiteral(red: 0.1882352941, green: 0.9098039216, blue: 0.7490196078, alpha: 1), #colorLiteral(red: 1, green: 0.5098039216, blue: 0.2078431373, alpha: 1)]
    ]
    func randomColors() -> [CGColor] {
        let i = Int(UInt64.random(lower: 0, upper: UInt64(gradients.count)))
        return gradients[i]
    }
}
public extension UInt64 {
    public static func random(lower: UInt64 = min, upper: UInt64 = max) -> UInt64 {
        var m: UInt64
        let u = upper - lower
        var r = arc4random()
        
        if u > UInt64(Int64.max) {
            m = 1 + ~u
        } else {
            m = ((max - (u * 2)) + 1) % u
        }
        
        while r < m {
            r = arc4random()
        }
        
        return (UInt64(r) % u) + lower
    }
}
