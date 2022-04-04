//
//  CustomButton.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/3/22.
//

import UIKit

protocol CustomButtonDelegate {
    func didTapButton(_ button: CustomButton)
}

class CustomButton: UIButton {
    let buttonAlpha: CGFloat
    let buttonPressOffset: CGFloat
    let buttonLabel: String?
    var delegate: CustomButtonDelegate?

    init(frame: CGRect, alpha: CGFloat = 1.0, buttonPressOffset: CGFloat = 2.0, buttonLabel: String? = nil) {
        self.buttonAlpha = alpha
        self.buttonPressOffset = buttonPressOffset
        self.buttonLabel = buttonLabel

        super.init(frame: frame)
                
        self.alpha = alpha
        layer.shadowOffset = CGSize(width: buttonPressOffset, height: buttonPressOffset)
        layer.shadowOpacity = 1.0
        layer.shadowColor = UIColor.darkGray.cgColor

        addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(tapDown(_:)), for: .touchDown)
        addTarget(self, action: #selector(tapRelease(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(tapRelease(_:)), for: .touchDragExit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
        
    
    // MARK: - Button Press Actions
    
    @objc func didTapButton(_ sender: CustomButton) {
        delegate?.didTapButton(sender)
    }
    
    @objc func tapDown(_ sender: UIButton) {
        frame.origin = CGPoint(x: frame.origin.x + buttonPressOffset, y: frame.origin.y + buttonPressOffset)
        alpha = buttonAlpha * 0.75
        layer.shadowOpacity = 0.0
        
        AudioPlayer.playSound(filename: "buttonTap")
        K.addHapticFeedback(withStyle: .soft)
    }

    @objc func tapRelease(_ sender: CustomButton) {
        UIView.animate(withDuration: 0.35, delay: 0, options: .allowUserInteraction, animations: { [unowned self] in
            frame.origin = CGPoint(x: frame.origin.x - buttonPressOffset, y: frame.origin.y - buttonPressOffset)
            alpha = buttonAlpha
            layer.shadowOpacity = 1.0
        }, completion: nil)
    }
}
