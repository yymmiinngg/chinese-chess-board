//
//  ChessBoard.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/19.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation
import UIKit

class ChessBoard : UIView{
	
	fileprivate var _points = [ChessPoint]()
	
	fileprivate var _marginX:CGFloat! // 横向的边距
	fileprivate var _marginY:CGFloat! // 纵向的边距
	fileprivate var _pointWidth:CGFloat! // 每个棋点的宽度
	
	fileprivate var _perWidth:CGFloat! // 每列的宽度
	fileprivate var _perHeight:CGFloat! // 每行宽度
	
	fileprivate var _bindChessViewList = [ChessView]()
	
	fileprivate var _focus:ChessFocus? // 焦点
	fileprivate var _pickedChessPoint:ChessPoint? // 举棋点
	fileprivate var _awkwardChess:ChessView? // 最后的尴尬棋子
	
	fileprivate var _hasShowEnding = false // 是否显示了结局
	
	var pickedChessPoint:ChessPoint? { return self._pickedChessPoint }
	var pointWidth:CGFloat { return _pointWidth }
	
	fileprivate var inited: Bool = false
	
	
	
	/// 初始化方法，在棋盘需要初始化的时候调用：将所有棋子归位，并抹去所有提示信息
	/// - parameter none
	/// - returns: void
	func doInit(){
		
		// 如果初始化过了就不重复初始化了
		if inited {
			return
		}
		
		droppickedChessPoint()
		clearChessFocus()
		clearChessAwkward()
		clearEndingTag()
		initChessViews()
		
		// 初始化棋点
		for i in 0..<_points.count {
			let p = _points[i]
			// 画棋点编号
			// let str:String = String(i)
			// str.draw(at: CGPoint(x: p.Point.x + 10, y: p.Point.y + 10), withAttributes: nil);
			p.doInit()
			self.addSubview(p)
		}
		
		inited = true
	}
	
	override func draw(_ rect: CGRect){
		
		let context:CGContext? = UIGraphicsGetCurrentContext();//获取画笔上下文
		context!.setAllowsAntialiasing(true) //抗锯齿设置
		
		_marginX = 16
		_perWidth = (rect.width - _marginX * 2) / 9
		_perHeight = _perWidth
		_marginY = (rect.height - (_perHeight * 10)) / 2
		
		_pointWidth = _perWidth - _perWidth / 20
		
		// 如果初始化过了就不重复初始化了
		if !inited {
			_points.removeAll()
			for j in 0..<10 {
				for i in 0..<9 {
					let x = _perWidth * CGFloat(i) + (_perWidth / 2) + _marginX
					let y = _perHeight * CGFloat(j) + (_perHeight / 2) + _marginY
					let p = ChessPoint(x:x, y:y, index: _points.count)
					_points.append(p)
				}
			}
		}
		
		// 绘制边框
		let rectangle = CGRect(x: 0, y: 0, width: frame.width, height: frame.height);
		let pathRect = rectangle.insetBy(dx: 4, dy: 0)
		let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 8)
		path.lineWidth = 1
		bgcolor_board.setFill()
		bordercolor_board.setStroke()
		path.fill()
		path.stroke()

		// 画棋盘线
		drawBoardLine(context, 2, color_board_line_shadow)
		drawBoardLine(context, 1, color_board_line)
		drawBoder(context, 3, color_board_line)
		drawLabel(1, color:color_board_label)
		drawLabel(2, color:color_board_label)
		drawLabel(3, color:color_board_label)
		drawLabel(4, color:color_board_label)
		
