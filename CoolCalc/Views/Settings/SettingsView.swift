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
    func didUpdateAppearance(_ appearanceButtonToggle: Int)
}


class SettingsView: UIView, ColorDialDelegate, CustomButtonDelegate {
    
    // MARK: - Properties
    
    var colorDial: ColorDial!
    var lightButton: SettingsButton!
    var muteButton: SettingsButton!
    var appearanceButton: SettingsButton!
    var delegate: SettingsViewDelegate?

    let buttonSize: CGFloat = 35
    let settingsViewShrinkFactor: CGFloat = 0.28
    var settingsViewSize: CGFloat
    var settingsViewExpandedTimer: Timer?
    
    var appearanceButtonToggle: Int = 1 {
        didSet {
            if appearanceButtonToggle > 3 {
                appearanceButtonToggle = 1
            }
            else if appearanceButtonToggle < 1 {
                appearanceButtonToggle = 3
            }
        }
    }

    
    // MARK: - Initialization
    
    init(withSize size: CGFloat) {
        settingsViewSize = size
        
        super.init(frame: CGRect(x: K.getSafeAreaInsets().leading, y: K.getSafeAreaInsets().top, width: size + buttonSize, height: size))

        setupViews()
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        colorDial = ColorDial(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
        colorDial.delegate = self
        addSubview(colorDial)

        lightButton = SettingsButton(frame: CGRect(x: frame.height / 2 - buttonSize / 2, y: frame.height / 2 - buttonSize / 2,
                                                   width: buttonSize, height: buttonSize))
        lightButton.alpha = 0
        lightButton.delegate = self
        addSubview(lightButton)

        muteButton = SettingsButton(frame: CGRect(x: frame.height, y: 0, width: buttonSize, height: buttonSize))
        muteButton.alpha = 0
        muteButton.delegate = self
        addSubview(muteButton)

        appearanceButton = SettingsButton(frame: CGRect(x: frame.height, y: frame.height - buttonSize, width: buttonSize, height: buttonSize))
        appearanceButton.alpha = 0
        appearanceButton.delegate = self
        addSubview(appearanceButton)

        updateButtonVisuals()
        animateExpanded(with: false)
    }
    
    
    // MARK: - Helper Functions
    
    @discardableResult
    func setOrigin() -> CGPoint {
        frame.origin = CGPoint(x: K.getSafeAreaInsets().leading + (settingsViewSize * settingsViewShrinkFactor) / 2,
                               y: K.getSafeAreaInsets().top + (settingsViewSize * settingsViewShrinkFactor) / 2)
        
        return frame.origin
    }
    
    private func updateButtonVisuals() {
        guard lightButton != nil, muteButton != nil, appearanceButton != nil else { return }

        let buttonBackgroundColor: UIColor = K.lightOn ? .black : .white
        let buttonTintColor: UIColor = K.lightOn ? .white : .black
        
        lightButton.backgroundColor = buttonBackgroundColor
        lightButton.tintColor = buttonTintColor
        lightButton.setImage(UIImage(systemName: K.lightOn ? "lightbulb" : "lightbulb.slash"), for: .normal)
        
        muteButton.backgroundColor = buttonBackgroundColor
        muteButton.tintColor = buttonTintColor
        muteButton.setImage(UIImage(systemName: K.muteOn ? "speaker.slash" : "speaker.wave.2"), for: .normal)
        
        appearanceButton.backgroundColor = buttonBackgroundColor
        appearanceButton.tintColor = buttonTintColor
        
        switch appearanceButtonToggle {
        case 1: appearanceButton.setImage(UIImage(systemName: "1.circle.fill"), for: .normal)
        case 2: appearanceButton.setImage(UIImage(systemName: "2.circle.fill"), for: .normal)
        case 3: appearanceButton.setImage(UIImage(systemName: "3.circle.fill"), for: .normal)
        default: print("Invalid appearanceButtonToggle value")
        }
        
    }
    
    private func animateExpanded(with expanded: Bool) {
        if expanded {
            resetTimer()
            
            //Sub views
            colorDial.isUserInteractionEnabled = true
            lightButton.isUserInteractionEnabled = true
            muteButton.isUserInteractionEnabled = true
            appearanceButton.isUserInteractionEnabled = true
            lightButton.alpha = 1.0
            muteButton.alpha = 1.0
            appearanceButton.alpha = 1.0
        }
        else {
            //Sub views
            colorDial.isUserInteractionEnabled = false
            lightButton.isUserInteractionEnabled = false
            muteButton.isUserInteractionEnabled = false
            appearanceButton.isUserInteractionEnabled = false
            lightButton.alpha = 0.0
            muteButton.alpha = 0.0
            appearanceButton.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10) { [unowned self] in
            if expanded {
                //Settings View
                transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                alpha = 1.0
            }
            else {
                //Settings View
                transform = CGAffineTransform.identity.scaledBy(x: settingsViewShrinkFactor, y: settingsViewShrinkFactor)
                alpha = 0.75
            }
            
            setOrigin()
        }
    }
    
    private func resetTimer() {
        settingsViewExpandedTimer?.invalidate()
        settingsViewExpandedTimer = Timer.scheduledTimer(timeInterval: 3.0,
                                                           target: self,
                                                           selector: #selector(runTimerAction(_:)),
                                                           userInfo: nil,
                                                           repeats: false)
    }
    
    @objc private func runTimerAction(_ expanded: Bool) {
        animateExpanded(with: false)
    }
    
    
    
    // MARK: - Gesture Recognizers

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        animateExpanded(with: true)
    }
}



// MARK: - CustomButton Delegate

extension SettingsView {
    func didTapButton(_ button: CustomButton) {
        resetTimer()
                
        if button == lightButton {
            K.lightOn = !K.lightOn
            updateButtonVisuals()
            delegate?.didFlipSwitch(K.lightOn)
        }
        else if button == muteButton {
            K.muteOn = !K.muteOn
            updateButtonVisuals()
            delegate?.didHitMute(K.muteOn)
        }
        else if button == appearanceButton {
            appearanceButtonToggle += 1
            updateButtonVisuals()
            delegate?.didUpdateAppearance(appearanceButtonToggle)
        }
    }
}


// MARK: - ColorDial Delegate

/**
 These delegate functions simply pass down the corresponding delegate functions to the parent view controller.
 */
extension SettingsView {
    func didChangeColor(_ color: UIColor?) {
        resetTimer()
        delegate?.didChangeColor(color)
    }
    
    
    func didSelectColor(_ color: UIColor?) {
        resetTimer()
        delegate?.didSelectColor(color)
    }
}
