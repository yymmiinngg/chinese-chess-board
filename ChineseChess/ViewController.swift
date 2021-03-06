//
//  ViewController.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/19.
//  Copyright © 2016年 姚明. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIActionSheetDelegate{
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// 初始化背景颜色
//		board.backgroundColor = bgcolor_board
//		blackKilledPanel.backgroundColor = bgcolor_blackKilledPanel
//		redKilledPanel.backgroundColor = bgcolor_redKilledPanel
		
		board.backgroundColor = UIColor.clearColor()
		blackKilledPanel.backgroundColor = UIColor.clearColor()
		redKilledPanel.backgroundColor = UIColor.clearColor()
 		view.backgroundColor = bgcolor
		
		// 将各种面板加入到场景
		view.addSubview(board)
		view.addSubview(blackKilledPanel)
		view.addSubview(redKilledPanel)
		
		registBackAndGo()
		registBackAndGo2Bound()
	}
	
	override func viewDidLayoutSubviews() {
		
		let width = screenBounds.width
		let height =  screenBounds.height
		let boardHeight = width / 9 * 10 - 8 // 棋盘调试是宽度的10/9倍
		
		// 设置面板的框架
		let killPanelHeight = (height - boardHeight) / 2
		
		board.frame = CGRect(x: 0, y: killPanelHeight, width: width, height: boardHeight)
		blackKilledPanel.frame = CGRect(x: 0, y: 0, width: width , height: killPanelHeight)
		redKilledPanel.frame = CGRect(x: 0, y:  killPanelHeight + boardHeight, width: width , height: killPanelHeight)
		
		// 黑棋死子面板需要转换角度（因为对手是在对面）
		blackKilledPanel.transform = CGAffineTransformMakeRotation(180 * CGFloat(M_PI)/CGFloat(180));
	}
	
	/// 注册手势：回退，前进
	/// - parameter none
	/// - returns: void
	private func registBackAndGo() {
		//红棋死子面板
		//右划
		let redSwipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
		redSwipeGesture.numberOfTouchesRequired = 1
		redKilledPanel.addGestureRecognizer(redSwipeGesture)
		//左划
		let redSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
		redSwipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
		redSwipeLeftGesture.numberOfTouchesRequired = 1
		redKilledPanel.addGestureRecognizer(redSwipeLeftGesture)
		//黑棋死子面板
		//右划
		let blackSwipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
		blackSwipeGesture.numberOfTouchesRequired = 1
		blackKilledPanel.addGestureRecognizer(blackSwipeGesture)
		//左划
		let blackSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
		blackSwipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
		blackSwipeLeftGesture.numberOfTouchesRequired = 1
		blackKilledPanel.addGestureRecognizer(blackSwipeLeftGesture)
	}
	
	/// 注册手势：回退，前进 到边界
	/// - parameter <#none#>
	/// - returns: <#void#>
	private func registBackAndGo2Bound() {
		//红棋死子面板
		//右划
		let redSwipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
		redSwipeGesture.numberOfTouchesRequired = 2
		redKilledPanel.addGestureRecognizer(redSwipeGesture)
		//左划
		let redSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
		redSwipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
		redSwipeLeftGesture.numberOfTouchesRequired = 2
		redKilledPanel.addGestureRecognizer(redSwipeLeftGesture)
		//黑棋死子面板
		//右划
		let blackSwipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
		blackSwipeGesture.numberOfTouchesRequired = 2
		blackKilledPanel.addGestureRecognizer(blackSwipeGesture)
		//左划
		let blackSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
		blackSwipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
		blackSwipeLeftGesture.numberOfTouchesRequired = 2
		blackKilledPanel.addGestureRecognizer(blackSwipeLeftGesture)
	}
	
	/// 划动手势
	func handleSwipeGesture(sender: UISwipeGestureRecognizer){
		//划动的方向
		let direction = sender.direction
		//判断是上下左右
		switch (direction){
		case UISwipeGestureRecognizerDirection.Left:
			if sender.numberOfTouches() == 1 {
				if let chessStep = chessLogic.backward() {
					board.doBackwardChessStep(chessStep)
				}
			} else if sender.numberOfTouches() == 2 {
				while let chessStep = chessLogic.backward() {
					board.doBackwardChessStep(chessStep)
				}
			}
			board.afterMoveChessView()
		case UISwipeGestureRecognizerDirection.Right:
			if sender.numberOfTouches() == 1 {
				if let chessStep = chessLogic.forward() {
					board.doForwardChessStep(chessStep)
				}
			} else if sender.numberOfTouches() == 2 {
				while let chessStep = chessLogic.forward() {
					board.doForwardChessStep(chessStep)
				}
			}
			board.afterMoveChessView()
		default:
			break;
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// 不转屏
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.Portrait
	}
	
	// 不显示信号栏
	override func prefersStatusBarHidden()->Bool{
		return true
	}
	
}

