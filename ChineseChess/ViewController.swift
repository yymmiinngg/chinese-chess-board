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
		
		board.backgroundColor = UIColor.clear
		blackKilledPanel.backgroundColor = UIColor.clear
		redKilledPanel.backgroundColor = UIColor.clear
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
		blackKilledPanel.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(Double.pi)/CGFloat(180));
	}
	
	/// 注册手势：回退，前进
	/// - parameter none
	/// - returns: void
	fileprivate func registBackAndGo() {
		//红棋死子面板
		//右划
		let redSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipeGesture(_:)))
		redSwipeGesture.numberOfTouchesRequired = 1
		redKilledPanel.addGestureRecognizer(redSwipeGesture)
		//左划
		let redSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipeGesture(_:)))
		redSwipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left //不设置是右
		redSwipeLeftGesture.numberOfTouchesRequired = 1
		redKilledPanel.addGestureRecognizer(redSwipeLeftGesture)
		//黑棋死子面板
		//右划
		let blackSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipeGesture(_:)))
		blackSwipeGesture.numberOfTouchesRequired = 1
		blackKilledPanel.addGestureRecognizer(blackSwipeGesture)
		//左划
		let blackSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipeGesture(_:)))
		blackSwipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left //不设置是右
		blackSwipeLeftGesture.numberOfTouchesRequired = 1
		blackKilledPanel.addGestureRecognizer(blackSwipeLeftGesture)
	}
	
	/// 注册手势：回退，前进 到边界
	/// - parameter <#none#>
	/// - returns: <#void#>
	fileprivate func registBackAndGo2Bound() {
		//红棋死子面板
		//右划
		let redSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipeGesture(_:)))
		redSwipeGesture.numberOfTouchesRequired = 2
		redKilledPanel.addGestureRecognizer(redSwipeGesture)
		//左划
		let redSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipeGesture(_:)))
		redSwipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left //不设置是右
		redSwipeLeftGesture.numberOfTouchesRequired = 2
		redKilledPanel.addGestureRecognizer(redSwipeLeftGesture)
		//黑棋死子面板
		//右划
		let blackSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipeGesture(_:)))
		blackSwipeGesture.numberOfTouchesRequired = 2
		blackKilledPanel.addGestureRecognizer(blackSwipeGesture)
		//左划
		let blackSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipeGesture(_:)))
		blackSwipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left //不设置是右
		blackSwipeLeftGesture.numberOfTouchesRequired = 2
		blackKilledPanel.addGestureRecognizer(blackSwipeLeftGesture)
	}
	
	/// 划动手势
	@objc func handleSwipeGesture(_ sender: UISwipeGestureRecognizer){
		//划动的方向
		let direction = sender.direction
		//判断是上下左右
		switch (direction){
		case UISwipeGestureRecognizer.Direction.left:
			if sender.numberOfTouches == 1 {
				if let chessStep = chessLogic.backward() {
					board.doBackwardChessStep(chessStep, true)
				}
			} else if sender.numberOfTouches == 2 {
				while let chessStep = chessLogic.backward() {
					board.doBackwardChessStep(chessStep, false)
				}
			}
			board.afterMoveChessView()
		case UISwipeGestureRecognizer.Direction.right:
			if sender.numberOfTouches == 1 {
				if let chessStep = chessLogic.forward() {
					board.doForwardChessStep(chessStep, true)
				}
			} else if sender.numberOfTouches == 2 {
				while let chessStep = chessLogic.forward() {
					board.doForwardChessStep(chessStep, false)
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
	override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.portrait
	}
	
	// 不显示信号栏
	override var prefersStatusBarHidden:Bool{
		return true
	}
	
}

