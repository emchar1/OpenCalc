//
//  LightButton.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/3/22.
//

import UIKit

class LightButton: CustomButton {
    var buttonBackgroundColor: UIColor?

    init(frame: CGRect,
         buttonAlpha: CGFloat,
         buttonBackgroundColor: UIColor?) {
                                
        super.init(frame: frame,
                   buttonAlpha: buttonAlpha,
                   buttonPressOffset: 2.0,
                   buttonCornerRadius: 0.0,
                   buttonLabel: nil,
                   buttonTapSound: nil,
                   buttonImage: UIImage(systemName: "lightbulb"))

        backgroundColor = buttonBackgroundColor
        setImage(buttonImage, for: .normal)
        tintColor = .white
        self.buttonBackgroundColor = buttonBackgroundColor
        updateBounds(with: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
