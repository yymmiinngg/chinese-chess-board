//
//  MoveLogic.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/22.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation

enum MoveMessage{
	case FailSrcEmpty // 源点为空
	case FailToIsSrc // 落点与源点一至
	case FailSameColor // 相同颜色的棋子
	case FailCanNotReach // 不可到达位置
	case Success(Chess?) // 成功(被杀的棋子)
}

enum Chess  {
	
	case Bin(String,Bool),Pao(String,Bool),Che(String,Bool),Ma(String,Bool),Xiang(String,Bool),Shi(String,Bool),Jiang(String,Bool)
	
	var isBlack : Bool{
		switch self {
		case Bin(_, let _isBlack):
			return _isBlack
		case Pao(_, let _isBlack):
			return _isBlack
		case Che(_, let _isBlack):
			return _isBlack
		case Ma(_, let _isBlack):
			return _isBlack
		case Xiang(_, let _isBlack):
			return _isBlack
		case Shi(_, let _isBlack):
			return _isBlack
		case Jiang(_, let _isBlack):
			return _isBlack
		}
	}
	
	var name : String{
		switch self {
		case Bin(let name, _):
			return name
		case Pao(let name, _):
			return name
		case Che(let name, _):
			return name
		case Ma(let name, _):
			return name
		case Xiang(let name, _):
			return name
		case Shi(let name, _):
			return name
		case Jiang(let name, _):
			return name
		}
	}
	
}

struct ChessStep {
	var src:Int
	var srcChess:Chess
	var to:Int
	var toChess:Chess?
	var moveMessage:MoveMessage
}

class ChessLogic {
	
	var chesses = [Chess?](count: 90, repeatedValue: nil)
	
	var chessStepList  = [ChessStep]()
	var killedChesses  = [Chess]()
	var backIndex = 0
	
	var isBlackGo = false
	var ended = false
	
	func back() -> ChessStep? {
		if chessStepList.count - backIndex - 1 >= 0 {
			let chessStep = chessStepList[chessStepList.count - backIndex - 1]
			backIndex += 1
			chesses[chessStep.src] = chessStep.srcChess
			chesses[chessStep.to] = chessStep.toChess
			if chessStep.toChess != nil {
				killedChesses.removeLast()
			}
			isBlackGo = chessStep.srcChess.isBlack
			ended = false
			return chessStep
		}
		return nil
	}
	
	func go() -> ChessStep? {
		if backIndex >  0 {
			// print ("\(chessStepList.count) - \(backIndex)")
			let chessStep = chessStepList[chessStepList.count - backIndex]
			backIndex -= 1
			chesses[chessStep.src] = chessStep.srcChess
			chesses[chessStep.to] = chessStep.toChess
			chesses[chessStep.to] = chesses[chessStep.src]
			chesses[chessStep.src] = nil
			if chessStep.toChess != nil {
				killedChesses.append(chessStep.toChess!)
				if case Chess.Jiang(_, _) = chessStep.toChess! {
					ended = true
				}
			}
			isBlackGo = !chessStep.srcChess.isBlack
			return chessStep
		}
		return nil
	}
	
	/// 这里是移动棋子的逻辑
	/// 返回 (移动是否成功，是否吃子，是否将军)
	func moveChess (src:Int, to:Int) -> MoveMessage {
		let srcIsBlack = chesses[src]?.isBlack
		let toIsBlack = chesses[to]?.isBlack
		
		if chesses[src] == nil {
			return  MoveMessage.FailSrcEmpty
		}
		if src == to {
			return  MoveMessage.FailToIsSrc
		}
		if srcIsBlack == toIsBlack {
			return  MoveMessage.FailSameColor
		}
		
		if !tryMove(src, to:to) {
			return  MoveMessage.FailCanNotReach
		}
		
		print (backIndex)
		if backIndex > 0 {
			for _ in 0 ..< backIndex {
				chessStepList.removeLast()
			}
			backIndex = 0
		}
		
		let srcChess = chesses[src]!
		let toChess = chesses[to]
		
		chesses[to] = chesses[src]
		chesses[src] = nil
		
		let moveMessage = MoveMessage.Success(toChess)
		
		chessStepList.append(ChessStep(src: src, srcChess: srcChess, to: to, toChess: toChess, moveMessage:moveMessage))
		if toChess != nil {
			if case Chess.Jiang(_, _) = toChess! {
				ended = true
			}
			killedChesses.append(toChess!)
		}
		isBlackGo = !srcChess.isBlack
		
		return moveMessage
	}
	
