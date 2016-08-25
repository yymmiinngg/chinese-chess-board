//
//  ChessBoardUIView.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/19.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation
import UIKit

class ChessBoardUIView : UIView{
	
	private var points = [ChessPoint]()
	
	private var marginX:CGFloat!
	private var marginY:CGFloat!
	
	private var pointWidth:CGFloat!
	var PointWidth:CGFloat {return pointWidth }
	
	private var perWidth:CGFloat!
	private var perHeight:CGFloat!
	
	private var BindChessViewList = [ChessView]()
	private var focus:ChessFocus?
	private var pickedChessPoint:ChessPoint?
	var PickedChessPoint:ChessPoint? { return self.pickedChessPoint }
	
	private var lastAwkwardChess:ChessView?
	private var hasShowEnding = false
	
	func doInit(){
		dropPickedChessPoint()
		removeChessFocus()
		clearAwkward()
		clearEndingTag()
		showChessViews()
	}
	
	override func drawRect(rect: CGRect){
		let context:CGContextRef? = UIGraphicsGetCurrentContext();//获取画笔上下文
		CGContextSetAllowsAntialiasing(context!, true) //抗锯齿设置
		
		marginX = rect.width / 9 / 6
		perWidth = (rect.width - marginX * 2) / 9
		perHeight = perWidth
		marginY = (rect.height - (perHeight * 10)) / 2
		
		pointWidth = perWidth - perWidth / 15
		
		for j in 0..<10 {
			for i in 0..<9 {
				let x = perWidth * CGFloat(i) + (perWidth / 2) + marginX
				let y = perHeight * CGFloat(j) + (perHeight / 2) + marginY
				let p = ChessPoint(x:x, y:y, index: points.count)
				points.append(p)
			}
		}
		
		drawLine(context, 2, color_board_line_shadow)
		drawLine(context, 1, color_board_line)
		drawB(context, 3, color_board_line)
		
		for i in 0..<points.count {
			let p = points[i]
//			let str:String = String(i)
//			str.drawAtPoint(CGPoint(x: p.Point.x + 10, y: p.Point!.y + 10), withAttributes: nil);
			p.doInit()
			self.addSubview(p)
		}
		
		doInit()
	}
	
	func pickChessPoint(chessPoint:ChessPoint!, stable: Bool) {
		self.pickedChessPoint = chessPoint
		self.setPointFocus(self.pickedChessPoint!, stable: stable)
	}
	
	func dropPickedChessPoint() {
		self.pickedChessPoint = nil
	}
	
	func showChessViews(){
		for i in 0 ..< points.count {
			points[i].BindChessView = nil
		}
		for i in 0..<BindChessViewList.count {
			let BindChessView = BindChessViewList[i]
			BindChessView.removeFromSuperview()
		}
		BindChessViewList.removeAll()
		
		for i in 0..<chessLogic.chesses.count {
			if let role = chessLogic.chesses[i] {
				self.addChess(role, to:points[i])
			}
		}
		
		for i in 0..<points.count {
			let p = points[i]
			self.bringSubviewToFront(p)
		}
	}
	
	func drawBackChessStep(step: ChessStep){
		
		let srcPoint = points[step.to]
		let toPoint = points[step.src]
		
		moveChessByPoint(srcPoint, to: toPoint)
		if let chess = step.toChess {
			self.addChess(chess, to: points[step.to])
		}
		doMoveMessage(step.moveMessage, isFromBack:true)
		
		for i in 0..<points.count {
			let p = points[i]
			self.bringSubviewToFront(p)
		}
		
		
	}
	
	func drawGoChessStep(step: ChessStep){
		
		let srcPoint = points[step.src]
		let toPoint = points[step.to]
		
		moveChessByPoint(srcPoint, to: toPoint)
		doMoveMessage(step.moveMessage, isFromBack:false)
		
		for i in 0..<points.count {
			let p = points[i]
			self.bringSubviewToFront(p)
		}
	}
	
