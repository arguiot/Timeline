//
//  Alert.swift
//  Timeline
//
//  Created by Arthur Guiot on 25/7/18.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

struct Alert {
    func alert(_ title: String, _ string: String, VC: UIViewController) {
        let alert = UIAlertController(title: title, message: string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        VC.present(alert, animated: true, completion: nil)
    }
}
