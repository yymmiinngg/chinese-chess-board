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
  
    fileprivate let point:CGPoint // 所在棋点
	fileprivate let color:UIColor // 颜色
	fileprivate var basewidth:CGFloat! // 基本宽度（线条）

	required init(point:CGPoint, color:UIColor){
		self.point = point
		self.color = color
		super.init(frame:CGRect.zero)
		self.backgroundColor = UIColor.clear
		self.basewidth = board.pointWidth / 35
        self.frame = CGRect(x: point.x - board.pointWidth / 2 - basewidth, y: point.y - board.pointWidth / 2 - basewidth, width: board.pointWidth + 2 * basewidth, height: board.pointWidth + 2 * basewidth)
    }
	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect){
		let dotteShapLayer = CAShapeLayer()
        let mdotteShapePath = CGMutablePath()
		
		dotteShapLayer.fillColor = UIColor.clear.cgColor
        dotteShapLayer.strokeColor = self.color.cgColor
        dotteShapLayer.lineWidth = basewidth
		
		mdotteShapePath.addEllipse(in:CGRect(x: basewidth,y: basewidth,width: rect.width - 2 * basewidth , height: rect.height - 2 * basewidth) )
		
		//CGContextAddEllipseInRect(context!, CGRect(x: basewidth,y: basewidth,width: rect.width - 2 * basewidth , height: rect.height - 2 * basewidth))
		dotteShapLayer.path = mdotteShapePath
        let arr :NSArray = NSArray(array: [10, 5])
        dotteShapLayer.lineDashPhase = 1
        dotteShapLayer.lineDashPattern = arr as? [NSNumber]
        self.layer.addSublayer(dotteShapLayer)
    }

}
