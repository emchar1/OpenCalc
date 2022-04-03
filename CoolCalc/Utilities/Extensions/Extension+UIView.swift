//
//  Extension+UIView.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/20/22.
//

import UIKit

extension UIView {
    /**
     Returns the color at a given point.
     - parameter point: the CGPoint where you want to find the color of the view
     - returns: the UIColor in RGBa
     */
    func getColorFromPoint(_ point: CGPoint) -> UIColor {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        var pixelData: [UInt8] = [0, 0, 0, 0]
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        context?.translateBy(x: -point.x, y: -point.y)

        if let context = context {
            self.layer.render(in: context)
        }

        let red: CGFloat = CGFloat(pixelData[0]) / 255
        let green: CGFloat = CGFloat(pixelData[1]) / 255
        let blue: CGFloat = CGFloat(pixelData[2]) / 255
        let alpha: CGFloat = CGFloat(pixelData[3]) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
