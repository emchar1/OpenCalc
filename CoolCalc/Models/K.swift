//
//  K.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/3/22.
//

import UIKit

struct K {
    static let defaultColor = UIColor(red: 0.8, green: 0.4, blue: 0.0, alpha: 0.9)
    static let userDefaults_color = "coolCalcColor"
    static let userDefaults_light = "coolCalcLight"
    
    static var lightOn: Bool = {
        if let lightOn = UserDefaults.standard.object(forKey: K.userDefaults_light) as? Bool {
            return lightOn
        }
        
        return false
    }()
    
    static var savedColor: UIColor {
        get {
            if let savedColor = UserDefaults.standard.color(forKey: K.userDefaults_color) {
                return savedColor
            }
            
            return UIColor(red: 0.8, green: 0.4, blue: 0.0, alpha: 1.0)
        }
    }
}
