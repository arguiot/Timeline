//
//  ParentVC.swift
//  Timeline
//
//  Created by Arthur Guiot on 26/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController?
            }
        }
        return nil
    }
}
