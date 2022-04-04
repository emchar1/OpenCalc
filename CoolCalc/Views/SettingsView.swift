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
    func didSetExpanded(_ expanded: Bool)
}

/**
 Presents a color wheel dial that allows you to change the calculator buttons using the selected color.
 */
class SettingsView: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    var delegate: SettingsViewDelegate?

    private var lightSwitch: LightButton!
    private var dialBoundsInner: UIView!
    private var dialBoundsOuter: UIView!

    private var expanded = false {
        didSet {
            lightSwitch.alpha = expanded ? 1.0 : 0.0
            
            delegate?.didSetExpanded(expanded)
        }
    }

    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawDial()
        
        let panGesture = ImmediatePanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isExpanded() -> Bool {
        return expanded
    }
    
    func expand(_ expanded: Bool) {
        self.expanded = expanded
    }
    
    func toggleExpanded() {
        expanded = !expanded
    }
    
    private func drawDial() {
        let pathWidth: CGFloat = frame.width * 0.28
        let gradientFactor: CGFloat = 0.2
        let gradientAlpha: CGFloat = 1.0
        
        
        //Add the gradient dial
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                                      radius: (frame.width - pathWidth) / 2,
                                      startAngle: 0,
                                      endAngle: CGFloat(Double.pi * 2),
                                      clockwise: true)
        
        let circleLayerTrack = CAShapeLayer()
        circleLayerTrack.path = circlePath.cgPath
        circleLayerTrack.fillColor = UIColor.clear.cgColor
        circleLayerTrack.strokeColor = UIColor.cyan.cgColor
        circleLayerTrack.lineWidth = pathWidth
        circleLayerTrack.lineCap = .round
        circleLayerTrack.strokeEnd = 1.0
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.colors = [UIColor(red: 1.0 - gradientFactor, green: 0.0, blue: 0.0, alpha: gradientAlpha).cgColor, //red
                                UIColor(red: 1.0 - gradientFactor, green: 0.5 - gradientFactor / 2, blue: 0.0, alpha: gradientAlpha).cgColor, //orange
                                UIColor(red: 1.0 - gradientFactor * 1.25, green: 1.0 - gradientFactor * 1.25, blue: 0.0, alpha: gradientAlpha).cgColor, //yellow
                                UIColor(red: 0.0, green: 1.0 - gradientFactor, blue: 0.0, alpha: gradientAlpha).cgColor, //green
                                UIColor(red: 0.0, green: 0.0, blue: 1.0 - gradientFactor / 4, alpha: gradientAlpha).cgColor, //blue
                                UIColor(red: 0.5 - gradientFactor / 4, green: 0.0, blue: 0.5 - gradientFactor / 4, alpha: gradientAlpha).cgColor, //purple
                                UIColor(red: 1.0 - gradientFactor, green: 0.0, blue: 0.0, alpha: gradientAlpha).cgColor] //red
        gradientLayer.frame = bounds
        gradientLayer.type = .conic
        gradientLayer.mask = circleLayerTrack
        
        layer.addSublayer(gradientLayer)
        
        
        // FIXME: - Convert this to a LightButton, but all the taps don't work!
