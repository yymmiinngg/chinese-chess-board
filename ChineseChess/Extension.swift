//
//  extension.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/23.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation
import UIKit


var lastColor:UIColor?
extension UIView {
	
	/// 为所有视图添加点击事件
    func addOnClickListener(_ target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
    }
	
	/// 获得上级ViewController对象
	/// - parameter none
	/// - returns: nil表示没有上级ViewController
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
	
//    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//		print("touchesBegan in: \(event?.classForCoder)")
//		lastColor = self.backgroundColor
//		self.backgroundColor = UIColor.brownColor()
//	}
//	
//	
//	override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//		print ("touchesEnded in: \(event?.classForCoder)")
//		self.backgroundColor = lastColor
//	}
	
}

extension UIColor {
	
	/// 16进制颜色转换，可转换的格式如：ffffff, 0xffffff, #ffffff
	/// - parameter hex 16进制
	/// - parameter alpha 透明度
	/// - returns: nil表示转换失败
	public static func hexToColor(_ hex: String, alpha: CGFloat = 1) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		if cString.count < 6 { fatalError("Unknow hex color code: " + hex) }
		
		if cString.hasPrefix("0X") {
			let s = cString.index(cString.startIndex, offsetBy: 2)
			let e = cString.index(cString.startIndex, offsetBy: cString.count)
			cString = String(cString[s...e])
		}
		if cString.hasPrefix("0x") {
			let s = cString.index(cString.startIndex, offsetBy: 2)
			let e = cString.index(cString.startIndex, offsetBy: cString.count)
			cString = String(cString[s...e])
		}
        if cString.hasPrefix("#") {
			let s = cString.index(cString.startIndex, offsetBy: 1)
			let e = cString.index(cString.startIndex, offsetBy: cString.count)
			cString = String(cString[s...e])
		}
        if cString.count != 6 { fatalError("Unknow hex color code: " + hex) }
        
        var range: NSRange = NSMakeRange(0, 2)
		
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
		
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}
