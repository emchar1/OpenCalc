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
    let model: CalcButtonModel
    var delegate: CalcButtonDelegate?

    var originalBackgroundColor: UIColor!
    
    init(frame: CGRect = .zero, label: String) {
        model = CalcButtonModel(value: label)

        super.init(frame: frame)
        
        setTitle(label, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIDevice.current.orientation != .portrait ? K.buttonFontTall : K.buttonFontWide
        backgroundColor = .secondarySystemBackground
        alpha = 0.65
        layer.cornerRadius = 12
        clipsToBounds = true

        originalBackgroundColor = backgroundColor

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
        UIView.animate(withDuration: 0.25, delay: 0, options: .allowUserInteraction, animations: {
            self.backgroundColor = self.originalBackgroundColor
        }, completion: nil)
    }
    
    @objc func tapDown(_ sender: UIButton) {
        let touchColor: CGFloat = 0.85
        
        originalBackgroundColor = backgroundColor
        
        backgroundColor = K.lightOn ? UIColor(red: touchColor, green: touchColor, blue: touchColor, alpha: 1.0) : UIColor(red: 1.0 - touchColor, green: 1.0 - touchColor, blue: 1.0 - touchColor, alpha: 1.0)
    }
}
