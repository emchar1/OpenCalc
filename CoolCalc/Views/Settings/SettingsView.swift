//
//  Settingsiew.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/22/22.
//


import UIKit

protocol SettingsViewDelegate {
    func didChangeColor(_ color: UIColor?)
    func didSelectColor(_ color: UIColor?)
    func didFlipSwitch(_ lightOn: Bool)
    func didHitMute(_ muteOn: Bool)
    func didSetExpanded(_ expanded: Bool)
}


class SettingsView: UIView, ColorDialDelegate, CustomButtonDelegate {
    
    // MARK: - Properties
    
    var delegate: SettingsViewDelegate?

    let buttonSize: CGFloat = 35
    var lightButton: LightButton!
    var muteButton: MuteButton!
    var colorDial: ColorDial!

    private var expanded = false {
        didSet {
            if expanded {
                colorDial.isUserInteractionEnabled = true
                lightButton.alpha = 1.0
                muteButton.alpha = 1.0
            }
            else {
                colorDial.isUserInteractionEnabled = false
                lightButton.alpha = 0.0
                muteButton.alpha = 0.0
            }
            
            delegate?.didSetExpanded(expanded)
        }
    }

    
    // MARK: - Initialization
    
    init(atOrigin origin: CGPoint, withSize size: CGFloat) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: size + buttonSize, height: size))
                
        colorDial = ColorDial(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
        colorDial.delegate = self
        colorDial.isUserInteractionEnabled = expanded
        
        lightButton = LightButton(frame: CGRect(x: frame.height / 2 - buttonSize / 2, y: frame.height / 2 - buttonSize / 2,
                                                width: buttonSize, height: buttonSize),
                                  buttonBackgroundColor: nil,
                                  buttonTintColor: nil)
        lightButton.layer.cornerRadius = lightButton.frame.height / 2
        lightButton.alpha = expanded ? 1.0 : 0.0
        lightButton.delegate = self
        
        muteButton = MuteButton(frame: CGRect(x: frame.height, y: 0, width: buttonSize, height: buttonSize),
                                buttonBackgroundColor: nil,
                                buttonTintColor: nil)
        muteButton.layer.cornerRadius = lightButton.frame.height / 2
        muteButton.alpha = expanded ? 1.0 : 0.0
        muteButton.delegate = self
        
        updateButtonVisuals()
        
        addSubview(colorDial)
        addSubview(lightButton)
        addSubview(muteButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateButtonVisuals() {
        guard lightButton != nil, muteButton != nil else { return }

        let buttonBackgroundColor: UIColor = K.lightOn ? .black : .white
        let buttonTintColor: UIColor = K.lightOn ? .white : .black
        
        lightButton.backgroundColor = buttonBackgroundColor
        lightButton.tintColor = buttonTintColor
        lightButton.setImage(UIImage(systemName: K.lightOn ? "lightbulb" : "lightbulb.slash"), for: .normal)
        
        muteButton.backgroundColor = buttonBackgroundColor
        muteButton.tintColor = buttonTintColor
        muteButton.setImage(UIImage(systemName: K.muteOn ? "speaker.slash" : "speaker.wave.2"), for: .normal)
    }
    
    
    //Public functions
    
    func isExpanded() -> Bool {
        return expanded
    }
    
    func expand(_ expanded: Bool) {
        self.expanded = expanded
    }
    
    func toggleExpanded() {
        expanded = !expanded
    }
    
    
    // MARK: - Gesture Recognizers

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        expanded = true
    }
}



// MARK: - CustomButton Delegate

extension SettingsView {
    func didTapButton(_ button: CustomButton) {
        if button is LightButton {
            K.lightOn = !K.lightOn
            updateButtonVisuals()
            delegate?.didFlipSwitch(K.lightOn)
        }
        else if button is MuteButton {
            K.muteOn = !K.muteOn
            updateButtonVisuals()
            delegate?.didHitMute(K.muteOn)
        }
    }
}


// MARK: - ColorDial Delegate

/**
 These delegate functions simply pass down the corresponding delegate functions to the parent view controller.
 */
extension SettingsView {
    func didChangeColor(_ color: UIColor?) {
        delegate?.didChangeColor(color)
    }
    
    
    func didSelectColor(_ color: UIColor?) {
        delegate?.didSelectColor(color)
    }
}
