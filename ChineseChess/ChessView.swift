//
//  ChessView.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/19.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation
import UIKit

class ChessView: UIView {
	
	let chess:Chess // 象棋角色
	private var reverse = false // 反转
	
	var chessTag:ChessTag? // 象棋标记
	
	init(chess:Chess) {
		self.chess = chess
		super.init(frame:CGRectZero)
		self.backgroundColor = UIColor.clearColor()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func drawRect(rect: CGRect){
		let basewidth:CGFloat = rect.width / 35 // 基础宽度
		
		let context:CGContextRef? =  UIGraphicsGetCurrentContext();//获取画笔上下文
		CGContextSetAllowsAntialiasing(context, true) //抗锯齿设置
		let color:UIColor
		
		// 黑/红棋颜色设定
		if chess.color {
			color = color_black_chess
		}
		else {
			color = color_red_chess
		}
		
		// 象棋底图
		CGContextSetLineWidth(context, 1) //设置画笔宽度
		CGContextSetStrokeColorWithColor(context, color_chess_shadow.CGColor)
		CGContextSetFillColorWithColor(context, bgcolor_chess.CGColor)
		CGContextFillEllipseInRect(context, CGRectMake(1, 1, rect.width - 2, rect.height - 2 ))
		CGContextAddEllipseInRect(context, CGRectMake(1, 1, rect.width - 2, rect.height - 2 )); //画圆
		CGContextStrokePath(context) //关闭路径
		CGContextSetLineWidth(context, basewidth) //设置画笔宽度
		CGContextSetStrokeColorWithColor(context, color.CGColor)
		CGContextAddEllipseInRect(context, CGRectMake(basewidth * 3, basewidth * 3, rect.width - 6 * basewidth, rect.height - 6 * basewidth)); //画圆
		CGContextStrokePath(context) //关闭路径
		
		// 象棋文字
		let label:UILabel!
		let p:CGPoint = CGPointMake(0, 0)
		label = UILabel(frame:CGRect(origin: p, size:rect.size))
		label.textColor = color
		label.backgroundColor = UIColor.clearColor()
		label.text = chess.name
		label.textAlignment = NSTextAlignment.Center
		label.adjustsFontSizeToFitWidth = true
		label.font = UIFont.boldSystemFontOfSize(rect.size.width * 0.5)
		
		// 象棋旋转角度
		var angle = CGFloat(0)
		if chess.color {
			angle += 180
		}
		if reverse {
			angle += 180
		}
		label.transform = CGAffineTransformMakeRotation(angle * CGFloat(M_PI)/CGFloat(180));
		
		self.addSubview(label);
	}
	
	/// 显示象棋标志
	/// - parameter 标志类型
	/// - returns: void
	func showTag(tagType: TagType){
		// 生成标志
		if nil == chessTag {
			chessTag = ChessTag()
		}
		// 标志颜色
		chessTag!.backgroundColor = UIColor.clearColor()
		if chess.color {
			chessTag!.transform = CGAffineTransformMakeRotation(180 * CGFloat(M_PI)/CGFloat(180));
		}
		addSubview(chessTag!)
		// 标志初始化
		chessTag!.doInit(self, tagType: tagType)
	}
	
	/// 隐藏标志
	/// - parameter none
	/// - returns: void
	func hideTag(){
		if nil != chessTag {
			chessTag!.removeFromSuperview()
			chessTag = nil
		}
	}
	
	func drawView(point:CGPoint, width:CGFloat, reverse:Bool = false){
		let x = point.x - width / 2
		let y = point.y - width / 2
		self.reverse = reverse
		self.frame = CGRect(x:x, y:y, width: width, height: width)
	}
//	
//	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//		print ("ChessView.touchesEnded, chessLogic.isEnded = \(chessLogic.isEnded)")
//	}

}