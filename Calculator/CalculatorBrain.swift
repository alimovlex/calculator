//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by robot on 2/28/21.
//  Copyright © 2021 robot. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private var accumulator = 0.0;
    func setOperand(operand: Double) {
        accumulator = operand;
    }
   
    private var operations: Dictionary<String, Operation> = [
                                                  "π": Operation.Constant(Double.pi),
                                                  "e": Operation.UnaryOperation(exp),
                                                  "√": Operation.UnaryOperation(sqrt),
                                                  "±": Operation.UnaryOperation({-$0}),
                                                  "cos": Operation.UnaryOperation(cos),
                                            "✖️": Operation.BinaryOperation({$0 * $1}),
                                            "➗": Operation.BinaryOperation({$0 / $1}),
                                            "➕": Operation.BinaryOperation({$0 + $1}),
                                            "➖": Operation.BinaryOperation({$0 - $1}),
                                                  "=": Operation.Equals];
    
   private enum Operation {
        case Constant(Double);
        case UnaryOperation((Double) -> Double);
        case BinaryOperation((Double, Double) -> Double);
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value;
            case .UnaryOperation(let function):
                accumulator = function(accumulator);
            case .BinaryOperation(let function):
                executePendingBinaryOperation();
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator);
            case .Equals:
                executePendingBinaryOperation();
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator);
            pending = nil;
        }
    }
    
    private var pending: PendingBinaryOperationInfo?;
    
   private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double;
        var firstOperand: Double;
    }
    
    var result: Double {
        get {
            return accumulator;
        }
    }
}
