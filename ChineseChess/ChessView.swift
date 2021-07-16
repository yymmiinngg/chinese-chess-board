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
	fileprivate var reverse = false // 反转
	
	var chessTag:ChessTag? // 象棋标记
	
	init(chess:Chess) {
		self.chess = chess
		super.init(frame:CGRect.zero)
		self.backgroundColor = UIColor.clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect){
		let basewidth:CGFloat = rect.width / 35 // 基础宽度
		
		let context:CGContext? =  UIGraphicsGetCurrentContext();//获取画笔上下文
		context?.setAllowsAntialiasing(true) //抗锯齿设置
		let color:UIColor
		
		// 黑/红棋颜色设定
		if chess.color {
			color = color_black_chess
		}
		else {
			color = color_red_chess
		}
		
		// 象棋底图
		context?.setLineWidth(1) //设置画笔宽度
		context?.setStrokeColor(color_chess_shadow.cgColor)
		context?.setFillColor(bgcolor_chess.cgColor)
		context?.fillEllipse(in: CGRect(x: 1, y: 1, width: rect.width - 2, height: rect.height - 2 ))
		context?.addEllipse(in: CGRect(x: 1, y: 1, width: rect.width - 2, height: rect.height - 2 )); //画圆
		context?.strokePath() //关闭路径
		context?.setLineWidth(basewidth) //设置画笔宽度
		context?.setStrokeColor(color.cgColor)
		context?.addEllipse(in: CGRect(x: basewidth * 3, y: basewidth * 3, width: rect.width - 6 * basewidth, height: rect.height - 6 * basewidth)); //画圆
		context?.strokePath() //关闭路径
		
		// 象棋文字
		let label:UILabel!
		let p:CGPoint = CGPoint(x: 0, y: 0)
		label = UILabel(frame:CGRect(origin: p, size:rect.size))
		label.textColor = color
		label.backgroundColor = UIColor.clear
		label.text = chess.name
		label.textAlignment = NSTextAlignment.center
		label.adjustsFontSizeToFitWidth = true
		label.font = UIFont.boldSystemFont(ofSize: rect.size.width * 0.5)
		
		// 象棋旋转角度
		var angle = CGFloat(0)
		if chess.color {
			angle += 180
		}
		if reverse {
			angle += 180
		}
		label.transform = CGAffineTransform(rotationAngle: angle * CGFloat(Double.pi)/CGFloat(180));
		
		self.addSubview(label);
	}
	
	/// 显示象棋标志
	/// - parameter 标志类型
	/// - returns: void
	func showTag(_ tagType: TagType){
		// 生成标志
		if nil == chessTag {
			chessTag = ChessTag()
		}
		// 标志颜色
		chessTag!.backgroundColor = UIColor.clear
		if chess.color {
			chessTag!.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(Double.pi)/CGFloat(180));
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
	
	func drawView(_ point:CGPoint, width:CGFloat, reverse:Bool = false){
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
