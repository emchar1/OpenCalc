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
    enum CalcErrors: Error {
        case overflow, tooManyDigits, hasDecimal, unknownOperation, unknownButtonType
    }
    
    let formatter = NumberFormatter()
    let formatterCommaSeparated = NumberFormatter()
    let maxDigits = 9
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
        formatter.maximumFractionDigits = maxDigits
        formatterCommaSeparated.minimumFractionDigits = 0
        formatterCommaSeparated.maximumFractionDigits = maxDigits
        formatterCommaSeparated.numberStyle = .decimal
    }
    
    
    // MARK: - Functions
    
    /**
     Takes in input from a button press.
     - parameter button: the button that was pressed
     - returns: The resulting string of either the second operand, or if it's nil, the first operand.
     */
    mutating func getInput(button: CalcButton) throws -> String {//, to display: inout String) {
        switch button.type {
        case .clear, .allClear:
            handleClear(allClear: button.type == .allClear)
            delegate?.updateButtonClear(resetToAllClear: true)
        case .number:
            do {
                try handleNumber(numString: button.buttonLabel!)
                delegate?.updateButtonClear(resetToAllClear: false)
            }
            catch {
                print("Number entry error: \(error)")
            }
        case .decimal:
            try? handleDecimal()
        case .sign:
            try? handleSign()
        case .operation:
            try? handleOperation(operation: button.buttonLabel!)
        case .equals:
            do {
                try calculate()
            }
            catch {
                print("Calculate error: \(error)")
            }
        default:
            throw CalcErrors.unknownButtonType
        }
                
        print(expression)
        
        let result = (expression.n2 != nil ? expression.n2! : expression.n1)
        formatterCommaSeparated.numberStyle = result.count > maxDigits ? .scientific : .decimal
        
        if result.count > maxDigits {
            return Double(result) == nil ? "Error" : formatterCommaSeparated.string(from: NSNumber(value: Double(result)!))!
        }
        else {
            return Double(result) == nil ? "Error" : result
        }
    }
    
    private func n1IsError() -> Bool {
        return Double(expression.n1) == nil
    }
    
    private mutating func handleClear(allClear: Bool) {
        if allClear {
            clearAll()
        }
        else {
            if !n1IsError() && expression.n2 != nil {
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
    
    private mutating func handleNumber(numString: String) throws {
        guard !n1IsError() else { throw CalcErrors.overflow }
        guard (expression.operation == nil ? expression.n1 : expression.n2 ?? "0").count < maxDigits else { throw CalcErrors.tooManyDigits }
        
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
    
    private mutating func handleDecimal() throws {
        guard !n1IsError() else { throw CalcErrors.overflow }
        
        let result = (expression.n2 != nil ? expression.n2! : expression.n1)
        guard !result.contains(".") else { throw CalcErrors.hasDecimal }
        

        if expression.operation != nil {
            if let n2 = expression.n2 {
                expression.n2 = n2 + "."
            }
            else {
                expression.n2 = "0."
            }
        }
        else {
            expression.n1 += "."
        }
    }
    
    private mutating func handleSign() throws {
        guard !n1IsError() else { throw CalcErrors.overflow }

        let operand: Double = expression.operation == nil ? Double(expression.n1)! : Double(expression.n2 ?? "0")!
        let operandStringWithSignChange = operand == 0 ? "0" : formatterCommaSeparated.string(from: NSNumber(value: -operand))!
        
        if expression.operation == nil {
            expression.n1 = operandStringWithSignChange
        }
        else {
            expression.n2 = operandStringWithSignChange
        }
    }
    
    private mutating func handleOperation(operation: String) throws {
        guard !n1IsError() else { throw CalcErrors.overflow }

        if expression.n2 != nil {
            do {
                try calculate()
            }
            catch {
                print("Calculate error: \(error)")
            }
        }

        expression.operation = operation
    }

    @discardableResult private mutating func calculate() throws -> String {
        guard !n1IsError() else { throw CalcErrors.overflow }

        let operand1: Double = Double(expression.n1)!
        // FIXME: - operand2 should be operand1 if 2 is nil?
        let operand2: Double = expression.n2 == nil ? operand1 : Double(expression.n2!)!
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
            throw CalcErrors.unknownOperation
        }
        
        expression = (n1: formatter.string(from: NSNumber(value: result))!, operation: expression.operation, n2: nil)
        
        return formatter.string(from: NSNumber(value: result))!
    }
    
}
