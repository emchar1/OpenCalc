//
//  MuteButton.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/3/22.
//

import UIKit

class MuteButton: UIButton {
    let shadowOffset: CGFloat = 2.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setImage(UIImage(systemName: K.muteOn ? "speaker.slash" : "speaker.wave.2"), for: .normal)
        backgroundColor = K.lightOn ? .black : .white
        setTitleColor(K.lightOn ? .white : .black, for: .normal)
        layer.cornerRadius = frame.width / 2
        layer.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        layer.shadowOpacity = 1.0
        layer.shadowColor = UIColor.darkGray.cgColor

        addTarget(self, action: #selector(didPress(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPress(_ sender: UIButton) {
        K.muteOn = !K.muteOn
        
        
        
        UIView.animate(withDuration: 0.5) {
            
        }
    }
}