	func doMoveMessage(result: MoveMessage, isFromBack:Bool){
		if case let MoveMessage.Success(killedChess) = result {
			if let kc = killedChess {
				if(isFromBack) {
					if kc.isBlack {
						redKilledPanel.remove()
					}else{
						blackKilledPanel.remove()
					}
				}else{
					if kc.isBlack {
						redKilledPanel.add(kc)
					}else{
						blackKilledPanel.add(kc)
					}
				}
			}
		}
		
		// 是否已经胜利
		if chessLogic.ended {
			if let winner = chessLogic.winner() {
				showEndingTag(winner)
				hasShowEnding = true;
			}
		} else if(hasShowEnding){
			clearEndingTag()
			hasShowEnding = false
		}
		
		// 是否正要将军
		hideJiangJunAwkward()
		if let jj  = chessLogic.tryJiangJun() {
			if jj.0 || jj.1 {
				showJiangJunAwkward(black:jj.0, red:jj.1)
			}
		}
		
		dropPickedChessPoint()
		removeChessFocus()
		clearAwkward()
		
	}
	
	func moveChessByPoint(srcPoint:ChessPoint, to toPoint:ChessPoint ){
		if toPoint.BindChessView != nil {
			toPoint.BindChessView!.removeFromSuperview()
		}
		
		// 目的地
		toPoint.BindChessView = srcPoint.BindChessView
		UIView.animateWithDuration(0.15, animations: { () -> Void in
			toPoint.BindChessView!.drawView(toPoint.Point, width: board.pointWidth!)
		})
		srcPoint.BindChessView = nil
	}
	
	func showEndingTag(winnerColor:Bool){
		for i in 0..<points.count {
			if let chess = points[i].BindChessView?.chess {
				if chess.isBlack == winnerColor {
					// points[i].BindChessView!.showTag(TagType.Win)
				}
				else{
					points[i].BindChessView!.showTag(TagType.Lose)
				}
			}
		}
	}
	
	func clearEndingTag () {
		for i in 0..<points.count {
			if let BindChessView = points[i].BindChessView {
				BindChessView.hideTag()
			}
		}
		hasShowEnding = false
	}
	
	func clearAwkward(){
		if lastAwkwardChess != nil {
			lastAwkwardChess!.hideTag()
			lastAwkwardChess = nil
		}
	}
	
	func showAwkward(chessPoint:ChessPoint){
		clearAwkward()
		lastAwkwardChess = chessPoint.BindChessView!
		lastAwkwardChess!.showTag(TagType.Awkward)
	}
	
	private func showJiangJunAwkward(black black:Bool, red:Bool){
		if black {
			if let jiang = chessLogic.getJiangPoint(true) {
				let p = points[jiang]
				p.BindChessView!.showTag(TagType.Awkward)
			}
		}
		if(red){
			if let jiang = chessLogic.getJiangPoint(false) {
				let p = points[jiang]
				p.BindChessView!.showTag(TagType.Awkward)
			}
		}
	}
	
	private func hideJiangJunAwkward(){
		if  let blackJiang = chessLogic.getJiangPoint(true) {
			if let blackPoint = points[blackJiang].BindChessView {
				blackPoint.hideTag()
			}
		}
		if let redJiang = chessLogic.getJiangPoint(false) {
			if let redPoint = points[redJiang].BindChessView {
				redPoint.hideTag()
			}
		}
	}
	
	private func addChess(chess:Chess, to chessPoint:ChessPoint){
		let BindChessView = ChessView(chess:chess)
		chessPoint.BindChessView = BindChessView
		self.addSubview(chessPoint.BindChessView!)
		BindChessView.drawView(chessPoint.Point, width: self.pointWidth!)
		BindChessViewList.append(chessPoint.BindChessView!)
	}
	
