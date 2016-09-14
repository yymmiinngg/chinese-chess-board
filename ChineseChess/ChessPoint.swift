//
//  ChessPoint.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/20.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation
import UIKit

class ChessPoint: UIView {
	
    private var _point:CGPoint! // 位置点
	var Point:CGPoint { return self._point }
	var BindChessView:ChessView?
	
	var x:CGFloat { return _point.x } // 位置X坐标
	var y:CGFloat { return _point.y } // 位置Y坐标
    private let index:Int // 点所在的索引（0～89，共90个位置）
	
    required init(x:CGFloat, y:CGFloat, index:Int){
		self.index = index
        super.init(frame:CGRectZero)
        _point = CGPoint(x:x, y:y)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		print ("ChessPoint.touchesBegan, chessLogic.isEnded = \(chessLogic.isEnded)")
		if chessLogic.isEnded {
			board.showPointFocus(self, stable: false)
		} else if board.pickedChessPoint != nil {
			board.showPointFocus(self, stable: false)
		}
    }
	
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {

    }
	
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		print ("ChessPoint.touchesEnded, chessLogic.isEnded = \(chessLogic.isEnded)")
		
		// 是否已经结束战局
		if chessLogic.isEnded {
			board.showPointFocus(self, stable: false)
            return
        }
		
		// 没有拾起的棋子
        if board.pickedChessPoint == nil {
            if self.BindChessView != nil && chessLogic.nextColor == self.BindChessView!.chess.color {
                board.pickChessPoint(self, stable: true)
				board.clearChessAwkward()
            }
        }
		// 有拾起的棋子
		else{
			
            let srcPoint = board.pickedChessPoint!
            let toPoint = self
			
			// 逻辑移动棋子
            let result = chessLogic.moveChess(srcPoint.index, to:toPoint.index)
			if case MoveMessage.FailSameColor = result {
				// 意图吃同色棋子
                board.pickChessPoint(self, stable: true)
				board.clearChessAwkward()
			}
			else {
                // 意图走违规棋
                if case MoveMessage.FailCanNotReach = result {
					board.showChessAwkward(srcPoint)
				} else {
					// 实际移动棋子
					board.moveChessView(srcPoint, to: toPoint, moveMessage: result, isFromBack: false)
					board.afterMoveChessView()
				}
				// 移除拾起棋子的点
                board.droppickedChessPoint()
            }
        }
    }
	
	/// 初始化棋点
	/// - parameter none
	/// - returns: void
    func doInit(){
        let x = self._point.x - board.pointWidth / 2
        let y = self._point.y - board.pointWidth / 2
		self.frame = CGRect(x:x, y:y, width: board.pointWidth, height: board.pointWidth)
    }
    
}
