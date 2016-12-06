//
//  GraphView.swift
//  Calculator
//
//  Copyright © 2016 Zach Ziemann. All rights reserved.
//

import UIKit

//this will now update in our storyboard
@IBDesignable
class GraphView: UIView
{
    
    @IBInspectable  //these now change what's drawn when var is changed
    var scale: CGFloat = 1.0 { didSet { setNeedsDisplay() }
    }
    
    private var originCenter: CGPoint = CGPoint(x: 0, y: 0) { didSet { setNeedsDisplay() }
    }
    
    private var functionToGraph: CGFloat = 3.0
    
    func setFunction(newFunc: CGFloat)
    {
        functionToGraph = newFunc
    }
    
    private var initialOrigin = true
    
    var axes = AxesDrawer()
    
    
    //Gesture Handlers
    func panOrigin(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Changed, .Ended:
            originCenter  = recognizer.translationInView(self)
        default:
            break
        }
    }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed, .Ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    func tapOrigin(recognizer: UITapGestureRecognizer) {
        recognizer.numberOfTapsRequired = 2
        if recognizer.state == .Ended {
            originCenter = recognizer.locationInView(self)
        }
    }
    
    //converts point based on our defined origin
    func convertPoint(oldPoint: CGPoint) -> CGPoint {
        return CGPoint(x: originCenter.x+oldPoint.x, y: originCenter.y+oldPoint.y)
    }
    
    
    //Drawing Stuff
    
    override func drawRect(rect: CGRect)
    {
        if initialOrigin {
            originCenter = CGPoint(x: bounds.midX, y:bounds.midY)
            initialOrigin = false
        }
        
        // Drawing code
        axes.drawAxesInRect(bounds, origin: originCenter, pointsPerUnit: scale)
        
        let path = UIBezierPath()
        let startX = CGFloat((bounds.width))
        var widthX = (bounds.width/2)
        
        path.moveToPoint(convertPoint(CGPoint(x: startX, y: functionToGraph*scale)))
        
        while widthX > -((bounds.width/2)*scale)
        {            
            path.addLineToPoint(convertPoint(CGPoint(x: CGFloat(widthX*scale), y: -(functionToGraph*scale))))
            widthX--
        }
        
        path.lineWidth = CGFloat(3.0)
        path.stroke()
    }
    
    

}
