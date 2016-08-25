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
    
    private var cgPoint:CGPoint!
	var Point:CGPoint { return self.cgPoint }
	var BindChessView:ChessView?
	
	var x:CGFloat { return cgPoint.x }
	var y:CGFloat { return cgPoint.y }
    private let index:Int
	
    required init(x:CGFloat, y:CGFloat, index:Int){
		self.index = index
        super.init(frame:CGRectZero)
        cgPoint=CGPoint(x:x, y:y)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if chessLogic.ended {
			board.setPointFocus(self, stable: false)
		} else if board.PickedChessPoint != nil {
			board.setPointFocus(self, stable: false)
		}
    }
	
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if chessLogic.ended {
			board.setPointFocus(self, stable: false)
            return
        }
		
        if board.PickedChessPoint == nil {
            if self.BindChessView != nil && chessLogic.isBlackGo == self.BindChessView!.chess.isBlack {
                board.pickChessPoint(self, stable: true)
				board.clearAwkward()
            }
        }else{
			
            let srcPoint = board.PickedChessPoint!
            let toPoint = self
            
            let result = chessLogic.moveChess(srcPoint.index, to:toPoint.index)
            if case MoveMessage.FailSameColor = result {
                board.pickChessPoint(self, stable: true)
				board.clearAwkward()
			} else {
                
                if case MoveMessage.FailCanNotReach = result {
					board.showAwkward(srcPoint)
				} else {
					board.moveChessByPoint(srcPoint, to: toPoint)
					board.doMoveMessage(result, isFromBack: false)
				}
				
                board.dropPickedChessPoint()
            }
        }
    }
	
    func doInit( ){
        let x = self.cgPoint.x - board.PointWidth / 2
        let y = self.cgPoint.y - board.PointWidth / 2
		// print ("x:\(x), y:\(y)")
		self.frame = CGRect(x:x, y:y, width: board.PointWidth, height: board.PointWidth)
    }
    
}
