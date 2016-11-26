//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Zach Ziemann on 9/12/16.
//  Copyright © 2016 Zach Ziemann. All rights reserved.

//  This code contains a lot of my own notes from lectures

import Foundation

class CalculatorBrain
{
    private var accumulator = 0.0
    
    private var internalProgram = [AnyObject]()
    
    private var descriptionString = ""
    private var equalsPrevious = false
    private var unaryPrevious = false
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    func setOperand(operand: String) {
        accumulator = variableValues[operand]!
        internalProgram.append(accumulator)
    }
    
    func setHistory(history: String) {
        descriptionString = history
    }
    
    func clearHistory() {
        descriptionString = ""
        accumulator = 0
        equalsPrevious = false
        unaryPrevious = false
        pending = nil
        internalProgram.removeAll()
        variableValues.removeAll()
    }
    
    var variableValues: Dictionary<String, Double> = [
        :
        //"M" : 0.0
    ]
    
    //dictionary is swift thing, generic type
    //first parameter of dictionary is key, second is value
    private var operations: Dictionary<String,Operation> = [
        "Pi" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "ran" : Operation.Constant(Double(arc4random_uniform(10000))/10000),
        "±" : Operation.UnaryOperation({ -$0 }),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "sin" : Operation.UnaryOperation(sin),
        "tan" : Operation.UnaryOperation(tan),
        "log" : Operation.UnaryOperation(log),
        //closures, in line functions
        //$0,$1, etc default arguments
        //the return is now inferred
        "x²" : Operation.UnaryOperation({ pow($0, 2.0) }),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals
    ]
    
    //enum similar to class, can have methods
    //contains all operations we know how to do
    //enum = discrete set of values, can't have inheritance
    //passed by value
    private enum Operation {
        //enums can have associated values
        case Constant(Double)
        //function associated value
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if equalsPrevious == true {
            descriptionString = ""
            equalsPrevious = false
        }
        //how you look up things in a dictionary
        //this if fixes the option unwrapping problem
        if let operation = operations[symbol] {
            //what we do based on what could happen (every scenario)
            switch operation {
                //swift infers that it's operation.Constant
                
            case .Constant(let value):
                descriptionString = descriptionString + String(symbol)
                accumulator = value
                
            case .UnaryOperation(let function):
                if unaryPrevious == true {
                    descriptionString = descriptionString + symbol + "(" + String(accumulator) + ")"
                    unaryPrevious = false
                }
                else {
                    descriptionString = descriptionString + symbol + "(" + String(accumulator) + ")"
                    unaryPrevious = true
                }
                accumulator = function(accumulator)
                
            case .BinaryOperation(let function):
                descriptionString = descriptionString + String(accumulator) + String(symbol)
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                
            case .Equals:
                descriptionString = descriptionString + String(accumulator)
                executePendingBinaryOperation()
                equalsPrevious = true
                
            }
        }
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    //structs are passed by value, classes are passed by reference
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var description: String {
        get
        {
            return descriptionString
        }
    }
    
    var isPartialResult: Bool {
        get {
            if pending != nil {
                return true
            }
            else {
                return false
            }
        }
    }
    //documentation here that our program is a propertylist
    //made a property list the same thing as anyobject
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get{
            //returning a copy, not a point so it's safe
            return internalProgram
        }
        set{
            clearHistory()
            //if the program is an array of ops and operations
            //as an array of any objects
            if let arrayOfOps = newValue as? [AnyObject] {
                //looping through our variable which should be our program
                for op in arrayOfOps {
                    //if its an operand then setOperand and run program
                    if let operand = op as? Double {
                        setOperand(operand)
                    }
                    //but if we see its an operation then we run that operation
                    else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
            print("ERROR: did not pass an array of AnyObject")
        }
    }
    
    //computed var, and only implementing get the so it's read only
    var result: Double {
        get {
            return accumulator
        }
    }
}