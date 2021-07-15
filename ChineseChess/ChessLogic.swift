//
//  MoveLogic.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/22.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation

enum MoveMessage{
	case failSrcEmpty // 源点为空
	case failToIsSrc // 落点与源点一至
	case failSameColor // 相同颜色的棋子
	case failCanNotReach // 不可到达位置
	case success(Chess?) // 成功(被杀的棋子)
}

/// 棋子角色
enum Chess  {
	
	case bin(String,Bool),pao(String,Bool),che(String,Bool),ma(String,Bool),xiang(String,Bool),shi(String,Bool),jiang(String,Bool)
	
	/// 棋子的颜色：true黑色，false红色
	var color : Bool{
		switch self {
		case .bin(_, let _color):
			return _color
		case .pao(_, let _color):
			return _color
		case .che(_, let _color):
			return _color
		case .ma(_, let _color):
			return _color
		case .xiang(_, let _color):
			return _color
		case .shi(_, let _color):
			return _color
		case .jiang(_, let _color):
			return _color
		}
	}
	
	/// 棋子名称
	var name : String{
		switch self {
		case .bin(let name, _):
			return name
		case .pao(let name, _):
			return name
		case .che(let name, _):
			return name
		case .ma(let name, _):
			return name
		case .xiang(let name, _):
			return name
		case .shi(let name, _):
			return name
		case .jiang(let name, _):
			return name
		}
	}
	
}

/// 行棋的步骤
struct ChessStep {
	var src:Int
	var srcChess:Chess
	var to:Int
	var toChess:Chess?
	var moveMessage:MoveMessage
}

/// 象棋的逻辑（包含各种角色的行棋、前进、后退和试将等操作）
class ChessLogic {
	
	// 棋子列表
	fileprivate var _chesses = [Chess?](repeating: nil, count: 90)
	var chesses:[Chess?] { return _chesses }
	
	fileprivate var _chessStepList = [ChessStep]() // 步骤列表
	fileprivate var _killedChesses = [Chess]() // 杀棋列表
	fileprivate var _backCount = 0 // 回退步骤数
	
	// 下一次行棋的颜色
	fileprivate var _nextColor = false
	var nextColor:Bool { return _nextColor }
	
	// 是否已经结束
	fileprivate var _isEnded = false
	var isEnded:Bool { return _isEnded }
	
	/// 悔棋后退
	/// - parameter none
	/// - returns: 行棋步骤（nil表示无棋可悔）
	func backward() -> ChessStep? {
		if _chessStepList.count - _backCount - 1 >= 0 {
			let chessStep = _chessStepList[_chessStepList.count - _backCount - 1]
			_backCount += 1
			_chesses[chessStep.src] = chessStep.srcChess
			_chesses[chessStep.to] = chessStep.toChess
			if chessStep.toChess != nil {
				_killedChesses.removeLast()
			}
			_nextColor = chessStep.srcChess.color
			_isEnded = false
			return chessStep
		}
		return nil
	}
	
	/// 悔棋前进
	/// - parameter none
	/// - returns: 行棋步骤（nil表示已经无步骤可行）
	func forward() -> ChessStep? {
		if _backCount >  0 {
			let chessStep = _chessStepList[_chessStepList.count - _backCount]
			_backCount -= 1
			_chesses[chessStep.src] = chessStep.srcChess
			_chesses[chessStep.to] = chessStep.toChess
			_chesses[chessStep.to] = _chesses[chessStep.src]
			_chesses[chessStep.src] = nil
			if chessStep.toChess != nil {
				_killedChesses.append(chessStep.toChess!)
				if case Chess.jiang(_, _) = chessStep.toChess! {
					_isEnded = true
				}
			}
			_nextColor = !chessStep.srcChess.color
			return chessStep
		}
		return nil
	}
	
