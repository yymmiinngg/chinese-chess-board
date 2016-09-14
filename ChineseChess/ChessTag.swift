//
//  ChessTag.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/25.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation
import UIKit

enum TagType {
	case Awkward, Lose, Win
}

class ChessTag: UIView {
	
	private var tagType:TagType? // 标志类型
	
	override func drawRect(rect: CGRect){
		let context:CGContextRef? =  UIGraphicsGetCurrentContext();//获取画笔上下文
		CGContextSetAllowsAntialiasing(context!, true) //抗锯齿设置
		
		switch tagType! {
		case .Awkward: // 尴尬的标志
			let w = frame.width
			let h = frame.height
			CGContextSetStrokeColorWithColor(context, color_chess_tag_awkward.CGColor)
			CGContextSetLineWidth(context, w / 40) //设置画笔宽度
			
			CGContextMoveToPoint(context, w / 10 * 6, h / 10 * 0);
			CGContextAddLineToPoint(context, w / 10 * 6, h / 10 * 5);
			
			CGContextMoveToPoint(context, w / 10 * 7, h / 10 * 0.2);
			CGContextAddLineToPoint(context, w / 10 * 7, h / 10 * 5);
			
			CGContextMoveToPoint(context, w / 10 * 8, h / 10 * 0.4);
			CGContextAddLineToPoint(context, w / 10 * 8, h / 10 * 5);
			
			CGContextMoveToPoint(context, w / 10 * 9, h / 10 * 0.6);
			CGContextAddLineToPoint(context, w / 10 * 9, h / 10 * 5);
			
			CGContextStrokePath(context)
		case .Lose: // 失败的标志
			CGContextSetLineWidth(context, 1) //设置画笔宽度
			CGContextSetStrokeColorWithColor(context, color_chess_shadow.CGColor)
			CGContextSetFillColorWithColor(context, color_chess_tag_lose.CGColor)
			CGContextFillEllipseInRect(context, CGRectMake(1, 1,rect.width - 2, rect.height - 2 ))
			CGContextAddEllipseInRect(context, CGRectMake(1, 1,rect.width - 2, rect.height - 2 )); //画圆
			CGContextStrokePath(context) //关闭路径
		case .Win: // 成功的标志
			self.addSubview(label("WIN"));
		}
	}
	
	/// 生成文字视图
	/// - parameter text 文字
	/// - returns: UILabel
	private func label(text:String) -> UILabel{
		let label:UILabel!
		let p:CGPoint = CGPointMake(self.frame.width / 2, 0)
		label = UILabel(frame:CGRect(origin: p, size:CGSize(width: self.frame.width / 2, height: self.frame.height / 4)))
		label.textColor = color_chess_tag_win
		label.backgroundColor = UIColor.clearColor()
		label.text = text
		label.textAlignment = NSTextAlignment.Right
		label.adjustsFontSizeToFitWidth = true
		label.font = UIFont.boldSystemFontOfSize(self.frame.width / 4)
		return label
	}
	
	/// 初始化
	/// - parameter chessView 象棋视图（附着在哪个视图）
	/// - returns: void
	func doInit(chessView:ChessView, tagType:TagType) {
		let width = chessView.frame.width
		self.tagType = tagType;
		self.frame = CGRect(x: 0, y: 0, width: width, height: width)
		self.backgroundColor = UIColor.clearColor()
	}
	
}