//
//  ColorView.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/22/22.
//

import UIKit

class ImmediatePanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
}


// MARK: - ColorView

protocol ColorViewDelegate {
    func didSelectColor(_ color: UIColor)
}


/**
 Animates a circle path, used for the miles this month metric.
 */
class ColorView: UIView {
    var delegate: ColorViewDelegate?
    var circleDial: CAShapeLayer!
    var circleDialPath: UIBezierPath!
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//
//        for col in 0..<Int(frame.height) {
//            for row in 0..<Int(frame.width) {
//                let rowCG: CGFloat = CGFloat(row) * (255.0 / frame.width)
//                let colCG: CGFloat = CGFloat(col) * (255.0 / frame.height)
//                let customColor = UIColor(hue: rowCG / 255,
//                                          saturation: (255 - colCG) / 255,
//                                          brightness: (255 - colCG) / 255,
//                                          alpha: 1).cgColor
//
//                context.setLineWidth(1)
//                context.setStrokeColor(customColor)
//                context.move(to: CGPoint(x: row, y: col))
//                context.addLine(to: CGPoint(x: row + 1, y: col + 1))
//                context.strokePath()
//            }
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let circleDialWidth: CGFloat = 4
        let pathWidth: CGFloat = 22.0
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                                      radius: (frame.size.width - pathWidth) / 2 - (circleDialWidth / 2),
                                      startAngle: 0,
                                      endAngle: CGFloat(Double.pi * 2),
                                      clockwise: true)
        
        circleDialPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: pathWidth / 2 + circleDialWidth / 2),
                                          radius: pathWidth / 2 - 1,
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
        gradientLayer.colors = [UIColor.red.cgColor,
                                UIColor.orange.cgColor,
                                UIColor.yellow.cgColor,
                                UIColor.green.cgColor,
                                UIColor.blue.cgColor,
                                UIColor.purple.cgColor,
                                UIColor.red.cgColor]
        gradientLayer.frame = bounds
        gradientLayer.type = .conic
        gradientLayer.mask = circleLayerTrack
        clipsToBounds = true
        
        circleDial = CAShapeLayer()
        circleDial.path = circleDialPath.cgPath
        circleDial.fillColor = UIColor.clear.cgColor
        circleDial.strokeColor = UIColor.white.cgColor
        circleDial.lineWidth = circleDialWidth
        circleDial.lineCap = .round
        circleDial.strokeEnd = 1.0
        circleDial.backgroundColor = UIColor.green.cgColor
        
        layer.addSublayer(gradientLayer)
        layer.addSublayer(circleDial)
//        layer.addSublayer(circleLayerTrack)
        
        
        let panGesture = ImmediatePanGestureRecognizer(target: self, action: #selector(didGesture(_:)))
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didGesture(_ sender: ImmediatePanGestureRecognizer) {
        let location = sender.location(in: self)
        
        guard location.x >= 0 && location.x < frame.width - 1 && location.y >= 0 && location.y < frame.height - 1 else { return }
        
        circleDial.frame.origin = CGPoint(x: location.x - frame.size.width / 2, y: location.y - 11)
        
        delegate?.didSelectColor(getColorFromPoint(location))
    }
}
