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
		
		board.backgroundColor = bgcolor_board
		blackKilledPanel.backgroundColor = bgcolor_blackKilledPanel
		redKilledPanel.backgroundColor = bgcolor_redKilledPanel
		// ctrlPanel.backgroundColor = UIColor.redColor()
		
		// view.addSubview(ctrlPanel)
		view.addSubview(board)
		view.addSubview(blackKilledPanel)
		view.addSubview(redKilledPanel)
		
		
		//旋转手势:按住option按钮配合鼠标来做这个动作在虚拟器上
		let rotateGesture = UIRotationGestureRecognizer(target: self, action: "handleRotateGesture:")
		self.view.addGestureRecognizer(rotateGesture)
		
		//划动手势
		//右划
		let redSwipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
		redKilledPanel.addGestureRecognizer(redSwipeGesture)
		//左划
		let redSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
		redSwipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
		redKilledPanel.addGestureRecognizer(redSwipeLeftGesture)
		
		//划动手势
		//右划
		let blackSwipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
		blackKilledPanel.addGestureRecognizer(blackSwipeGesture)
		//左划
		let blackSwipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
		blackSwipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
		blackKilledPanel.addGestureRecognizer(blackSwipeLeftGesture)
		
	}
	
	override func viewDidLayoutSubviews() {
		
		let width = screenBounds.width
		let height =  screenBounds.height
		let boardHeight = width / 9 * 10
		
		board.frame = CGRect(x: 0, y: (height - boardHeight) / 2 , width: width, height: boardHeight)
		blackKilledPanel.frame = CGRect(x: 0, y: 0, width: width , height: (height - boardHeight) / 2)
		redKilledPanel.frame = CGRect(x: 0, y:  (height - boardHeight) / 2 + boardHeight, width: width , height: (height - boardHeight) / 2)
		
		blackKilledPanel.transform = CGAffineTransformMakeRotation(180 * CGFloat(M_PI)/CGFloat(180));
	}
	
	
	//旋转手势
	func handleRotateGesture(sender: UIRotationGestureRecognizer){
		//浮点类型，得到sender的旋转度数
		let rotation : CGFloat = sender.rotation
		//旋转角度CGAffineTransformMakeRotation,改变图像角度
		
		//状态结束，保存数据
//		if sender.state == UIGestureRecognizerState.Ended{
//			netRotation += rotation
//		}
	}
	
	//划动手势
	func handleSwipeGesture(sender: UISwipeGestureRecognizer){
		//划动的方向
		let direction = sender.direction
		//判断是上下左右
		switch (direction){
		case UISwipeGestureRecognizerDirection.Left:
			if let chessStep = chessLogic.back() {
				board.drawBackChessStep(chessStep)
			}
		case UISwipeGestureRecognizerDirection.Right:
			if let chessStep = chessLogic.go() {
				board.drawGoChessStep(chessStep)
			}
		case UISwipeGestureRecognizerDirection.Up:
			print("Up")
			break
		case UISwipeGestureRecognizerDirection.Down:
			print("Down")
			break
		default:
			break;
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.Portrait
	}
	
	override func prefersStatusBarHidden()->Bool{
		return true
	}
	
}

