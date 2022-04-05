//
//  LightButton.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/3/22.
//

import UIKit

class LightButton: CustomButton {
    var buttonBackgroundColor: UIColor?
    var buttonTintColor: UIColor?

    init(frame: CGRect,
         buttonAlpha: CGFloat,
         buttonBackgroundColor: UIColor?,
         buttonTintColor: UIColor?) {
                                
        super.init(frame: frame,
                   buttonAlpha: buttonAlpha,
                   buttonPressOffset: 2.0,
                   buttonCornerRadius: 0.0,
                   buttonLabel: nil,
                   buttonTapSound: nil,
                   buttonImage: UIImage(systemName: K.lightOn ? "lightbulb" : "lightbulb.slash"),
                   animateDuration: 0.1)

        backgroundColor = buttonBackgroundColor
        tintColor = buttonTintColor
        setImage(buttonImage, for: .normal)
        self.buttonBackgroundColor = buttonBackgroundColor
        self.buttonTintColor = buttonTintColor
        updateBounds(with: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
