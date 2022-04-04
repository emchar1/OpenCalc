//
//  CalcButton.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/20/22.
//

import UIKit

class CalcButton: CustomButton {
    var model: CalcButtonModel!
    
    
    // MARK: - Initialization

    init(buttonLabel: String?) {
        super.init(frame: .zero,
                   buttonAlpha: 0.65,
                   buttonPressOffset: 5.0,
                   buttonCornerRadius: 12,
                   buttonLabel: buttonLabel,
                   buttonTapSound: "buttonTap",
                   buttonImage: nil)
        
        
        guard let buttonLabel = buttonLabel else { return }

        model = CalcButtonModel(value: buttonLabel)

        setTitle(buttonLabel, for: .normal)
        titleLabel!.font = UIDevice.current.orientation.isLandscape ? K.buttonFontWide : K.buttonFontTall
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
