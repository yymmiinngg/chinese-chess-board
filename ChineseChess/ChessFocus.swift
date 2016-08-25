//
//  ChessFocus.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/21.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation
import UIKit

class ChessFocus: UIView {
  
    private let point:CGPoint
	private let color:UIColor
	
	required init(point:CGPoint, color:UIColor){
		self.point = point
		self.color = color
		super.init(frame:CGRectZero)
		self.backgroundColor = UIColor.clearColor()
        self.frame = CGRectMake(point.x - board.PointWidth / 2 - 3, point.y - board.PointWidth / 2 - 3, board.PointWidth + 6, board.PointWidth + 6)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect){
        let basewidth:CGFloat = rect.width / 40
        let dotteShapLayer = CAShapeLayer()
        let mdotteShapePath = CGPathCreateMutable()
        dotteShapLayer.fillColor = UIColor.clearColor().CGColor
        dotteShapLayer.strokeColor = self.color.CGColor
        dotteShapLayer.lineWidth = basewidth
        CGPathAddEllipseInRect(mdotteShapePath, nil, CGRectMake(basewidth,basewidth,rect.width - 2 * basewidth , rect.height - 2 * basewidth))
        dotteShapLayer.path = mdotteShapePath
        let arr :NSArray = NSArray(array: [10,5])
        dotteShapLayer.lineDashPhase = 1.0
        dotteShapLayer.lineDashPattern = arr as? [NSNumber]
        self.layer.addSublayer(dotteShapLayer)
    }

}