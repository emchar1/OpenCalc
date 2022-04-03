//
//  ImmediatePanGestureRecognizer.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/2/22.
//

import UIKit

class ImmediatePanGestureRecognizer: UIPanGestureRecognizer {
    /**
     Detects pan gesture on touch began vs touch end.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
}
