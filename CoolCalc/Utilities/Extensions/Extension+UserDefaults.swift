//
//  Extension+UserDefaults.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/3/22.
//

import UIKit

extension UserDefaults {
    
    func color(forKey key: String) -> UIColor? {
        guard let colorData = data(forKey: key) else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("Color Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func set(_ value: UIColor?, forKey defaultName: String) {
        guard let color = value else { return }

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: defaultName)
        } catch let error {
            print("Error!! Color key data not saved: \(error.localizedDescription)")
        }
    }
    
}
