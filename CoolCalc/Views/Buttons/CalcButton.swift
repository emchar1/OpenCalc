//
//  CalcButton.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/20/22.
//

import UIKit

class CalcButton: CustomButton {
    
    // MARK: - Properties
    
    let buttonFontTall = UIFont(name: "AppleSDGothicNeo-Bold", size: 36)
    let buttonFontWide = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
    var currentFont: UIFont!

    enum ButtonType {
        case number, operation, equals, clear, allClear, sign, decimal, percent, unknown
    }

    var type: ButtonType {
        var type: ButtonType = .number
        
        switch buttonLabel {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            type = .number
        case "+", "-", "×", "÷":
            type = .operation
        case "=":
            type = .equals
        case ".":
            type = .decimal
        case "%":
            type = .percent
        case "+/-":
            type = .sign
        case "C":
            type = .clear
        case "AC":
            type = .allClear
        default:
            type = .unknown
        }
        
        return type
    }

    
    // MARK: - Initialization

    init(buttonLabel: String) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let cornerRadius: CGFloat = windowScene != nil && windowScene!.interfaceOrientation.isPortrait ? 20 : 10
        
        super.init(frame: .zero,
                   buttonAlpha: 0.65,
                   buttonPressOffset: 5.0,
                   buttonCornerRadius: cornerRadius,
                   buttonLabel: buttonLabel,
                   buttonTapSound: "Tap1",
                   buttonImage: nil)
                
        updateAttributesWithOrientationChange(cornerRadiusForLandscape: buttonCornerRadius)
        
        setTitle(buttonLabel, for: .normal)
        titleLabel!.font = currentFont
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Sets the font and cornerRadius based on device orientation.
     - parameter cornerRadius: the cornerRadius that should be set if the device is in landscape mode
     - returns: `true` if cornerRadius and font were updated
     */
    @discardableResult func updateAttributesWithOrientationChange(cornerRadiusForLandscape cornerRadius: CGFloat) -> Bool {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return false }
                
        if windowScene.interfaceOrientation.isPortrait {
            currentFont = buttonFontTall
            layer.cornerRadius = buttonCornerRadius
        }
        else {
            currentFont = traitCollection.horizontalSizeClass == .compact ? buttonFontWide : buttonFontTall
            layer.cornerRadius = cornerRadius
        }
        
        titleLabel!.font = currentFont
        
        return true
    }
    
    /**
     Updates various button properties based on various input parameters.
     - parameters:
        - alpha: the alpha component
        - offset: the offset used for drop shadow
        - wideSize: the corner radius for landscape mode
        - cornerRadius: corner radius for portrait mode
        - duration: the duration for button press spring back
        - sound: tap sound to play
     - returns: `true` if all of the properties have been set
     */
    @discardableResult func updateWithAppearanceChange(alpha: CGFloat, offset: CGFloat, wideSize: CGFloat, cornerRadius: CGFloat, duration: CGFloat, sound: String) -> Bool {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return false }
        
        self.buttonAlpha = alpha
        self.buttonPressOffset = offset
        self.buttonCornerRadius = cornerRadius
        self.animateDuration = duration
        self.buttonTapSound = sound
                
        self.alpha = alpha
        layer.cornerRadius = windowScene.interfaceOrientation.isPortrait ? cornerRadius : wideSize
        layer.shadowOffset = CGSize(width: offset, height: offset)
        
        return true
    }
    
    /**
     Overrides the tapDown function in CustomButton so that it can add a stronger haptic feedback for the "AC" button (to differentiate the feel from the "C" button).
     */
    override func tapDown(_ sender: CustomButton) {
        super.tapDown(sender)
        
        if type == .allClear {
            Haptics.executeHapticPattern()
        }
    }
}
