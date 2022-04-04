//
//  CalcButton.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/20/22.
//

import UIKit

protocol CalcButtonDelegate {
    func didTapButton(_ button: CalcButton)
}

class CalcButton: UIButton {
    let buttonPressOffset: CGFloat = 5.0
    let model: CalcButtonModel
    var delegate: CalcButtonDelegate?
    
    init(frame: CGRect = .zero, label: String) {
        model = CalcButtonModel(value: label)

        super.init(frame: frame)
        
        setTitle(label, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIDevice.current.orientation.isLandscape ? K.buttonFontWide : K.buttonFontTall
        backgroundColor = .secondarySystemBackground
        alpha = 0.65
        layer.cornerRadius = 12
//        clipsToBounds = true
        layer.shadowOffset = CGSize(width: buttonPressOffset, height: buttonPressOffset)
        layer.shadowOpacity = 1.0
        layer.shadowColor = UIColor.darkGray.cgColor

        addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(tapRelease(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(tapDown(_:)), for: .touchDown)
        addTarget(self, action: #selector(tapRelease(_:)), for: .touchDragExit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
        
    @objc func didTapButton(_ sender: CalcButton) {
        print("Button pressed")
        delegate?.didTapButton(sender)
    }
    
    @objc func tapRelease(_ sender: CalcButton) {
        UIView.animate(withDuration: 0.35, delay: 0, options: .allowUserInteraction, animations: { [unowned self] in
            frame.origin = CGPoint(x: frame.origin.x - buttonPressOffset, y: frame.origin.y - buttonPressOffset)
            alpha = 0.65
            layer.shadowOpacity = 1.0
        }, completion: nil)
    }
    
    @objc func tapDown(_ sender: UIButton) {
        frame.origin = CGPoint(x: frame.origin.x + buttonPressOffset, y: frame.origin.y + buttonPressOffset)
        alpha = 0.5
        layer.shadowOpacity = 0.0
        AudioPlayer.playSound(filename: "buttonTap")
        K.addHapticFeedback(withStyle: .soft)
    }
}
