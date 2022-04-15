//
//  CalcLogic.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/20/22.
//

import Foundation

protocol CalcLogicDelegate {
    func updateButtonClear(resetToAllClear: Bool)
}

struct CalcLogic {
    
    // MARK: - Properties
    let formatter = NumberFormatter()
    let formatterCommaSeparated = NumberFormatter()
    let maxDigits = 16
//    var isDoneEnteringDigits = true
    var expression: (n1: String, operation: String?, n2: String?) = (n1: "0", operation: nil, n2: nil)
    var delegate: CalcLogicDelegate?
    
//    var operand1String = ""
//    var operand2String = ""
//    var operand1: Double = 0
//    var operand2: Double = 0
//    var operator_: String = ""
    
    
    // MARK: - Initialization
    
    init() {
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        formatterCommaSeparated.numberStyle = .decimal
    }
    
    
    // MARK: - Functions
    
    /**
     Takes in input from a button press.
     - parameter button: the button that was pressed
     - returns: The resulting string of either the second operand, or if it's nil, the first operand.
     */
    mutating func getInput(button: CalcButton) -> String {//, to display: inout String) {
        var result = ""
        
        switch button.type {
        case .clear, .allClear:
            handleClear(allClear: button.type == .allClear)

            delegate?.updateButtonClear(resetToAllClear: true)
        case .number:
            handleNumber(numString: button.buttonLabel!)
            
            delegate?.updateButtonClear(resetToAllClear: false)
        case .decimal:
            handleDecimal()
        case .operation:
            handleOperation(operation: button.buttonLabel!)
        case .equals:
            calculate()
        default:
            print("Unknown button type: \(button.type)")
        }
                
        print(expression)
        
        result = (expression.n2 != nil ? expression.n2! : expression.n1)
        
        return result//formatterCommaSeparated.string(from: NSNumber(value: Double(result)!))!
    }
    
    private mutating func handleClear(allClear: Bool) {
        if allClear {
            clearAll()
        }
        else {
            if expression.n2 != nil {
                expression.n2 = "0"
            }
            else {
                clearAll()
            }
        }
    }
    
    private mutating func clearAll() {
        expression = (n1: "0", operation: nil, n2: nil)
    }
    
    private mutating func handleNumber(numString: String) {
        let operand: String = expression.operation == nil ? expression.n1 : expression.n2 ?? "0"

        guard operand.count < maxDigits else { return }
        
        if expression.operation != nil {
            expression.n2 = numberIsZero(expression.n2) ? numString : expression.n2! + numString
        }
        else {
            expression.n1 = numberIsZero(expression.n1) ? numString : expression.n1 + numString
        }
    }
    
    private mutating func numberIsZero(_ numString: String?) -> Bool {
        return numString == nil || numString == "0"
    }
    
    private mutating func handleDecimal() {
        if expression.operation != nil {
            if expression.n2 == nil {
                expression.n2 = "0."
            }
            else {
                if !expression.n2!.contains(".") {
                    expression.n2! += "."
                }
            }
        }
        else {
            guard !expression.n1.contains(".") else { return }
            
            expression.n1 += "."
        }
    }
    
    private mutating func handleOperation(operation: String) {
        if expression.n2 != nil {
            calculate()
        }

        expression.operation = operation
    }

    @discardableResult private mutating func calculate() -> String {
        guard let operand1: Double = Double(expression.n1),
              let n2 = expression.n2,
              let operand2: Double = Double(n2) else {
            return "nil"
        }
        
        
        var result: Double = 0

        switch expression.operation {
        case "+":
            result = operand1 + operand2
        case "-":
            result = operand1 - operand2
        case "×":
            result = operand1 * operand2
        case "÷":
            result = operand1 / operand2
        default:
            print("Unknown operation")
        }
        
        print(formatter.string(from: NSNumber(value: result))!)
        
        expression = (n1: formatter.string(from: NSNumber(value: result))!, operation: expression.operation, n2: nil)
        
        if "\(result)".count >= maxDigits {
            formatter.numberStyle = .scientific
        }
        return formatter.string(from: NSNumber(value: result))!
    }
    
}
