//
//  Extension+UIColor.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/2/22.
//

import UIKit

extension UIColor {
    /**
     Returns the complimentary color.
     - returns: the complimentary color
     */
    func getComplimentary() -> UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
    }
}
