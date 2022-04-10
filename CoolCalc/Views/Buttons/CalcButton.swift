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
                   buttonTapSound: "Tap1",
                   buttonImage: nil)
                
        model = CalcButtonModel(value: buttonLabel)
        updateAttributesWithOrientationChange(wideSize: buttonCornerRadius)
        
        setTitle(buttonLabel, for: .normal)
        titleLabel!.font = currentFont
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult func updateAttributesWithOrientationChange(wideSize size: CGFloat) -> Bool {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            currentFont = buttonFontTall
            layer.cornerRadius = buttonCornerRadius
        }
        else {
            currentFont = buttonFontWide
            layer.cornerRadius = size
        }
        
        titleLabel!.font = currentFont
        
        return true
    }
    
    @discardableResult func updateWithAppearanceChange(alpha: CGFloat, offset: CGFloat, wideSize: CGFloat, cornerRadius: CGFloat, duration: CGFloat, sound: String) -> Bool {
        self.buttonAlpha = alpha
        self.buttonPressOffset = offset
        self.buttonCornerRadius = cornerRadius
        self.animateDuration = duration
        self.buttonTapSound = sound
                
        self.alpha = alpha
        layer.cornerRadius = UIApplication.shared.statusBarOrientation.isPortrait ? cornerRadius : wideSize
        layer.shadowOffset = CGSize(width: offset, height: offset)

        return true
    }
}
