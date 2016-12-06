//
//  GraphViewController.swift
//  Calculator
//
//  Copyright © 2016 Zach Ziemann. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    
    //properties
    
    var graphFunction: CGFloat = 0
    

    //turn on gestures here
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: #selector(GraphView.changeScale(_:)) ))
            
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(GraphView.panOrigin(_:))))
            
            graphView.addGestureRecognizer(UITapGestureRecognizer(target: graphView, action: #selector(GraphView.tapOrigin(_:))))
            
            graphView.setFunction(graphFunction)
        }
    }
    
    @IBOutlet weak var labelOutlet: UILabel!
    
    func functionToGraph(val: CGFloat) {
        graphFunction = val
        setLabel(String(val))
    }
    
    func setLabel(labelText: String){
        //labelOutlet.text = "F: "+String(labelText)
        
    }
}
