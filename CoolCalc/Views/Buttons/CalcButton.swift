//
//  CalcButton.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/20/22.
//

import UIKit

class CalcButton: CustomButton {
    let buttonFontTall = UIFont(name: "AppleSDGothicNeo-Bold", size: 36)
    let buttonFontWide = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)

    var model: CalcButtonModel!
    var currentFont: UIFont!
    
    // MARK: - Initialization

    init(buttonLabel: String) {
        super.init(frame: .zero,
                   buttonAlpha: 0.65,
                   buttonPressOffset: 5.0,
                   buttonCornerRadius: 20,
                   buttonLabel: buttonLabel,
                   buttonTapSound: "buttonTap",
                   buttonImage: nil)
                
        model = CalcButtonModel(value: buttonLabel)
        updateAttributesWithOrientationChange()
        
        setTitle(buttonLabel, for: .normal)
        titleLabel!.font = currentFont
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    func updateAttributesWithOrientationChange() -> Bool {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            currentFont = buttonFontTall
            layer.cornerRadius = buttonCornerRadius
        }
        else {
            currentFont = buttonFontWide
            layer.cornerRadius = buttonCornerRadius / 2
        }
        
        titleLabel!.font = currentFont
        
        return true
    }

}
