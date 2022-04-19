//
//  ColorDial.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/6/22.
//

import UIKit

protocol ColorDialDelegate {
    func didChangeColor(_ color: UIColor?)
    func didSelectColor(_ color: UIColor?)
}

/**
 Presents a color wheel dial that allows you to change the calculator buttons using the selected color.
 */
class ColorDial: UIView {
    
    // MARK: - Properties
    
    private var dialBoundsInner: UIView!
    private var dialBoundsOuter: UIView!

    var delegate: ColorDialDelegate?


    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawDial()
        
        let panGesture = ImmediatePanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    @objc private func didPan(_ sender: ImmediatePanGestureRecognizer) {
        let location = sender.location(in: self)
        
        //Make sure can only pan within the gradient view bounds
        guard locationInCircleView(point: location, in: dialBoundsOuter.bounds) && !locationInCircleView(point: location, in: dialBoundsInner.bounds) else {
            return
        }

        delegate?.didChangeColor(getColorFromPoint(location))

        if sender.state == .ended {
            Haptics.addHapticFeedback(withStyle: .light)
            delegate?.didSelectColor(getColorFromPoint(location))
        }
    }
    
    private func locationInCircleView(point: CGPoint, in bounds: CGRect) -> Bool {
        let relativeCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let absoluteCenter = CGPoint(x: bounds.origin.x + relativeCenter.x, y: bounds.origin.y + relativeCenter.x)
        let radiusTapped = sqrt(pow(point.x - absoluteCenter.x, 2) + pow(point.y - absoluteCenter.y, 2))
        
        if radiusTapped < relativeCenter.x || radiusTapped < relativeCenter.y {
            return true
        }
        
        return false
    }
}
