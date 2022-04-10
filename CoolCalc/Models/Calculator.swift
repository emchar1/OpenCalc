//
//  Calculator.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/20/22.
//

import Foundation

struct Calculator {
    
    // MARK: - Properties
    enum Operator: String {
        case add = "+", subtract = "-", multiply = "×", divide = "÷"
    }

    var operand1String = ""
    var operand2String = ""
    var operand1: Double = 0
    var operand2: Double = 0
    var operator_: String = ""
    
    
    // MARK: - Functions
    
    mutating func getInput(button: CalcButton) -> String {
        switch button.type {
        case .clear:
            operand1String = ""
        case .number:
            operand1String += button.buttonLabel!
        default:
            print(button.type)
        }
        
        return operand1String
    }

    func calculate() {
        
    }
}
