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
    private enum CalcErrors: Error {
        case overflow, tooManyDigits, alreadyHasDecimal, unknownOperation, unknownButtonType
    }
    
    private let formatter = NumberFormatter()
    private var maxDigits = 9
    
    private var repeatOperand = "0"
    private var expression: (n1: String, operation: String?, n2: String?) = (n1: "0", operation: nil, n2: nil)
    private var nonNilOperand: String {
        expression.n2 ?? expression.n1
    }
    
    var delegate: CalcLogicDelegate?
    
    
    // MARK: - Initialization
    
    init() {
        formatter.minimumFractionDigits = 0
        updateMaxDigits(isPortrait: true)
    }
    
    
    // MARK: - Functions
    
    /**
     Updates maxDigits based on device orientation.
     - parameter isPortrait: `true` if device is in portrait orientation
     */
    mutating func updateMaxDigits(isPortrait: Bool) {
        let digitsPortrait = 9
        let digitsNotPortrait = 15

        maxDigits = isPortrait ? digitsPortrait : digitsNotPortrait
        formatter.maximumFractionDigits = maxDigits
    }
    
    /**
     Takes in input from a button press.
     - parameter button: the button that was pressed
     - throws: `CalcErrors.unknownButtonType
     */
    mutating func getInput(button: CalcButton) throws {
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
        case .percent:
            try? handlePercent()
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
    }
    
    /**
     Returns a formatted version of the current (non-nil) operand.
     - returns: a formatted version of the current (non-nil) operand.
     */
    func getOperandFormatted() -> String {
        formatter.numberStyle = nonNilOperand.count > maxDigits ? .scientific : .decimal
        
        if Double(nonNilOperand) == nil {
            return nonNilOperand
        }
        else {
            if let decimalPlace = nonNilOperand.firstIndex(of: "."), formatter.numberStyle != .scientific {
                return (formatter.string(from: NSNumber(value: Double(String(nonNilOperand.prefix(upTo: decimalPlace))) ?? -9999)) ?? "Unknown") + String(nonNilOperand.suffix(from: decimalPlace))
            }
            else {
                return formatter.string(from: NSNumber(value: Double(nonNilOperand)!)) ?? "Unknown"
            }
        }
    }
    
    
    // MARK: - Helper Functions
    
    /**
     Checks if expression.n1 is an error, i.e. overflow.
     - returns: `true` if n1 is an error
     */
    private func n1IsError() -> Bool {
        return Double(expression.n1) == nil
    }
    
    /**
     Handles clearing of the display.
     - parameter allClear: determines whether to clear just the last entry or all entries.
     */
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
    
    /**
     Helper function to clear all input entries
     */
    private mutating func clearAll() {
        expression = (n1: "0", operation: nil, n2: nil)
    }
    
    /**
     Handles input of a number button press.
     - parameter numString: the button number pressed
     - throws: `CalcErrors.overflow`, `CalcErrors.tooManyDigits`
     */
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
    
    /**
     Helper function that calclulates if the numString inputted is zero.
     - parameter numString: the number as a string being compared
     - returns: `true` if number is zero, duh!
     */
    private mutating func numberIsZero(_ numString: String?) -> Bool {
        return numString == nil || numString == "0"
    }
    
    private mutating func handleDecimal() throws {
        guard !n1IsError() else { throw CalcErrors.overflow }
        guard !nonNilOperand.contains(".") else { throw CalcErrors.alreadyHasDecimal }
        

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
        let operandStringWithSignChange = operand == 0 ? "0" : formatter.string(from: NSNumber(value: -operand))!.replacingOccurrences(of: ",", with: "")
        
        if expression.operation == nil {
            expression.n1 = operandStringWithSignChange
        }
        else {
            expression.n2 = operandStringWithSignChange
        }
    }
    
    private mutating func handlePercent() throws {
        guard !n1IsError() else { throw CalcErrors.overflow }
        
        let percentage: Double = (expression.operation == nil ? Double(expression.n1)! : Double(expression.n2 ?? "0")!) / Double(100.0)
        let percentageString = formatter.string(from: NSNumber(value: percentage))!.replacingOccurrences(of: ",", with: "")
        
        if expression.operation == nil {
            expression.n1 = percentageString
        }
        else {
            expression.n2 = percentageString
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
        repeatOperand = nonNilOperand
    }

    private mutating func calculate() throws {
        guard !n1IsError() else { throw CalcErrors.overflow }
        
        let operand1: Double = Double(expression.n1)!
        let operand2: Double = expression.n2 == nil ? (Double(repeatOperand) ?? -9999) : Double(expression.n2!)!
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
        
        formatter.numberStyle = .decimal
        expression = (n1: (formatter.string(from: NSNumber(value: result)) ?? "Unknown").replacingOccurrences(of: ",", with: ""),
                      operation: expression.operation,
                      n2: nil)
    }
    
}
