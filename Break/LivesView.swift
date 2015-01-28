//
//  LivesView.swift
//  Break
//
//  Created by Nick Cowart on 1/28/15.
//  Copyright (c) 2015 Nick Cowart. All rights reserved.
//

import UIKit

@IBDesignable class LivesView: UIView {

    @IBInspectable var livesLeft: Int = 3 {
        
        didSet {
            
            setNeedsDisplay()
        }
        
    }
        
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        var context = UIGraphicsGetCurrentContext()
        
        let ballSize: CGFloat = 10
        let topPadding: CGFloat = 15
        
        let totalBallWidth = ballSize * CGFloat(livesLeft + livesLeft - 1)
        let leftPadding = (rect.width - CGFloat(totalBallWidth)) / 2.0
        
        for i in 0..<livesLeft {
            
            let x = CGFloat(i * 2) * ballSize + leftPadding
            
            let lifeRect = CGRectMake( x, topPadding, ballSize, ballSize)
         
            UIColor.whiteColor().set()
            CGContextFillEllipseInRect(context, lifeRect)
        }
    
    }


}
