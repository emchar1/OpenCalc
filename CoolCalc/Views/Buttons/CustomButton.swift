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
    
    // MARK: - Properties
    
    var buttonFrame: CGRect //Need this to preserve OG frame during tapRelease bug
    let buttonAlpha: CGFloat
    let buttonPressOffset: CGFloat
    var buttonCornerRadius: CGFloat
    let buttonLabel: String?
    let buttonTapSound: String?
    var buttonImage: UIImage?
    let animateDuration: TimeInterval
    var delegate: CustomButtonDelegate?
    
    
    // MARK: - Initialization

    init(frame: CGRect = .zero,
         buttonAlpha: CGFloat = 1.0,
         buttonPressOffset: CGFloat = 2.0,
         buttonCornerRadius: CGFloat = 0.0,
         buttonLabel: String? = nil,
         buttonTapSound: String? = nil,
         buttonImage: UIImage? = nil,
         animateDuration: TimeInterval = 0.25) {
        
        self.buttonFrame = frame
        self.buttonAlpha = buttonAlpha
        self.buttonPressOffset = buttonPressOffset
        self.buttonCornerRadius = buttonCornerRadius
        self.buttonLabel = buttonLabel
        self.buttonTapSound = buttonTapSound
        self.buttonImage = buttonImage
        self.animateDuration = animateDuration

        super.init(frame: frame)
                
        alpha = buttonAlpha
        layer.cornerRadius = buttonCornerRadius
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: buttonPressOffset, height: buttonPressOffset)
        layer.shadowOpacity = 1.0

        addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(tapDown(_:)), for: .touchDown)
        addTarget(self, action: #selector(tapRelease(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(tapRelease(_:)), for: .touchDragExit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    
    // MARK: - Update Properties
    
    func updateBounds(with bounds: CGRect) {
        self.bounds = bounds
    }
    
    func updateFont(with font: UIFont?) {
        titleLabel?.font = font
    }
    
    func updateBackgroundColor(with color: UIColor?) {
        backgroundColor = color
    }
    
    func updateTitleColor(with color: UIColor?) {
        setTitleColor(color, for: .normal)
    }
    
    func updateTintColor(with color: UIColor?) {
        tintColor = color
    }
    
    func updateCornerRadius(with cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
    }
    
    func updateImage(with image: UIImage?) {
        setImage(image, for: .normal)
    }
        
    
    // MARK: - Button Press Actions
    
    @objc func didTapButton(_ sender: CustomButton) {
        delegate?.didTapButton(sender)
    }
    
    @objc func tapDown(_ sender: CustomButton) {
        buttonFrame = frame
        frame.origin = CGPoint(x: frame.origin.x + buttonPressOffset, y: frame.origin.y + buttonPressOffset)
        alpha = buttonAlpha * 0.75
        layer.shadowOpacity = 0.0
        K.addHapticFeedback(withStyle: .soft)

        if let buttonTapSound = buttonTapSound {
            AudioPlayer.playSound(filename: buttonTapSound)
        }        
    }

    @objc func tapRelease(_ sender: CustomButton) {
        UIView.animate(withDuration: animateDuration, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: { [unowned self] in
            frame.origin = buttonFrame.origin
            alpha = buttonAlpha
            layer.shadowOpacity = 1.0
        }, completion: nil)
    }
}