	/// 行棋逻辑
	/// - parameter src 从哪点出发
	/// - parameter to 去到哪点
	/// - returns: MoveMessage 移动是否成功，是否吃子
	func moveChess (_ src:Int, to:Int) -> MoveMessage {
		let srcColor = _chesses[src]?.color
		let toColor = _chesses[to]?.color
		// 起点为空
		if _chesses[src] == nil {
			return  MoveMessage.failSrcEmpty
		}
		// 起点与终点一致
		if src == to {
			return  MoveMessage.failToIsSrc
		}
		// 起点与终点颜色一样
		if srcColor == toColor {
			return  MoveMessage.failSameColor
		}
		// 试着移动
		if !tryMove(src, to:to) {
			// 不可达到
			return  MoveMessage.failCanNotReach
		}
		
		// 一旦行棋成功则需要将回退过的行棋步骤清除
		if _backCount > 0 {
			for _ in 0 ..< _backCount {
				_chessStepList.removeLast()
			}
			_backCount = 0
		}
		
		// 临时保存
		let srcChess = _chesses[src]!
		let toChess = _chesses[to]
		
		// 落子
		_chesses[to] = _chesses[src]
		_chesses[src] = nil
		
		// 行棋消息为成功
		let moveMessage = MoveMessage.success(toChess)
		
		// 行棋步骤中增加一步成功的行棋
		_chessStepList.append(ChessStep(src: src, srcChess: srcChess, to: to, toChess: toChess, moveMessage:moveMessage))
		if toChess != nil {
			if case Chess.jiang(_, _) = toChess! {
				_isEnded = true
			}
			_killedChesses.append(toChess!)
		}
		
		// 下一个行棋的颜色
		_nextColor = !srcChess.color
		
		return moveMessage
	}
	
	/// 试将：判断是否面临将军的危险
	/// - parameter none
	/// - returns: (黑将, 红将) 是否有危险
	func tryJiangJun() -> (Bool, Bool)? {
		let blackJiangPoint = getJiangPoint(true) // 黑将
		let redJiangPoint = getJiangPoint(false) // 红将
		if(blackJiangPoint == nil || redJiangPoint == nil){
			return nil
		}
		
		var blackJiangJun = false // 黑将被将军
		var redJiangJun = false // 红将被将军
		
		// 遍历棋盘上的所有棋子角色
		for i in 0..<_chesses.count {
			if let p = _chesses[i] {
				let chessColor = p.color
				// 试着将所有红棋去吃黑将军
				if !blackJiangJun && !chessColor {
					if tryMove(i, to:blackJiangPoint!) {
						blackJiangJun = true
					}
				}
				// 试着将所有黑棋去吃红将军
				if !redJiangJun && chessColor {
					if tryMove(i, to:redJiangPoint!) {
						redJiangJun = true
					}
				}
			}
		}
		// 返回 (黑将, 红将)
		return (blackJiangJun, redJiangJun)
	}
	
	/// 胜出者
	/// - parameter none
	/// - returns: 返回胜出者的颜色
	func winner() -> Bool? {
		if nil == getJiangPoint(true) {
			return false
		}
		if nil == getJiangPoint(false) {
			return true
		}
		return nil
	}
	
	/// 获得将棋角色
	/// - parameter 要获得的将棋颜色
	/// - returns: nil表示被杀
	func getJiang(_ color:Bool) -> Chess? {
		let i = getJiangPoint(color)
		if nil == i {return nil}
		return _chesses[i!]
	}
	
	/// 获得将棋所在棋点
	/// - parameter none
	/// - returns: nil表示将已经被杀
	func getJiangPoint(_ color:Bool) -> Int? {
		let mayto = [3,4,5,12,13,14,21,22,23]
		for i in 0..<mayto.count{
			let p = mayto[i] + (color ? 0 : 63)
			if case Chess.jiang(_,_)? = _chesses[p]  {
				if color == _chesses[p]?.color {
					return p
				}
			}
		}
		return nil
	}
	
