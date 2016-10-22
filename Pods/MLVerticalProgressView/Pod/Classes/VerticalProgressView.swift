//
//  VerticalProgressView.swift
//  VerticalProgressView
//
//  Created by mlaskowski on 11/08/15.
//  Copyright (c) 2015 mlaskowski. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class VerticalProgressView : UIView {
    
    @IBInspectable open var cornerRadius: CGFloat = 12;
    @IBInspectable open var fillDoneColor : UIColor = UIColor.blue
    //@IBInspectable public var fillUndoneColor: UIColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.1)
    //@IBInspectable var fillRestColor : UIColor = UIColor.whiteColor()
    @IBInspectable open var animationDuration: Double = 0.5
    
    @IBInspectable open var progress: Float {
        get {
            return self.progressPriv
        }
        set{
            self.setProgress(newValue, animated: self.animationDuration > 0.0)
        }
    }
    
    var progressPriv: Float = 0.0
    
    open var filledView: CALayer?
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.filledView == nil {
            self.filledView = CALayer()
            self.filledView!.backgroundColor = self.fillDoneColor.cgColor
            self.layer.addSublayer(filledView!)
        }
        self.filledView!.frame = self.bounds
        self.filledView!.frame.origin.y = self.shouldHavePosition()
    }
    
    open override func prepareForInterfaceBuilder() {
        self.progressPriv = progress
        if self.progressPriv < 0 { progressPriv = 0 }
        else if(self.progressPriv > 1) { progressPriv = 1}
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let filledHeight = rect.size.height * CGFloat(self.progressPriv)
        self.setLayerProperties()
        let y = self.frame.size.height - filledHeight
        self.filledView!.frame = CGRect(x: 0, y: y, width: rect.size.width, height: rect.size.height)

    }

    //public - for possible inheritance and customization
    open func setLayerProperties(){
        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = true
    }
    
    func shouldHavePosition() -> CGFloat {
        let filledHeight = self.frame.size.height * CGFloat(self.progressPriv)
        let position = self.frame.size.height - filledHeight
        return position
    }
    
    func setFilledPosition(_ position: CGFloat, animated: Bool) {
        if self.filledView == nil { return }
        //animated
        let duration: TimeInterval = animated ? self.animationDuration : 0;
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        self.filledView!.frame.origin.y = position
        CATransaction.commit()
        
    }
    
    open func setProgress(_ progress: Float, animated: Bool){
        //bounds check
        var val = progress
        if val < 0 { val = 0.0 }
        else if val > 1 { val = 1 }
        self.progressPriv = val
        
        setFilledPosition(self.shouldHavePosition(), animated: animated)
    }

    
    
}