	func tryJiangJun() -> (Bool, Bool)? {
		let blackJiangPoint = getJiangPoint(true)
		let redJiangPoint = getJiangPoint(false)
		if(blackJiangPoint == nil || redJiangPoint == nil){
			return nil
		}
		var blackJiangJun = false
		var redJiangJun = false
		for i in 0..<chesses.count {
			if let p = chesses[i] {
				let chessColor = p.isBlack
				if !blackJiangJun && !chessColor {
					if tryMove(i, to:blackJiangPoint!) {
						blackJiangJun = true
					}
				}
				if !redJiangJun && chessColor {
					if tryMove(i, to:redJiangPoint!) {
						redJiangJun = true
					}
				}
			}
		}
		return (blackJiangJun, redJiangJun)
	}
	
	func winner() -> Bool? {
		if nil == getJiangPoint(true) {
			return false
		}
		if nil == getJiangPoint(false) {
			return true
		}
		return nil
	}
	
	  func getJiang(jiangIsBlack:Bool ) -> Chess? {
		let i = getJiangPoint(jiangIsBlack)
		if nil == i {return nil}
		return chesses[i!]
	}
	
	  func getJiangPoint(jiangIsBlack:Bool ) -> Int? {
		var mayto = [3,4,5,12,13,14,21,22,23]
		for i in 0..<mayto.count{
			let p = mayto[i] + (jiangIsBlack ? 0 : 63)
			if case Chess.Jiang(_)? = chesses[p]  {
				if jiangIsBlack == chesses[p]?.isBlack {
					return p
				}
			}
		}
		return nil
	}
	
