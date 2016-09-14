//
//  KilledPanel.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/24.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation
import UIKit


class KilledPanel: UIView {
	
	var chessPanel = UIView(frame:CGRectZero) // 死子面板
    var killedChessList = [Chess]() // 死子列表
	
    init(){
        super.init(frame:CGRectZero)
        self.backgroundColor = UIColor.clearColor()
		self.addSubview(chessPanel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect){
        self.chessPanel.frame.size = CGSize(width: frame.width, height: frame.width / 8)
		if self.chessPanel.frame.size.height > frame.height {
			self.chessPanel.frame.size = CGSize(width: frame.width, height: frame.height)
		}
		self.chessPanel.backgroundColor = UIColor.clearColor()
		
		// 绘制边框
		let rectangle = CGRectMake(0, 0, frame.width, frame.height);
		let pathRect = CGRectInset(rectangle, 4, 4)
		let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 8)
		path.lineWidth = 1
		bgcolor_killedPanel.setFill()
		bordercolor_killedPanel.setStroke()
		path.fill()
		path.stroke()
	}
	
	/// 增加一个死棋子
	/// - parameter chess 死棋子
	/// - returns: void
    func add(chess:Chess){
        killedChessList.append(chess)
        let chessView = ChessView(chess: chess)
		chessView.tag = killedChessList.count
		
		let margin = chessPanel.frame.height / 10
		
        let height = chessPanel.frame.height - 2 * margin
        let width = height
        
        let count = killedChessList.count
        let x = CGFloat(count) * (width / 2)
        let y = chessPanel.frame.height / 2
        let p = CGPoint(x:x, y:y)
		
		chessView.drawView(p, width: width, reverse: chess.color)
		
        chessPanel.addSubview(chessView)

		refreshView()
	}
	
	/// 重绘死棋子的位置（永远居中）
	/// - parameter none
	/// - returns: void
	private func refreshView() {
		let margin = chessPanel.frame.height / 10
		
		let height = chessPanel.frame.height - 2 * margin
		let width = height
		
		let count = killedChessList.count
		let chessPanelSize = CGSize(width: (width * CGFloat(count) / 2 + width / 2), height: self.chessPanel.frame.size.height)
		self.chessPanel.frame = CGRect(origin: CGPoint(x:(frame.width - chessPanelSize.width) / 2, y:(frame.height - self.chessPanel.frame.size.height) / 2), size: chessPanelSize)
	}
	
	/// 从死棋子面板中移除一个死子（一般由于回退导致）
	/// - parameter none
	/// - returns: void
	func remove() {
		viewWithTag(killedChessList.count)?.removeFromSuperview()
		killedChessList.removeLast()
		refreshView()
	}
}