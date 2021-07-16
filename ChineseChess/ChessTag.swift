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
	case awkward, lose, win
}

class ChessTag: UIView {
	
	fileprivate var tagType:TagType? // 标志类型
	
	override func draw(_ rect: CGRect){
		let context:CGContext? =  UIGraphicsGetCurrentContext();//获取画笔上下文
		context!.setAllowsAntialiasing(true) //抗锯齿设置
		
		switch tagType! {
		case .awkward: // 尴尬的标志
			let w = frame.width
			let h = frame.height
			context?.setStrokeColor(color_chess_tag_awkward.cgColor)
			context?.setLineWidth(w / 40) //设置画笔宽度
			
			context?.move(to: CGPoint(x: w / 10 * 6, y: h / 10 * 0));
			context?.addLine(to: CGPoint(x: w / 10 * 6, y: h / 10 * 5));
			
			context?.move(to: CGPoint(x: w / 10 * 7, y: h / 10 * 0.2));
			context?.addLine(to: CGPoint(x: w / 10 * 7, y: h / 10 * 5));
			
			context?.move(to: CGPoint(x: w / 10 * 8, y: h / 10 * 0.4));
			context?.addLine(to: CGPoint(x: w / 10 * 8, y: h / 10 * 5));
			
			context?.move(to: CGPoint(x: w / 10 * 9, y: h / 10 * 0.6));
			context?.addLine(to: CGPoint(x: w / 10 * 9, y: h / 10 * 5));
			
			context?.strokePath()
		case .lose: // 失败的标志
			context?.setLineWidth(1) //设置画笔宽度
			context?.setStrokeColor(color_chess_shadow.cgColor)
			context?.setFillColor(color_chess_tag_lose.cgColor)
			context?.fillEllipse(in: CGRect(x: 1, y: 1,width: rect.width - 2, height: rect.height - 2 ))
			context?.addEllipse(in: CGRect(x: 1, y: 1,width: rect.width - 2, height: rect.height - 2 )); //画圆
			context?.strokePath() //关闭路径
		case .win: // 成功的标志
			// self.addSubview(label("WIN"));
			break
		}
	}
	
	/// 生成文字视图
	/// - parameter text 文字
	/// - returns: UILabel
	fileprivate func label(_ text:String) -> UILabel{
		let label:UILabel!
		let p:CGPoint = CGPoint(x: self.frame.width / 2, y: 0)
		label = UILabel(frame:CGRect(origin: p, size:CGSize(width: self.frame.width / 2, height: self.frame.height / 4)))
		label.textColor = color_chess_tag_win
		label.backgroundColor = UIColor.clear
		label.text = text
		label.textAlignment = NSTextAlignment.right
		label.adjustsFontSizeToFitWidth = true
		label.font = UIFont.boldSystemFont(ofSize: self.frame.width / 4)
		return label
	}
	
	/// 初始化
	/// - parameter chessView 象棋视图（附着在哪个视图）
	/// - returns: void
	func doInit(_ chessView:ChessView, tagType:TagType) {
		let width = chessView.frame.width
		self.tagType = tagType;
		self.frame = CGRect(x: 0, y: 0, width: width, height: width)
		self.backgroundColor = UIColor.clear
	}
	
}