	private func tryMove(src:Int, to:Int) -> Bool{
		var result:Bool = false
		
		let isBlack = chesses[src]!.isBlack
		
		switch chesses[src]! {
		case Chess.Bin:
			result = self.moveBin(src, to:to, isBlack: isBlack)
		case Chess.Pao:
			result = self.movePao(src, to:to, isBlack: isBlack)
		case Chess.Che:
			result = self.moveChe(src, to:to, isBlack: isBlack)
		case Chess.Ma:
			result = self.moveMa(src, to:to, isBlack: isBlack)
		case Chess.Xiang:
			result = self.moveXiang(src, to:to, isBlack: isBlack)
		case Chess.Shi:
			result = self.moveShi(src, to:to, isBlack: isBlack)
		case Chess.Jiang:
			result = self.moveJiang(src, to:to, isBlack: isBlack)
		}
		
		return result
	}
	
	
	private func moveJiang(src:Int, to:Int, isBlack:Bool) -> Bool{
		
		if chesses[to] != nil {
			if case Chess.Jiang(_) = chesses[to]! {
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
	
	private func moveShi(src:Int, to:Int, isBlack:Bool) -> Bool{
		var m = 13
		var abcd = [3,5,21,23]
		if(to > 45) {
			m += 63
			for i in 0..<abcd.count{
				abcd[i] = abcd[i] + 63
			}
		}
		return (abcd.contains(src) && to == m ) || (abcd.contains(to) && src == m )
	}
	
	private func moveXiang(src:Int, to:Int, isBlack:Bool) -> Bool{
		var rs:[(Int,Int)] = []
		rs.append((src - 18 - 2, src - 9 - 1))
		rs.append((src - 18 + 2, src - 9 + 1))
		rs.append((src + 18 - 2, src + 9 - 1))
		rs.append((src + 18 + 2, src + 9 + 1))
		
		for i in 0..<rs.count {
			let r = rs[i]
			let mayto = r.0
			let obstacle = r.1
			if(to == mayto && chesses[obstacle] == nil ){
				return Int(src / 45) == Int(to / 45)
			}
		}
		return false
	}
	
	private func moveMa(src:Int, to:Int, isBlack:Bool) -> Bool{
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
			if(to == mayto && chesses[obstacle] == nil ){
				return true
			}
		}
		
		return false
	}
	
	private func moveChe(src:Int, to:Int, isBlack:Bool) -> Bool{
		let count = countOfObstacle(src, to)
		if count != 0 {
			return false
		}
		return true
	}
	
	private func movePao(src:Int, to:Int, isBlack:Bool) -> Bool{
		let count = countOfObstacle(src, to)
		if chesses[to] == nil && count != 0 {
			return false
		}
		if chesses[to] != nil && count != 1 {
			return false
		}
		return true
	}
	
	
	private func countOfObstacle(src:Int, _ to:Int) -> Int{
		let horizontal = Int(src / 9) == Int(to / 9) // 水平移动
		let vertical = abs(src - to) % 9 == 0 // 垂直移动
		if !horizontal && !vertical {
			return -1
		}
		var count = 0
		let a = src < to ? src : to
		let b = src < to ? to : src
		let step = (horizontal ? 1 : 9)
		for var i = a + step; i < b ; i += step {
			if chesses[i] != nil {
				count += 1
			}
		}
		return count
	}
	
	private func moveBin(var src:Int, var to:Int, isBlack:Bool) -> Bool{
		if !isBlack{
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
	
	func doInit(){
		chesses.removeAll()
		chesses = [Chess?](count: 90, repeatedValue: nil)
		// chesses.removeAll(keepCapacity: true)
		chessStepList  .removeAll()
		killedChesses  .removeAll()
		backIndex = 0
		
		isBlackGo = false
		ended = false
		
		chesses[0] =  Chess.Che("車", true)
		chesses[1] = Chess.Ma("馬",true)
		chesses[2] = Chess.Xiang("象",true)
		chesses[3] = Chess.Shi("士",true)
		chesses[4] = Chess.Jiang("將",true)
		chesses[5] = Chess.Shi("士",true)
		chesses[6] = Chess.Xiang("象",true)
		chesses[7] = Chess.Ma("馬",true)
		chesses[8] = Chess.Che("車",true)
		
		chesses[19] = Chess.Pao("炮",true)
		chesses[25] = Chess.Pao("炮",true)
		
		chesses[27] = Chess.Bin("卒",true)
		chesses[29] = Chess.Bin("卒",true)
		chesses[31] = Chess.Bin("卒",true)
		chesses[33] = Chess.Bin("卒",true)
		chesses[35] = Chess.Bin("卒",true)
		
		chesses[54] = Chess.Bin("兵",false)
		chesses[56] = Chess.Bin("兵",false)
		chesses[58] = Chess.Bin("兵",false)
		chesses[60] = Chess.Bin("兵",false)
		chesses[62] = Chess.Bin("兵",false)
		
		chesses[64] = Chess.Pao("砲",false)
		chesses[70] =  Chess.Pao("砲",false)
		
		chesses[81] = Chess.Che("車",false)
		chesses[82] = Chess.Ma("馬",false)
		chesses[83] = Chess.Xiang("相",false)
		chesses[84] = Chess.Shi("仕",false)
		chesses[85] = Chess.Jiang("帥",false)
		chesses[86] = Chess.Shi("仕",false)
		chesses[87] = Chess.Xiang("相",false)
		chesses[88] = Chess.Ma("馬",false)
		chesses[89] = Chess.Che("車",false)
	}
	
	
	init(){
		doInit()
	}
}