		doInit()
	}
	
	/// 拾起一个棋子
	/// - parameter chessPoint 要拾起的棋子
	/// - parameter stable 稳定的拾起
	/// - returns: void
	func pickChessPoint(_ chessPoint:ChessPoint!, stable: Bool) {
		self._pickedChessPoint = chessPoint
		self.showPointFocus(self._pickedChessPoint!, stable: stable)
	}
	
	/// 放下被拾起的棋子
	/// - parameter none
	/// - returns: void
	func droppickedChessPoint() {
		self._pickedChessPoint = nil
	}
	
	/// 初始化棋子摆放的位置
	/// - parameter none
	/// - returns: void
	func initChessViews(){
		// 清空所有棋点绑定的棋子
		for i in 0 ..< _points.count {
			_points[i].BindChessView = nil
		}
		// 清空所有棋子
		for i in 0..<_bindChessViewList.count {
			let BindChessView = _bindChessViewList[i]
			BindChessView.removeFromSuperview()
		}
		_bindChessViewList.removeAll()
		// 从象棋逻辑中取得所有现存棋子的位置并显示到棋盘上
		for i in 0..<chessLogic.chesses.count {
			if let role = chessLogic.chesses[i] {
				self.addChess(role, to:_points[i])
			}
		}
		// 将所有棋点置入前端(可以被用户点击到)
		bringChessPointToFront()
	}
	
	/// 将所有棋点置入前端(确保棋点可以被用户点击到)
	/// - parameter none
	/// - returns: void
	fileprivate func bringChessPointToFront(){
		for i in 0..<_points.count {
			let p = _points[i]
			self.bringSubviewToFront(p)
		}
	}
	
	/// 在历史步骤中后退一步棋
	/// - parameter step 步骤信息
	/// - returns: void
	func doBackwardChessStep(_ step: ChessStep){
		let srcPoint = _points[step.to]
		let toPoint = _points[step.src]
		moveChessView(srcPoint, to: toPoint, moveMessage:step.moveMessage, isFromBack:true)
		if let chess = step.toChess {
			self.addChess(chess, to: _points[step.to])
		}
	}
	
	/// 在历史步骤中前进一步棋
	/// - parameter step 步骤信息
	/// - returns: void
	func doForwardChessStep(_ step: ChessStep){
		let srcPoint = _points[step.src]
		let toPoint = _points[step.to]
		moveChessView(srcPoint, to: toPoint, moveMessage:step.moveMessage, isFromBack:false)
	}
	
	/// 移动棋子之后的一个动作，显示是否已经胜利，显示是否面临将军，将棋点移到棋子上方（确保能被点击到）
	/// - parameter none
	/// - returns: void
	func afterMoveChessView(){
		// 是否已经胜利
		if chessLogic.isEnded {
			if let winner = chessLogic.winner() {
				showEndingTag(winner)
				_hasShowEnding = true;
			}
		} else if(_hasShowEnding){
			clearEndingTag()
			_hasShowEnding = false
		}
		
		// 是否正要将军
		clearJiangJunAwkward()
		if let jj  = chessLogic.tryJiangJun() {
			if jj.0 || jj.1 {
				showJiangJunAwkward(black:jj.0, red:jj.1)
			}
		}
		
		// 将所有棋点置入前端(可以被用户点击到)
		bringChessPointToFront()
		
		droppickedChessPoint()
		clearChessFocus()
		clearChessAwkward()
	}
	
	/// 移动棋子，从起始点到目的点
	/// - parameter srcPoint 起始点
	/// - parameter toPoint 目的点
	/// - parameter moveMesssage 移动发生的消息
	/// - parameter srcPoint 是否来源于后退操作
	/// - returns: void
	func moveChessView(_ srcPoint:ChessPoint, to toPoint:ChessPoint, moveMessage: MoveMessage, isFromBack: Bool){
		// 如果目的点存在棋子则移除
		if toPoint.BindChessView != nil {
			toPoint.BindChessView!.removeFromSuperview()
		}
		
		// 将起始点棋子移动到目的点
		toPoint.BindChessView = srcPoint.BindChessView
		UIView.animate(withDuration: 0.15, animations: { () -> Void in
			toPoint.BindChessView!.drawView(toPoint.Point, width: board._pointWidth!)
		})
		srcPoint.BindChessView = nil
		
		// 处理杀棋列表
		if case let MoveMessage.success(killedChess) = moveMessage {
			if let kc = killedChess {
				 // 回退操作将棋子从杀棋列表移除
				if(isFromBack) {
					if kc.color {
						redKilledPanel.remove()
					}else{
						blackKilledPanel.remove()
					}
				}
				// 将棋子放入杀棋列表
				else{
					if kc.color {
						redKilledPanel.add(kc)
					}else{
						blackKilledPanel.add(kc)
					}
				}
			}
		}
	}
	
	/// 显示结局消息
	/// - parameter winnerColor 胜出者颜色
	/// - returns: void
	func showEndingTag(_ winnerColor:Bool){
		for i in 0..<_points.count {
			if let chess = _points[i].BindChessView?.chess {
				if chess.color == winnerColor {
					_points[i].BindChessView!.showTag(TagType.win)
				}
				else{
					_points[i].BindChessView!.showTag(TagType.lose)
				}
			}
		}
	}
	
	/// 清除结局消息
	/// - parameter none
	/// - returns: void
	func clearEndingTag () {
		for i in 0..<_points.count {
			if let BindChessView = _points[i].BindChessView {
				BindChessView.hideTag()
			}
		}
		_hasShowEnding = false
	}
	
	/// 指定棋子显示尴尬
	/// - parameter chessPoint 棋点
	/// - returns: void
	func showChessAwkward(_ chessPoint:ChessPoint){
		clearChessAwkward()
		_awkwardChess = chessPoint.BindChessView!
		_awkwardChess!.showTag(TagType.awkward)
	}
	
	/// 清除显示棋子尴尬
	/// - parameter none
	/// - returns: void
	func clearChessAwkward(){
		if _awkwardChess != nil {
			_awkwardChess!.hideTag()
			_awkwardChess = nil
		}
	}
	
	/// 显示将军的尴尬（通常在被将军的时候显示）
	/// - parameter black 黑将军是否显示
	/// - parameter red 红将军是否显示
	/// - returns: void
	fileprivate func showJiangJunAwkward(black:Bool, red:Bool){
		if black {
			if let jiang = chessLogic.getJiangPoint(true) {
				let p = _points[jiang]
				p.BindChessView!.showTag(TagType.awkward)
			}
		}
		if(red){
			if let jiang = chessLogic.getJiangPoint(false) {
				let p = _points[jiang]
				p.BindChessView!.showTag(TagType.awkward)
			}
		}
	}
	
	/// 清除将军的尴尬
	/// - parameter none
	/// - returns: void
	fileprivate func clearJiangJunAwkward(){
		if  let blackJiang = chessLogic.getJiangPoint(true) {
			if let blackPoint = _points[blackJiang].BindChessView {
				blackPoint.hideTag()
			}
		}
		if let redJiang = chessLogic.getJiangPoint(false) {
			if let redPoint = _points[redJiang].BindChessView {
				redPoint.hideTag()
			}
		}
	}
	
	/// 显示棋点的焦点
	/// - parameter point 棋点
	/// - parameter stable 突出焦点
	/// - returns: void
	func showPointFocus(_ point:ChessPoint, stable:Bool){
		if _focus != nil {
			_focus!.removeFromSuperview()
		}
		var color:UIColor
		if stable {
			color = color_focus_stable
		} else {
			color = color_focus_volatile
		}
		_focus = ChessFocus(point:point.Point, color: color)
		self.addSubview(_focus!)
	}
	
	/// 移除棋点的焦点
	/// - parameter none
	/// - returns: void
	fileprivate func clearChessFocus(){
		if _focus != nil {
			_focus!.removeFromSuperview()
		}
	}
	
	/// 增加一个棋子到指定棋点
	/// - parameter chess 棋子角色
	/// - parameter to 到哪个点
	/// - returns: void
	fileprivate func addChess(_ chess:Chess, to chessPoint:ChessPoint){
		let BindChessView = ChessView(chess:chess)
		chessPoint.BindChessView = BindChessView
		self.addSubview(chessPoint.BindChessView!)
		BindChessView.drawView(chessPoint.Point, width: self._pointWidth!)
		_bindChessViewList.append(chessPoint.BindChessView!)
	}
	
	/// 画棋盘线
	/// - parameter none
	/// - returns: void
	fileprivate func drawBoardLine(_ context:CGContext?, _ width:CGFloat, _ color:UIColor){
		
		context?.setLineWidth(width) //设置画笔宽度
		context?.setStrokeColor(color.cgColor)
		
		for i in 0 ..< 10 {
			let p1 = _points[i*9]
			let p2 = _points[i*9+8]
			line(p1.Point, p2.Point )
		}
		
		for i in 0 ..< 9 {
			let p1 = _points[i]
			let p2 = _points[i + 36]
			line(p1.Point ,p2.Point)
		}
		
		for i in 0 ..< 9 {
			let p1 = _points[i + 45]
			let p2 = _points[i + 81]
			line(p1.Point ,p2.Point)
		}
		
		let xpsa = _points[66]
		let xpsb = _points[68]
		let xpsc = _points[86]
		let xpsd = _points[84]
		line(xpsa.Point ,xpsc.Point)
		line(xpsb.Point ,xpsd.Point)
		
		let xpna = _points[3]
		let xpnb = _points[5]
		let xpnc = _points[23]
		let xpnd = _points[21]
		line(xpna.Point ,xpnc.Point)
		line(xpnb.Point ,xpnd.Point)
		
		let lbt = _points[36]
		let lbb = _points[45]
		let rbt = _points[44]
		let rbb = _points[53]
		line(lbt.Point ,lbb.Point)
		line(rbt.Point ,rbb.Point)
		
		drawAnchor(_points[19],0o1111)
		drawAnchor(_points[25],0o1111)
		
		drawAnchor(_points[27],0o0110)
		drawAnchor(_points[29],0o1111)
		drawAnchor(_points[31],0o1111)
		drawAnchor(_points[33],0o1111)
		drawAnchor(_points[35],0o1001)
		
		drawAnchor(_points[64],0o1111)
		drawAnchor(_points[70],0o1111)
		
		drawAnchor(_points[54],0o0110)
		drawAnchor(_points[56],0o1111)
		drawAnchor(_points[58],0o1111)
		drawAnchor(_points[60],0o1111)
		drawAnchor(_points[62],0o1001)
	}
	
	/// 画棋盘边框
	/// - parameter none
	/// - returns: void
	fileprivate func drawBoder (_ context:CGContext?, _ width:CGFloat, _ color:UIColor){
		context?.setLineWidth(width) //设置画笔宽度
		context?.setStrokeColor(color.cgColor)
		let pa = CGPoint( x: _points[0].Point.x - width*2, y: _points[0].Point.y - width*2)
		let pb = CGPoint( x: _points[8].Point.x + width*2, y: _points[8].Point.y - width*2)
		let pc = CGPoint( x: _points[89].Point.x + width*2, y: _points[89].Point.y + width*2)
		
		let rectangle = CGRect(x: pa.x, y: pa.y, width: pb.x - pa.x, height: pc.y - pb.y);
		let pathRect = rectangle.insetBy(dx: 0, dy: 0)
		let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 0)
		path.lineWidth = width
		UIColor.clear.setFill()
		color.setStroke()
		path.fill()
		path.stroke()
	}
	
	/// 画棋盘锚点
	/// - parameter none
	/// - returns: void
	fileprivate func drawAnchor(_ p:ChessPoint,_ o:Int){
		let margins:CGFloat = _perWidth / 16
		let marginl:CGFloat = _perWidth / 6
		
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
			line(d1, d2)
			line(d2, d3)
		}
	}
	
	/// 画象棋河界标签
	/// - parameter index 文字位置
	/// - parameter color 文字颜色
	/// - returns: void
	fileprivate func drawLabel(_ index:Int, color:UIColor) {
		let size = CGSize(width: self._pointWidth! * 0.6, height: self._pointWidth! * 0.6)
		// 象棋文字
		var revert:Bool!
		var p:CGPoint!
		var text:String!
		switch index {
		case 1:
			p = CGPoint(x: self.frame.size.width / 2 - self.frame.size.width / 4 - size.width, y: self.frame.size.height / 2 - size.height / 2)
			text = "楚"
			revert = false
		case 2:
			p = CGPoint(x: self.frame.size.width / 2 - self.frame.size.width / 4 + size.width, y: self.frame.size.height / 2 - size.height / 2)
			text = "河"
			revert = false
		case 3:
			p = CGPoint(x: self.frame.size.width / 2 + self.frame.size.width / 4 , y: self.frame.size.height / 2 - size.height / 2)
			text = "漢"
			revert = true
		case 4:
			p = CGPoint(x: self.frame.size.width / 2 + self.frame.size.width / 4 - size.width * 2, y: self.frame.size.height / 2 - size.height / 2)
			text = "界"
			revert = true
		default:
			break
		}
		let label:UILabel!
		label = UILabel(frame:CGRect(origin: p, size:size))
		label.textColor = color
		label.backgroundColor = UIColor.clear
		label.text = text
		label.textAlignment = NSTextAlignment.center
		label.adjustsFontSizeToFitWidth = true
		label.font = UIFont.systemFont(ofSize: size.width )
		
		// 象棋旋转角度
		if revert! {
		    label.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(Double.pi)/CGFloat(180));
		}
		self.addSubview(label)
	}
	
	/// 在棋盘上画线
	/// - parameter p1 起始点
	/// - parameter p2 结束点
	/// - returns: <#void#>
	fileprivate func line(_ p1:CGPoint, _ p2:CGPoint){
		let context:CGContext? =  UIGraphicsGetCurrentContext();//获取画笔上下文
		//画直线
		context?.move(to: CGPoint(x: p1.x, y: p1.y));
		context?.addLine(to: CGPoint(x: p2.x, y: p2.y));
		context?.strokePath()
	}
	
}
