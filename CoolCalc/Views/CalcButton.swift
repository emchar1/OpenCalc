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
    var delegate: CalcButtonDelegate?
    let model: CalcButtonModel
    
    
    init(frame: CGRect = .zero, label: String) {
        model = CalcButtonModel(value: label)

        super.init(frame: frame)

        setTitle(label, for: .normal)
        setTitleColor(.label, for: .normal)
        backgroundColor = .secondarySystemBackground
        alpha = 0.65
        layer.cornerRadius = 12
        clipsToBounds = true

        addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
        
    @objc func didTapButton(_ sender: CalcButton) {
        print("Button pressed")
        delegate?.didTapButton(sender)
    }
}
