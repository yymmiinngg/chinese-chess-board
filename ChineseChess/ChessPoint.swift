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
		if chessLogic.isEnded {
			board.showPointFocus(self, stable: false)
            return
        }
		
        if board.pickedChessPoint == nil {
            if self.BindChessView != nil && chessLogic.nextColor == self.BindChessView!.chess.color {
                board.pickChessPoint(self, stable: true)
				board.clearChessAwkward()
            }
        }else{
			
            let srcPoint = board.pickedChessPoint!
            let toPoint = self
            
            let result = chessLogic.moveChess(srcPoint.index, to:toPoint.index)
            if case MoveMessage.FailSameColor = result {
                board.pickChessPoint(self, stable: true)
				board.clearChessAwkward()
			} else {
                
                if case MoveMessage.FailCanNotReach = result {
					board.showChessAwkward(srcPoint)
				} else {
					board.moveChessView(srcPoint, to: toPoint, moveMessage: result, isFromBack: false)
					board.afterMoveChessView()
				}
				
                board.droppickedChessPoint()
            }
        }
    }
	
    func doInit(){
        let x = self.cgPoint.x - board.pointWidth / 2
        let y = self.cgPoint.y - board.pointWidth / 2
		self.frame = CGRect(x:x, y:y, width: board.pointWidth, height: board.pointWidth)
    }
    
}
