//
//  Settingsiew.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/22/22.
//


import UIKit

protocol SettingsViewDelegate {
    func didChangeColor(_ color: UIColor?)
    func didFlipSwitch(_ lightOn: Bool)
    func didUpdateAppearance(_ appearanceButtonToggle: Int)
}


class SettingsView: UIView, ColorDialDelegate, CustomButtonDelegate {
    
    // MARK: - Properties
    
    private var colorDial: ColorDial!
    private var lightButton: SettingsButton!
    private var muteButton: SettingsButton!
    private var appearanceButton: SettingsButton!
    private var closeButton: SettingsButton!

    private let buttonSize: CGFloat = 35
    private let settingsViewShrinkFactor: CGFloat = 0.28
    private var dialSize: CGFloat
    private var settingsViewExpandedTimer: Timer?
    
    var delegate: SettingsViewDelegate?
    var appearanceButtonSelected: Int = 1 {
        didSet {
            if appearanceButtonSelected > 3 {
                appearanceButtonSelected = 1
            }
            else if appearanceButtonSelected < 1 {
                appearanceButtonSelected = 3
            }
        }
    }


    // MARK: - Initialization
    
    init(withSize size: CGFloat) {
        dialSize = size
        
        super.init(frame: CGRect(x: K.getSafeAreaInsets().leading, y: K.getSafeAreaInsets().top, width: size + buttonSize, height: size))

        setupViews()
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        colorDial = ColorDial(frame: CGRect(x: 0, y: 0, width: dialSize, height: dialSize))
        colorDial.delegate = self
        addSubview(colorDial)

        lightButton = SettingsButton(frame: CGRect(x: (dialSize - buttonSize) / 2, y: (dialSize - buttonSize) / 2, width: buttonSize, height: buttonSize))
        lightButton.delegate = self
        addSubview(lightButton)

        muteButton = SettingsButton(frame: CGRect(x: dialSize, y: 0, width: buttonSize, height: buttonSize))
        muteButton.shouldForceSound = true
        muteButton.delegate = self
        addSubview(muteButton)

        appearanceButton = SettingsButton(frame: CGRect(x: dialSize, y: dialSize - buttonSize, width: buttonSize, height: buttonSize))
        appearanceButton.delegate = self
        addSubview(appearanceButton)

        closeButton = SettingsButton(frame: CGRect(x: -2, y: -2, width: round(buttonSize * 2 / 3), height: round(buttonSize * 2 / 3)))
        closeButton.delegate = self
        addSubview(closeButton)

        updateButtonVisuals()
        animateExpanded(with: false)
    }
    
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        animateExpanded(with: true)
    }
    
    
    // MARK: - Public Functions
    
    @discardableResult func setOrigin() -> CGPoint {
        frame.origin = CGPoint(x: K.getSafeAreaInsets().leading + (dialSize * settingsViewShrinkFactor) / 2,
                               y: K.getSafeAreaInsets().top + (dialSize * settingsViewShrinkFactor) / 2)
        
        return frame.origin
    }
    
    
    // MARK: - Helper Functions
    
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
        
        switch appearanceButtonSelected {
        case 1: appearanceButton.setImage(UIImage(systemName: "1.circle.fill"), for: .normal)
        case 2: appearanceButton.setImage(UIImage(systemName: "2.circle.fill"), for: .normal)
        case 3: appearanceButton.setImage(UIImage(systemName: "3.circle.fill"), for: .normal)
        default: print("Invalid appearanceButtonToggle value")
        }
        
        closeButton.tintColor = buttonBackgroundColor
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
    }
    
    private func animateExpanded(with expanded: Bool) {
        if expanded {
            resetTimer()
            
            colorDial.isUserInteractionEnabled = true
            lightButton.isHidden = false
            muteButton.isHidden = false
            appearanceButton.isHidden = false
            closeButton.isHidden = false
        }
        else {
            colorDial.isUserInteractionEnabled = false
            lightButton.isHidden = true
            muteButton.isHidden = true
            appearanceButton.isHidden = true
            closeButton.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10) { [unowned self] in
            if expanded {
                transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                alpha = 1.0
            }
            else {
                transform = CGAffineTransform.identity.scaledBy(x: settingsViewShrinkFactor, y: settingsViewShrinkFactor)
                alpha = 0.75
            }
            
            setOrigin()
        }
    }
    
    private func resetTimer() {
        settingsViewExpandedTimer?.invalidate()
        settingsViewExpandedTimer = Timer.scheduledTimer(timeInterval: 4.0,
                                                         target: self,
                                                         selector: #selector(runTimerAction(_:)),
                                                         userInfo: nil,
                                                         repeats: false)
    }
    
    @objc private func runTimerAction(_ expanded: Bool) {
        animateExpanded(with: false)
    }
}


// MARK: - CustomButton Delegate

extension SettingsView {
    func didTapButton(_ button: CustomButton) {
        resetTimer()
                
        if button == lightButton {
            K.lightOn = !K.lightOn
            lightButton.buttonTapSound = nil//K.lightOn ? "LightOff" : "LightOn"
            updateButtonVisuals()
            delegate?.didFlipSwitch(K.lightOn)
            
            UserDefaults.standard.set(K.lightOn, forKey: K.userDefaults_light)
            print("Light is \(K.lightOn ? "ON" : "OFF") saved to UserDefaults key: \(K.userDefaults_light)")

        }
        else if button == muteButton {
            K.muteOn = !K.muteOn
            muteButton.buttonTapSound = K.muteOn ? "MuteOn" : nil
            updateButtonVisuals()
            
            UserDefaults.standard.set(K.muteOn, forKey: K.userDefaults_mute)
            print("Mute is \(K.muteOn ? "ON" : "OFF") saved to UserDefaults key: \(K.userDefaults_mute)")
        }
        else if button == appearanceButton {
            appearanceButton.buttonTapSound = nil//"AppearanceButton"
            appearanceButtonSelected += 1
            updateButtonVisuals()
            delegate?.didUpdateAppearance(appearanceButtonSelected)
        }
        else if button == closeButton {
            animateExpanded(with: false)
        }
    }
}


// MARK: - ColorDial Delegate

/**
 These delegate functions simply pass down the corresponding delegate functions to the parent view controller.
 */
extension SettingsView {
    func didChangeColor(_ color: UIColor?) {
        guard let color = color else { return }
        
        resetTimer()
        delegate?.didChangeColor(color)
    }
    
    func didSelectColor(_ color: UIColor?) {
        guard let color = color else { return }
        
        resetTimer()
        
        UserDefaults.standard.set(color, forKey: K.userDefaults_color)
        print("Color: \(color.description) saved to UserDefaults key: \(K.userDefaults_color)")
    }
}
