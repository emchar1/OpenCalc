//
//  CalcLogic.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/20/22.
//

import Foundation

struct CalcLogic {
    
    // MARK: - Properties
    enum Operator: String {
        case add = "+", subtract = "-", multiply = "×", divide = "÷"
    }

    let formatter = NumberFormatter()
    var isDoneEnteringDigits = true
    var expression: (n1: String, operation: String?, n2: String?) = (n1: "0", operation: nil, n2: nil)
    
    var operand1String = ""
    var operand2String = ""
    var operand1: Double = 0
    var operand2: Double = 0
    var operator_: String = ""
    
    
    // MARK: - Initialization
    
    init() {
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
    }
    
    
    // MARK: - Functions
    
    mutating func getInput(button: CalcButton) -> String {//, to display: inout String) {
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
