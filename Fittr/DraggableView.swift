//
//  DraggableView.swift
//  Fittr
//
//  Created by Aditya Maru on 2016-10-22.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

let ACTION_MARGIN: Float = 120      //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH: Float = 4       //%%% how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX:Float = 0.93          //%%% upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX: Float = 1         //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH: Float = 320  //%%% strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE: Float = 3.14/8  //%%% Higher = stronger rotation angle



protocol DragableDelegateView {
    func cardSwipedRight(view: UIView) -> Void
    func cardSwipedLeft(view: UIView) -> Void
}

class DraggableView: UIView {
    var userDefaults = UserDefaults.standard;
    var delegate: DragableDelegateView!;
    var panGestureRecognizer: UIPanGestureRecognizer!;
    var originPoint: CGPoint!
//    var overlayView: OverlayView!
    var name: UILabel!
    var weight: UILabel!
    var favWorkout: UILabel!
    var photo:UIImage!
    var xFromCenter: Float!
    var yFromCenter: Float!
    var myID: String! = ""
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.setupView();
        
        name = UILabel(frame: CGRect(x: 0, y: 50, width: self.frame.size.width, height: 100))
        weight = UILabel(frame: CGRect(x: 0, y: 70, width: self.frame.size.width, height: 100))
        favWorkout = UILabel(frame: CGRect(x: 0, y: 90, width: self.frame.size.width, height: 100))
        name.text = "NOT AVAILABLE"
        name.textAlignment = NSTextAlignment.center
        self.backgroundColor = UIColor.red;
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DraggableView.beingDragged))
        self.addGestureRecognizer(panGestureRecognizer)
        self.addSubview((name))
        self.addSubview(weight)
        self.addSubview(favWorkout)
        
        
        // we need to setup the overlay here still
        
        xFromCenter = 0
        yFromCenter = 0
        
    }
    
    func setupView() -> Void {
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSize.init(width: 1, height: 1);
    }
    
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) -> Void
    {
        xFromCenter = Float(gestureRecognizer.translation(in: self).x)
        yFromCenter = Float(gestureRecognizer.translation(in: self).y)
        
        switch (gestureRecognizer.state)
        {
        case UIGestureRecognizerState.began:
            self.originPoint = self.center
        case UIGestureRecognizerState.changed:
            let rotationStrength: Float = min(xFromCenter/ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngle = ROTATION_ANGLE * rotationStrength
            let scale = max(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)
            
            self.center = CGPoint.init(x: self.originPoint.x + CGFloat(xFromCenter), y: self.originPoint.y + CGFloat(yFromCenter))
            
            let transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
            let scaleTransform = transform.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
            self.transform = scaleTransform
//            self.updateOverlay(CGFloat(xFromCenter))
        case UIGestureRecognizerState.ended:
            self.afterSwipeAction()
        case UIGestureRecognizerState.possible:
            fallthrough
        case UIGestureRecognizerState.cancelled:
            fallthrough
        case UIGestureRecognizerState.failed:
            fallthrough
        default:
            break
            
        }
        
    }
    
    func rightAction()
    {
        let finishPoint: CGPoint = CGPoint.init(x: 500, y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animate(withDuration:0.3,
                                   animations: {
                                    self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })

        delegate?.cardSwipedRight(view: self)
        
    }
    
    func leftAction()
    {
        let finishPoint: CGPoint = CGPoint.init(x: -500, y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animate(withDuration:0.3,
                       animations: {
                        self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate?.cardSwipedLeft(view: self)
        
    }
    
    
    func afterSwipeAction() -> Void
    {
        let floatXfromCenter = Float(xFromCenter)
        if floatXfromCenter > ACTION_MARGIN
        {
            self.rightAction()
        }
        else if floatXfromCenter < -ACTION_MARGIN
        {
            self.leftAction()
        }
        else
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.center = self.originPoint;
                self.transform = CGAffineTransform(rotationAngle: 0)
                
                //overlay insert here

            })
        }
        
    }
    
    
    
    
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
