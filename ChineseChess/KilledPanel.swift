//
//  CtrlPanel.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/24.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation
import UIKit


class KilledPanel: UIView {
    
    var killedChessList = [Chess]()
	
    init(){
        super.init(frame:CGRectZero)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect){
        
    }
    
    func add(chess:Chess){
        killedChessList.append(chess)
        let chessView = ChessView(chess: chess)
		chessView.tag = killedChessList.count
        
        let height = frame.height - frame.height / 10
        let width = height
        
        let count = killedChessList.count
        let x = (frame.height / 10) +  CGFloat(count) * (width / 2)
        let y = frame.height / 2
        let p = CGPoint(x:x, y:y)
		
		chessView.drawView(p, width: width, reverse: chess.isBlack)
		
        addSubview(chessView)
    }
	
	func remove(){
		viewWithTag(killedChessList.count)?.removeFromSuperview()
		killedChessList.removeLast()
	}
}