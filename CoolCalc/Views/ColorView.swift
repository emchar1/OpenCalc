//
//  ColorView.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/22/22.
//

import UIKit

protocol ColorViewDelegate {
    func didChangeColor(_ color: UIColor)
    func didSelectColor(_ color: UIColor)
    func didFlipSwitch(_ lightOn: Bool)
    func didSetExpanded(_ expanded: Bool)
}

/**
 Presents a color wheel dial that allows you to change the calculator buttons using the selected color.
 */
class ColorView: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    var delegate: ColorViewDelegate?

    private var lightSwitch: UIView!
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
        let pathWidth: CGFloat = 28.0
        let gradientFactor: CGFloat = 0.2
        let gradientAlpha: CGFloat = 0.9
        
        
        //Add the gradient dial
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                                      radius: (frame.width - pathWidth) / 2,
                                      startAngle: 0,
                                      endAngle: CGFloat(Double.pi * 2),
                                      clockwise: true)
        
        let circleLayerTrack = CAShapeLayer()
        circleLayerTrack.path = circlePath.cgPath
        circleLayerTrack.fillColor = UIColor.clear.cgColor
        circleLayerTrack.strokeColor = UIColor.systemCyan.cgColor
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
        
        lightSwitch = UIView()
        lightSwitch.frame = CGRect(x: frame.width / 2 - pathWidth / 3, y: frame.height / 2 - pathWidth / 3, width: pathWidth * 2 / 3, height: pathWidth * 2 / 3)
        lightSwitch.bounds = lightSwitch.frame
        lightSwitch.layer.cornerRadius = lightSwitch.frame.width / 2
        lightSwitch.backgroundColor = K.lightOn ? .black : .white
        lightSwitch.layer.shadowOffset = CGSize(width: 2, height: 2)
        lightSwitch.layer.shadowColor = UIColor.systemGray.cgColor
        lightSwitch.layer.shadowOpacity = 1.0
        lightSwitch.alpha = expanded ? 1.0 : 0.0
        
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
            delegate?.didSelectColor(getColorFromPoint(location))
        }
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        
        if expanded {
            guard locationInCircleView(point: location, in: lightSwitch.bounds) else { return }
            
            K.lightOn = !K.lightOn
            
            lightSwitch.layer.shadowOpacity = 0.0
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.lightSwitch.backgroundColor = K.lightOn ? .black : .white
                self.lightSwitch.layer.shadowOpacity = 1.0
            }, completion: nil)
            
            delegate?.didFlipSwitch(K.lightOn)
        }
        else {
            expanded = true
        }
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
}


extension ColorView {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
