//
//  CalculatorBrain.swift
//  MyCalculator
//
//  Created by Bailey Search on 05/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation

protocol CalculatorBrainDelegate {
    func clearOperatorsUI()
    func updateResultsLabel(result: String)
    func getResultsLabelVal() -> String
    func getLastButtonText() -> String
}

struct CalculatorBrain {
    
    var delegate: CalculatorBrainDelegate?
    
    var total: String = "";
    var secondNumber: String = "";
    
    var currentOperator: String? = nil
    
    mutating func calculate() -> String {
        if currentOperator != nil && total != "" && secondNumber != "" {
            switch currentOperator {
            case "+":
                total = String(Double(total)! + Double(secondNumber)!)
                break
                
            case "-":
                total = String(Double(total)! - Double(secondNumber)!)
                break
                
            case "X":
                total = String(Double(total)! * Double(secondNumber)!)
                break
                
            case "/":
                total = String(Double(total)! / Double(secondNumber)!)
                break
                
            default:
                print("ERROR")
                break
            }
            secondNumber = ""
        }
        currentOperator = nil
        
        return total;
    }
    
    mutating func clear(){
        total = "";
        secondNumber = ""
        currentOperator = nil
        delegate?.clearOperatorsUI()
        delegate?.updateResultsLabel(result: "0")
    }
    
    mutating func numButtonPressed(buttonVal: String) -> String {
        if currentOperator == nil {
            total += buttonVal
            return total
            
        // if an operator is selected - second number
        } else {
            secondNumber += buttonVal
            return secondNumber
        }
    }
    
    mutating func equalsCalculate() {
        if currentOperator != nil && total != "" && secondNumber != "" {
            let calculatedResult = calculate()
            delegate?.updateResultsLabel(result: calculatedResult)
        }
    }
    
    mutating func operationButtonPressed(buttonText: String){
        delegate?.clearOperatorsUI()
        
        if currentOperator != nil {
            total = calculate()
        }
        
        // Start a new
        currentOperator = buttonText
        
        let resultsLabelText = delegate?.getResultsLabelVal()
            // Do subcalculation so you dont always have to press =
        if resultsLabelText != "" && secondNumber != "" {
            total = resultsLabelText!
            let calculateVal = calculate()
            delegate?.updateResultsLabel(result: calculateVal)
        }
        
        delegate?.updateResultsLabel(result: total)
    }
    
    mutating func numButtonPressed(buttonText: String){
        let lastButtonPressedText = delegate?.getLastButtonText()
        if lastButtonPressedText == "=" {
            total = ""
        }
        
        // First Number
        if currentOperator == nil {
            if buttonText == "." {
                total = checkDecimal(number: total)
            } else {
                total += buttonText
            }
            delegate?.updateResultsLabel(result: total)
            
            // if an operator is selected - second number
        } else {
            delegate?.clearOperatorsUI()
            if buttonText == "." {
                secondNumber = checkDecimal(number: secondNumber)
            } else {
                secondNumber += buttonText
            }
            delegate?.updateResultsLabel(result: secondNumber)
        }
    }
    
    // Check to see if a decimal can be added
    func checkDecimal(number: String) -> String {
        var result = number;
        if number == "" {
            result = "0."
        } else if !result.contains("."){
            result += "."
        }
        return result
    }
    
    // Invert currently displayed number
    mutating func invertNumber(){
        var tempDouble: Double
        if currentOperator == nil {
            tempDouble = Double(total)!
            total = String(-tempDouble)
            delegate?.updateResultsLabel(result: total)
        } else {
            tempDouble = Double(secondNumber)!
            secondNumber = String(-tempDouble)
            delegate?.updateResultsLabel(result: secondNumber)
        }
    }
    
    mutating func percentage(){
        if currentOperator == "X" {
            secondNumber = String(Double(secondNumber)! / 100.0)
            delegate?.updateResultsLabel(result: secondNumber)
        }
    }
}
