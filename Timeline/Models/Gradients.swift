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
        [#colorLiteral(red: 0.9254901961, green: 0.1843137255, blue: 0.2941176471, alpha: 1), #colorLiteral(red: 0, green: 0.6235294118, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.9607843137, green: 0.6862745098, blue: 0.09803921569, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.1529411765, blue: 0.06666666667, alpha: 1)],
        [#colorLiteral(red: 0.3215686275, green: 0.7607843137, blue: 0.2039215686, alpha: 1), #colorLiteral(red: 0.02352941176, green: 0.09019607843, blue: 0, alpha: 1)],
        [#colorLiteral(red: 0, green: 0.9490196078, blue: 0.9960784314, alpha: 1), #colorLiteral(red: 0.3098039216, green: 0.6745098039, blue: 0.9960784314, alpha: 1)],
        [#colorLiteral(red: 0.4, green: 0.4941176471, blue: 0.9176470588, alpha: 1), #colorLiteral(red: 0.462745098, green: 0.2941176471, blue: 0.6352941176, alpha: 1)],
        [#colorLiteral(red: 0, green: 0.6196078431, blue: 0.9921568627, alpha: 1), #colorLiteral(red: 0.1647058824, green: 0.9607843137, blue: 0.5960784314, alpha: 1)],
        [#colorLiteral(red: 0.768627451, green: 0.4431372549, blue: 0.9607843137, alpha: 1), #colorLiteral(red: 0.9803921569, green: 0.4431372549, blue: 0.8039215686, alpha: 1)],
        [#colorLiteral(red: 0.9764705882, green: 0.9411764706, blue: 0.2784313725, alpha: 1), #colorLiteral(red: 0.05882352941, green: 0.8470588235, blue: 0.3137254902, alpha: 1)]
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
