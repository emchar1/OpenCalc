//
//  K.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/3/22.
//

import UIKit

struct K {
    static let userDefaults_color = "coolCalcColor"
    static let userDefaults_light = "coolCalcLight"
    static let userDefaults_mute = "coolCalcMute"

    static var lightOn: Bool = {
        if let lightOn = UserDefaults.standard.object(forKey: K.userDefaults_light) as? Bool {
            return lightOn
        }
        
        return false
    }()

    static var savedColor: UIColor = {
        if let savedColor = UserDefaults.standard.color(forKey: K.userDefaults_color) {
            return savedColor
        }
        
        return UIColor(red: 0.8, green: 0.4, blue: 0.0, alpha: 1.0)
    }()

    static var muteOn: Bool = {
        if let muteOn = UserDefaults.standard.object(forKey: K.userDefaults_mute) as? Bool {
            return muteOn
        }
        
        return false
    }()
    
    /**
     Adds a haptic feedback vibration.
     - parameter style: style of feedback to produce
     */
    static func addHapticFeedback(withStyle style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard !K.muteOn else { return }
            
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func getSafeAreaInsets() -> (top: CGFloat, leading: CGFloat, trailing: CGFloat, bottom: CGFloat) {
        let window = UIApplication.shared.windows[0]
        let safeAreaInsets = window.safeAreaInsets
        
        return (safeAreaInsets.top, safeAreaInsets.left, safeAreaInsets.right, safeAreaInsets.bottom)
    }
}