	func drawLine(context:CGContextRef?, _ width:CGFloat, _ color:UIColor ){
		
		CGContextSetLineWidth(context, width) //设置画笔宽度
		CGContextSetStrokeColorWithColor(context, color.CGColor)
		
		for var i = 0; i < 10 ; i += 1{
			let p1 = points[i*9]
			let p2 = points[i*9+8]
			line(p1.Point, p2.Point )
		}
		
		for var i = 0; i < 9 ; i += 1{
			let p1 = points[i]
			let p2 = points[i + 36]
			line(p1.Point ,p2.Point)
		}
		
		for var i = 0; i < 9 ; i += 1{
			let p1 = points[i + 45]
			let p2 = points[i + 81]
			line(p1.Point ,p2.Point)
		}
		
		let xpsa = points[66]
		let xpsb = points[68]
		let xpsc = points[86]
		let xpsd = points[84]
		line(xpsa.Point ,xpsc.Point)
		line(xpsb.Point ,xpsd.Point)
		
		let xpna = points[3]
		let xpnb = points[5]
		let xpnc = points[23]
		let xpnd = points[21]
		line(xpna.Point ,xpnc.Point)
		line(xpnb.Point ,xpnd.Point)
		
		let lbt = points[36]
		let lbb = points[45]
		let rbt = points[44]
		let rbb = points[53]
		line(lbt.Point ,lbb.Point)
		line(rbt.Point ,rbb.Point)
		
		tag(points[19],0o1111)
		tag(points[25],0o1111)
		
		tag(points[27],0o0110)
		tag(points[29],0o1111)
		tag(points[31],0o1111)
		tag(points[33],0o1111)
		tag(points[35],0o1001)
		
		tag(points[64],0o1111)
		tag(points[70],0o1111)
		
		tag(points[54],0o0110)
		tag(points[56],0o1111)
		tag(points[58],0o1111)
		tag(points[60],0o1111)
		tag(points[62],0o1001)
	}
	
	func drawB(context:CGContextRef?, _ width:CGFloat, _ color:UIColor ){
		CGContextSetLineWidth(context, width) //设置画笔宽度
		CGContextSetStrokeColorWithColor(context, color.CGColor)
		let pa = CGPoint( x: points[0].Point.x - width*2, y: points[0].Point.y - width*2)
		let pb = CGPoint( x: points[8].Point.x + width*2, y: points[8].Point.y - width*2)
		let pc = CGPoint( x: points[89].Point.x + width*2, y: points[89].Point.y + width*2)
		let pd = CGPoint( x: points[81].Point.x - width*2, y: points[81].Point.y + width*2)
		line(pa, pb)
		line(pb, pc)
		line(pc, pd)
		line(pd, pa)
	}
	
	func setPointFocus(point:ChessPoint!, stable:Bool){
		if focus != nil {
			focus!.removeFromSuperview()
		}
		var color:UIColor
		if stable {
			color = color_focus_stable
		} else {
			color = color_focus_volatile
		}
		focus = ChessFocus(point:point.Point, color: color)
		self.addSubview(focus!)
	}
	
	func removeChessFocus(){
		if focus != nil {
			focus!.removeFromSuperview()
		}
	}
	
	private func tag(p:ChessPoint,_ o:Int){
		let margins:CGFloat = perWidth / 16
		let marginl:CGFloat = perWidth / 6
		
		if o & 0o1000 > 0 {
			let a1 = CGPoint(x:p.x-margins,y:p.y-marginl)
			let a2 = CGPoint(x:p.x-margins,y:p.y-margins)
			let a3 = CGPoint(x:p.x-marginl,y:p.y-margins)
			line(a1,a2)
			line(a2,a3)
		}
		
		if o & 0o0100 > 0 {
			let b1 = CGPoint(x:p.x+margins,y:p.y-marginl)
			let b2 = CGPoint(x:p.x+margins,y:p.y-margins)
			let b3 = CGPoint(x:p.x+marginl,y:p.y-margins)
			line(b1,b2)
			line(b2,b3)
		}
		
		if o & 0o0010 > 0 {
			let c1 = CGPoint(x:p.x+margins,y:p.y+marginl)
			let c2 = CGPoint(x:p.x+margins,y:p.y+margins)
			let c3 = CGPoint(x:p.x+marginl,y:p.y+margins)
			line(c1,c2)
			line(c2,c3)
		}
		
		if o & 0o0001 > 0 {
			let d1 = CGPoint(x:p.x-margins,y:p.y+marginl)
			let d2 = CGPoint(x:p.x-margins,y:p.y+margins)
			let d3 = CGPoint(x:p.x-marginl,y:p.y+margins)
			line(d1,d2)
			line(d2,d3)
		}
	}
	
	
	private func line(p1:CGPoint, _ p2:CGPoint){
		let context:CGContextRef? =  UIGraphicsGetCurrentContext();//获取画笔上下文
		CGContextSetAllowsAntialiasing(context!, true) //抗锯齿设置
		//画直线
		CGContextMoveToPoint(context,  p1.x , p1.y);
		CGContextAddLineToPoint(context, p2.x, p2.y);
		CGContextStrokePath(context)
	}
	
}
