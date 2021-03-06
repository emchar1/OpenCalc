//
//  Extension+UIColor.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/2/22.
//

import UIKit

extension UIColor {
    var complementary: UIColor {
        return self.withHueOffset(180 / 360)
    }

    var splitComplementary: (first: UIColor, second: UIColor) {
        return (self.withHueOffset(150 / 360), self.withHueOffset(210 / 360))
    }

    var triadic: (first: UIColor, second: UIColor) {
        return (self.withHueOffset(120 / 360), self.withHueOffset(240 / 360))
    }
    
    var analogous: (first: UIColor, second: UIColor) {
        return (self.withHueOffset(-30 / 360), self.withHueOffset(30 / 360))
    }
    
    private var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
    private func withHueOffset(_ offset: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        let offsetColor = UIColor(hue: fmod(hue + offset, 1), saturation: saturation, brightness: brightness, alpha: alpha)
        
        print("color: R:\(components.red), G:\(components.green), B:\(components.blue), A:\(components.alpha)")
        print("offsetColor: R:\(offsetColor.components.red), G:\(offsetColor.components.green), B:\(offsetColor.components.blue), A:\(offsetColor.components.alpha)")

        return offsetColor
    }
    
//    func getComplementary() -> UIColor {
//        var red: CGFloat = 0.0
//        var green: CGFloat = 0.0
//        var blue: CGFloat = 0.0
//        var alpha: CGFloat = 0.0
//        
//        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//
//        return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
//    }
}