	/// 试着移动棋子
	/// - parameter src 出发点
	/// - parameter to 目的点
	/// - returns: 是否成功
	fileprivate func tryMove(_ src:Int, to:Int) -> Bool {
		var result:Bool = false
		let color = _chesses[src]!.color
		switch _chesses[src]! {
		case Chess.bin:
			result = self.moveBin(src, to:to, color: color)
		case Chess.pao:
			result = self.movePao(src, to:to, color: color)
		case Chess.che:
			result = self.moveChe(src, to:to, color: color)
		case Chess.ma:
			result = self.moveMa(src, to:to, color: color)
		case Chess.xiang:
			result = self.moveXiang(src, to:to, color: color)
		case Chess.shi:
			result = self.moveShi(src, to:to, color: color)
		case Chess.jiang:
			result = self.moveJiang(src, to:to, color: color)
		}
		return result
	}
	
	/// 移动将军
	/// - parameter src 出发点
	/// - parameter to 目的点
	/// - returns: 是否移动成功
	fileprivate func moveJiang(_ src:Int, to:Int, color:Bool) -> Bool {
		if _chesses[to] != nil {
			if case Chess.jiang(_,_) = _chesses[to]! {
				let count = countOfObstacle(src, to)
				if count == 0 {
					return true
				}
			}
		}
		var mayto = [3,4,5,12,13,14,21,22,23]
		if(to > 44) {
			for i in 0..<mayto.count{
				mayto[i] = mayto[i] + 63
			}
		}
		if !mayto.contains(to) {
			return false
		}
		return (to == src - 1 || to == src + 1 || to == src - 9 || to == src + 9)
	}
	
	/// 移动士
	/// - parameter src 出发点
	/// - parameter to 目的点
	/// - returns: 是否移动成功
	fileprivate func moveShi(_ src:Int, to:Int, color:Bool) -> Bool {
		var m = 13
		var abcd = [3,5,21,23]
		if(to > 45) {
			m += 63
			for i in 0..<abcd.count{
				abcd[i] = abcd[i] + 63
			}
		}
		return (abcd.contains(src) && to == m ) || (abcd.contains(to) && src == m)
	}
	
	/// 移动象
	/// - parameter src 出发点
	/// - parameter to 目的点
	/// - returns: 是否移动成功
	fileprivate func moveXiang(_ src:Int, to:Int, color:Bool) -> Bool{
		var rs:[(Int,Int)] = []
		rs.append((src - 18 - 2, src - 9 - 1))
		rs.append((src - 18 + 2, src - 9 + 1))
		rs.append((src + 18 - 2, src + 9 - 1))
		rs.append((src + 18 + 2, src + 9 + 1))
		
		for i in 0..<rs.count {
			let r = rs[i]
			let mayto = r.0
			let obstacle = r.1
			if(to == mayto && _chesses[obstacle] == nil ){
				return Int(src / 45) == Int(to / 45)
			}
		}
		return false
	}
	
	/// 移动马
	/// - parameter src 出发点
	/// - parameter to 目的点
	/// - returns: 是否移动成功
	fileprivate func moveMa(_ src:Int, to:Int, color:Bool) -> Bool{
		var rs:[(Int,Int)] = []
		rs.append((src - 18 - 1, src - 9))
		rs.append((src - 18 + 1, src - 9))
		rs.append((src + 18 - 1, src + 9))
		rs.append((src + 18 + 1, src + 9))
		rs.append((src - 9 - 2, src - 1))
		rs.append((src - 9 + 2, src + 1))
		rs.append((src + 9 - 2, src - 1))
		rs.append((src + 9 + 2, src + 1))
		
		for i in 0..<rs.count {
			let r = rs[i]
			let mayto = r.0
			let obstacle = r.1
			if(to == mayto && _chesses[obstacle] == nil ){
				return true
			}
		}
		
		return false
	}
	
	/// 移动车
	/// - parameter src 出发点
	/// - parameter to 目的点
	/// - returns: 是否移动成功
	fileprivate func moveChe(_ src:Int, to:Int, color:Bool) -> Bool{
		let count = countOfObstacle(src, to)
		if count != 0 {
			return false
		}
		return true
	}
	
