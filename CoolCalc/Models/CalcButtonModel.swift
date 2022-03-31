//
//  CalcButtonModel.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/20/22.
//

import Foundation

struct CalcButtonModel {
    enum ButtonType {
        case number, operation, clear, sign, decimal
    }

    let value: String
    
    var type: ButtonType {
        var type: ButtonType = .number
        
        switch value {
        case "+", "-", "×", "÷":
            type = .operation
        case ".":
            type = .decimal
        case "+/-":
            type = .sign
        case "AC":
            type = .clear
        default:
            type = .number
        }
        
        return type
    }
}
