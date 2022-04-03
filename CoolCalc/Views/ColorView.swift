//
//  ColorView.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/22/22.
//

import UIKit

protocol ColorViewDelegate {
    func didSelectColor(_ color: UIColor)
}

/**
 Presents a color wheel dial that allows you to change the calculator buttons using the selected color.
 */
class ColorView: UIView {
    
    // MARK: - Properties
    
    var delegate: ColorViewDelegate?
    
    //Dial bounds properties
    var dialBoundsInner: UIView!
    var dialBoundsOuter: UIView!
    static let defaultColor = UIColor(red: 0.8, green: 0.4, blue: 0.0, alpha: 0.9)
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawDial()
        
        let panGesture = ImmediatePanGestureRecognizer(target: self, action: #selector(didGesture(_:)))
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
    @objc func didGesture(_ sender: ImmediatePanGestureRecognizer) {
        let location = sender.location(in: self)
        
        //Make sure only panning within the gradient view bounds
        guard locationInCircleView(point: location, in: dialBoundsOuter.bounds) && !locationInCircleView(point: location, in: dialBoundsInner.bounds) else {
            return
        }
        
        
        delegate?.didSelectColor(getColorFromPoint(location))
    }
    
    func locationInCircleView(point: CGPoint, in bounds: CGRect) -> Bool {
        let circleCenter = CGPoint(x: bounds.origin.x + bounds.width / 2,
                                   y: bounds.origin.y + bounds.height / 2)
        
        //Simple math!
        let radiusTapped = sqrt(pow(point.x - circleCenter.x, 2) +
                                pow(point.y - circleCenter.y, 2))
        
        if radiusTapped < bounds.width / 2 || radiusTapped < bounds.height / 2 {
            return true
        }
        
        return false
    }
}
