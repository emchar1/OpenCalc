//
//  Calculator.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/20/22.
//

import Foundation

struct Calculator {
    enum Operator: String {
        case add = "+", subtract = "-", multiply = "×", divide = "÷"
    }

    var operand1: Double = 0
    var operand2: Double = 0
    var operator_: String = ""

}