//        lightSwitch = UIView()
//        lightSwitch.frame = CGRect(x: frame.width / 2 - pathWidth / 2, y: frame.height / 2 - pathWidth / 2, width: pathWidth, height: pathWidth)
//        lightSwitch.bounds = lightSwitch.frame
//        lightSwitch.backgroundColor = K.lightOn ? .black : .white
//        lightSwitch.layer.cornerRadius = lightSwitch.frame.width / 2
//        lightSwitch.layer.shadowOffset = CGSize(width: lightSwitchOffset, height: lightSwitchOffset)
//        lightSwitch.layer.shadowColor = UIColor.darkGray.cgColor
//        lightSwitch.layer.shadowOpacity = 1.0
//        lightSwitch.alpha = expanded ? 1.0 : 0.0
//        lightSwitchImage = UIImageView(image: UIImage(systemName: K.lightOn ? "lightbulb" : "lightbulb.slash"))
//        lightSwitchImage.tintColor = K.lightOn ? .white : .black
//        lightSwitchImage.frame = CGRect(x: lightSwitch.frame.origin.x + 6, y: lightSwitch.frame.origin.y + 6, width: lightSwitch.frame.width - 12, height: lightSwitch.frame.height - 12)
//        lightSwitch.addSubview(lightSwitchImage)
        
        lightSwitch = LightButton(frame: CGRect(x: frame.width / 2 - pathWidth / 2, y: frame.height / 2 - pathWidth / 2, width: pathWidth, height: pathWidth),
                                  buttonAlpha: expanded ? 1.0 : 0.0,
                                  buttonBackgroundColor: K.lightOn ? .black : .white,
                                  buttonTintColor: K.lightOn ? .white : .black)
        lightSwitch.updateCornerRadius(with: lightSwitch.frame.width / 2)
        
        
        addSubview(lightSwitch)
        
        
        //Add the dial bounds
        dialBoundsInner = UIView()
        dialBoundsInner.frame = CGRect(x: pathWidth - 2, y: pathWidth - 2, width: frame.width - (pathWidth - 2) * 2, height: frame.height - (pathWidth - 2) * 2)
        dialBoundsInner.bounds = dialBoundsInner.frame
        dialBoundsInner.layer.cornerRadius = dialBoundsInner.frame.width / 2
        dialBoundsInner.clipsToBounds = true
        addSubview(dialBoundsInner)
        
        dialBoundsOuter = UIView()
        dialBoundsOuter.frame = CGRect(x: 1, y: 1, width: frame.width - 2, height: frame.height - 2)
        dialBoundsOuter.bounds = dialBoundsOuter.frame
        dialBoundsOuter.layer.cornerRadius = dialBoundsOuter.frame.width / 2
        dialBoundsOuter.clipsToBounds = true
        addSubview(dialBoundsOuter)
    }
    
    
    // MARK: - Gesture Recognizers
    
    @objc func didPan(_ sender: ImmediatePanGestureRecognizer) {
        let location = sender.location(in: self)
        
        //Make sure can only pan within the gradient view bounds
        guard locationInCircleView(point: location, in: dialBoundsOuter.bounds) && !locationInCircleView(point: location, in: dialBoundsInner.bounds) && expanded else {
            return
        }
                

        delegate?.didChangeColor(getColorFromPoint(location))

        if sender.state == .ended {
            K.addHapticFeedback(withStyle: .light)
            delegate?.didSelectColor(getColorFromPoint(location))
        }
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        
        if expanded {
            guard locationInCircleView(point: location, in: lightSwitch.bounds) else { return }
            
            K.lightOn = !K.lightOn
            animateButtonPress()
            delegate?.didFlipSwitch(K.lightOn)
        }
        else {
            expanded = true
        }
    }
    
    /**
     Animates the light switch being pressed down.
     */
    private func animateButtonPress() {
        let lightSwitchOffset: CGFloat = 2.0

        lightSwitch.layer.shadowOpacity = 0.0
        lightSwitch.frame.origin = CGPoint(x: lightSwitch.frame.origin.x + lightSwitchOffset, y: lightSwitch.frame.origin.y + lightSwitchOffset)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            lightSwitch.backgroundColor = K.lightOn ? .black : .white
            lightSwitch.layer.shadowOpacity = 1.0
            lightSwitch.frame.origin = CGPoint(x: lightSwitch.frame.origin.x - lightSwitchOffset, y: lightSwitch.frame.origin.y - lightSwitchOffset)

            lightSwitch.tintColor = K.lightOn ? .white : .black
            lightSwitch.setImage(UIImage(systemName: K.lightOn ? "lightbulb" : "lightbulb.slash"), for: .normal)
        }, completion: nil)
        
        K.addHapticFeedback(withStyle: .light)
    }
    
    func locationInCircleView(point: CGPoint, in bounds: CGRect) -> Bool {
        let relativeCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let absoluteCenter = CGPoint(x: bounds.origin.x + relativeCenter.x, y: bounds.origin.y + relativeCenter.x)
        let radiusTapped = sqrt(pow(point.x - absoluteCenter.x, 2) + pow(point.y - absoluteCenter.y, 2))
        
        if radiusTapped < relativeCenter.x || radiusTapped < relativeCenter.y {
            return true
        }
        
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}