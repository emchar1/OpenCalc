//
//  ColorSelectorView.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/20/22.
//

//import UIKit
//
//protocol ColorSelectorViewDelegate {
//    func didSelectColor(_ color: UIColor)
//}
//
//class ColorSelectorView: UIView {
//    var delegate: ColorSelectorViewDelegate?
//
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
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didGesture(_:)))
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didGesture(_:)))
//        addGestureRecognizer(tapGesture)
//        addGestureRecognizer(panGesture)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("Error with initialization.")
//    }
//
//
//    @objc func didGesture(_ sender: UITapGestureRecognizer) {
//        let location = sender.location(in: self)
//
//        guard location.x >= 0 && location.x < frame.width - 1 && location.y >= 0 && location.y < frame.height - 1 else { return }
//
//        delegate?.didSelectColor(getColorFromPoint(location))
//    }
//}