	/// 移动炮
	/// - parameter src 出发点
	/// - parameter to 目的点
	/// - returns: 是否移动成功
	fileprivate func movePao(_ src:Int, to:Int, color:Bool) -> Bool{
		let count = countOfObstacle(src, to)
		if _chesses[to] == nil && count != 0 {
			return false
		}
		if _chesses[to] != nil && count != 1 {
			return false
		}
		return true
	}
	
	/// 移动兵
	/// - parameter src 出发点
	/// - parameter to 目的点
	/// - returns: 是否移动成功
	private func moveBin(_ src:Int, to:Int, color:Bool) -> Bool{
		var src = src, to = to
		if !color{
			src = 90 - src
			to = 90 - to
		}
		if abs(src - to) != 1 && to - src != 9 {
			return false
		}
		if src < 45 && to != src + 9 {
			return false
		}
		if src == 45 && to < src {
			return false
		}
		return true
	}
	
	/// 两点之间的障碍棋子数量
	/// - parameter src 出发点
	/// - parameter to 目的点
	/// - returns: nil表示两点不是水平或垂直相连的
	fileprivate func countOfObstacle(_ p1:Int, _ p2:Int) -> Int {
		let horizontal = Int(p1 / 9) == Int(p2 / 9) // 水平移动
		let vertical = abs(p1 - p2) % 9 == 0 // 垂直移动
		if !horizontal && !vertical {
			return -1
		}
		var count = 0
		var step = (horizontal ? 1 : 9)
		if p1 > p2 {
			step = -step
		}
		// 计算障碍数量
		for i in stride(from: p1 + step, through: p2 - step, by: step) {
			if _chesses[i] != nil {
				count += 1
			}
		}
		return count
	}
	
	func doInit(){
		_chesses.removeAll()
		_chesses = [Chess?](repeating: nil, count: 90)
		_chessStepList.removeAll()
		_killedChesses.removeAll()
		_backCount = 0
		
		_nextColor = false
		_isEnded = false
		
		_chesses[0] =  Chess.che("車", true)
		_chesses[1] = Chess.ma("馬",true)
		_chesses[2] = Chess.xiang("象",true)
		_chesses[3] = Chess.shi("士",true)
		_chesses[4] = Chess.jiang("將",true)
		_chesses[5] = Chess.shi("士",true)
		_chesses[6] = Chess.xiang("象",true)
		_chesses[7] = Chess.ma("馬",true)
		_chesses[8] = Chess.che("車",true)
		
		_chesses[19] = Chess.pao("炮",true)
		_chesses[25] = Chess.pao("炮",true)
		
		_chesses[27] = Chess.bin("卒",true)
		_chesses[29] = Chess.bin("卒",true)
		_chesses[31] = Chess.bin("卒",true)
		_chesses[33] = Chess.bin("卒",true)
		_chesses[35] = Chess.bin("卒",true)
		
		_chesses[54] = Chess.bin("兵",false)
		_chesses[56] = Chess.bin("兵",false)
		_chesses[58] = Chess.bin("兵",false)
		_chesses[60] = Chess.bin("兵",false)
		_chesses[62] = Chess.bin("兵",false)
		
		_chesses[64] = Chess.pao("砲",false)
		_chesses[70] =  Chess.pao("砲",false)
		
		_chesses[81] = Chess.che("車",false)
		_chesses[82] = Chess.ma("馬",false)
		_chesses[83] = Chess.xiang("相",false)
		_chesses[84] = Chess.shi("仕",false)
		_chesses[85] = Chess.jiang("帥",false)
		_chesses[86] = Chess.shi("仕",false)
		_chesses[87] = Chess.xiang("相",false)
		_chesses[88] = Chess.ma("馬",false)
		_chesses[89] = Chess.che("車",false)
	}
	
	
	init(){
		doInit()
	}
}
