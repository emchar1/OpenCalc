//
//  K.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/3/22.
//

import UIKit
import CoreHaptics

struct K {
    static let font1Main = "AppleSDGothicNeo-Regular"
    static let font1Bold = "AppleSDGothicNeo-Bold"
    static let font2Main = "Menlo-Regular"
    static let font2Bold = "Menlo-Bold"
    static let font3Main = "AmericanTypewriter"
    static let font3Bold = "AmericanTypewriter-Bold"

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
        
    static func getSafeAreaInsets() -> (top: CGFloat, leading: CGFloat, trailing: CGFloat, bottom: CGFloat) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return (90, 0, 0, 0) }
        
        let safeAreaInsets = windowScene.windows[0].safeAreaInsets
        
        return (safeAreaInsets.top, safeAreaInsets.left, safeAreaInsets.right, safeAreaInsets.bottom)
    }
}
