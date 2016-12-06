//
//  ViewController.swift
//  Calculator
//
//  Created by Zach Ziemann on 9/8/16.
//  Copyright © 2016 Zach Ziemann. All rights reserved.

//  This code contains a lot of my own notes from lectures

//  Don't do calculations in a controllers

import UIKit

class CalculatorViewController: UIViewController {

    //property
    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet private weak var history: UILabel!
    
    //helps for when we want longer numbers
    private var userIsInTheMiddleOfTyping = false
    
    private var decimalPressed = false

    @IBAction private func clear(sender: UIButton) {
        displayValue = 0
        historyValue = ""
        brain.clearHistory()
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func backspace(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            var tempy = display.text!
            tempy.removeAtIndex(tempy.endIndex.predecessor())
            displayValue = Double(tempy)!
        
        }
        else{
            //undo button
            savedProgram2 = brain.program
            let progLen = savedProgram2!.count-1
            //print(String(progLen))
            savedProgram2!.removeObjectAtIndex(progLen)
            brain.program = savedProgram2!
            displayValue = brain.result
        }
    }
    
    @IBAction private func touchDigit(sender: UIButton) {
        //whenever a digit button is pressed, set this var to the text in the button
        let digit = sender.currentTitle!

        if userIsInTheMiddleOfTyping {
            //getting text that's in our display box right now and setting it to this var
            let textCurrentlyInDisplay = display.text!
            
            //need to check to see if we've already entered a decimal point
            if decimalPressed == true && sender.currentTitle! == "." {
            }
            else {
            //new text is what we had before plus our new number
            display.text = textCurrentlyInDisplay + digit
            }
        }
        else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
        if sender.currentTitle! == "." {
            decimalPressed = true
        }
    
    }
    
    //computed property, not stored but computed (shown by curly braces)
    private var displayValue: Double! {
        get {
            //this is a double optional cause you don't know if converting to double is legal
            return Double(display.text!)!
        }
        set {
            //newValue is special keyword, a double based on our defintion
            let roundingFormatter = NSNumberFormatter()
            roundingFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            roundingFormatter.maximumFractionDigits = 6
            display.text = roundingFormatter.stringFromNumber(newValue)
        }
    }
    
    private var historyValue: String {
        get {
            return history.text!
        }
        set {
            //newValue is special keyword, a double based on our defintion
            if brain.isPartialResult {
                history.text = String(newValue + " ...")
            }
            else {
                history.text = String(newValue + " =")
            }
        }
    }
    
    var savedProgram2: CalculatorBrain.PropertyList?
    
    //extra code from lecture
    var savedProgram: CalculatorBrain.PropertyList?
    
    
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction func getMemvar() {
        if let memval = brain.variableValues["M"]
        {
            brain.setOperand("M")
            displayValue = memval
        }
    }
    
    @IBAction func setMemvar() {
        brain.variableValues["M"] = displayValue
    }
    
    //"that big green arrow where the controller talks to the model (brain)"
    //we initialized the brain, don't forget that
    private var brain = CalculatorBrain()
    
    //this section hooks up our controller to our model, the calculations
    //when an OP button is pressed, do this and get sender button
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            decimalPressed = false
        }
        if let mathematicalSymbol = sender.currentTitle
        {
            brain.performOperation(mathematicalSymbol)
        }
        //after math is done, come back to here and set the display
        displayValue = brain.result
        historyValue = brain.description
    }
    
    
    //var graphView: GraphView!
    
    
    @IBAction func graphFunction()
    {
        //graphView.setFunction(CGFloat(displayValue))
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            if let destination = segue.destinationViewController as? GraphViewController {
                destination.functionToGraph(CGFloat(displayValue))
        }
    }
    
}

