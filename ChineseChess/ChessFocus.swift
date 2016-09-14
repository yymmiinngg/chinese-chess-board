//
//  ChessFocus.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/21.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation
import UIKit

/// 棋子的焦点视图
class ChessFocus: UIView {
  
    private let point:CGPoint // 所在棋点
	private let color:UIColor // 颜色
	private var basewidth:CGFloat! // 基本宽度（线条）

	required init(point:CGPoint, color:UIColor){
		self.point = point
		self.color = color
		super.init(frame:CGRectZero)
		self.backgroundColor = UIColor.clearColor()
		self.basewidth = board.pointWidth / 35
        self.frame = CGRectMake(point.x - board.pointWidth / 2 - basewidth, point.y - board.pointWidth / 2 - basewidth, board.pointWidth + 2 * basewidth, board.pointWidth + 2 * basewidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect){
		let dotteShapLayer = CAShapeLayer()
        let mdotteShapePath = CGPathCreateMutable()
        dotteShapLayer.fillColor = UIColor.clearColor().CGColor
        dotteShapLayer.strokeColor = self.color.CGColor
        dotteShapLayer.lineWidth = basewidth
        CGPathAddEllipseInRect(mdotteShapePath, nil, CGRectMake(basewidth,basewidth,rect.width - 2 * basewidth , rect.height - 2 * basewidth))
        dotteShapLayer.path = mdotteShapePath
        let arr :NSArray = NSArray(array: [10, 5])
        dotteShapLayer.lineDashPhase = 1
        dotteShapLayer.lineDashPattern = arr as? [NSNumber]
        self.layer.addSublayer(dotteShapLayer)
    }

}