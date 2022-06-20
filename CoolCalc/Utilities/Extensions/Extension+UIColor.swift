//
//  Extension+UIColor.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/2/22.
//

import UIKit

extension UIColor {
    var complementary: UIColor {
        return self.withHueOffset(offset: 180 / 360)
    }

    var splitComplementary: (left: UIColor, right: UIColor) {
        return (self.withHueOffset(offset: 150 / 360), self.withHueOffset(offset: 210 / 360))
    }

    var triadic: (left: UIColor, right: UIColor) {
        return (self.withHueOffset(offset: 120 / 360), self.withHueOffset(offset: 240 / 360))
    }
    
    var analogous: (left: UIColor, right: UIColor) {
        return (self.withHueOffset(offset: -30 / 360), self.withHueOffset(offset: 30 / 360))
    }
    
    private func withHueOffset(offset: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return UIColor(hue: fmod(hue + offset, 1), saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    func getComplementary() -> UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
    }
}
