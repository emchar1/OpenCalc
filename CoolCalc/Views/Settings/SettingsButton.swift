//
//  SettingsButton.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/3/22.
//

import UIKit

class SettingsButton: CustomButton {
    init(frame: CGRect) {
        super.init(frame: frame,
                   buttonAlpha: 1.0,
                   buttonPressOffset: 2.0,
                   buttonCornerRadius: 0.0,
                   buttonLabel: nil,
                   buttonTapSound: nil,
                   buttonImage: nil,
                   animateDuration: 0.1)

        layer.cornerRadius = frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
