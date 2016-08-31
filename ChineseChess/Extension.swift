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
    func addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        userInteractionEnabled = true
        addGestureRecognizer(gr)
    }
	
	/// 获得上级ViewController对象
	/// - parameter none
	/// - returns: nil表示没有上级ViewController
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder()
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
	public static func hexToColor(hex: String, alpha: CGFloat = 1) -> UIColor {
        var cString: String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if cString.characters.count < 6 { fatalError("Unknow hex color code: " + hex) }
        if cString.hasPrefix("0X") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(2))}
		if cString.hasPrefix("0x") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(2))}
        if cString.hasPrefix("#") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))}
        if cString.characters.count != 6 { fatalError("Unknow hex color code: " + hex) }
        
        var range: NSRange = NSMakeRange(0, 2)
		
        let rString = (cString as NSString).substringWithRange(range)
        range.location = 2
        let gString = (cString as NSString).substringWithRange(range)
        range.location = 4
        let bString = (cString as NSString).substringWithRange(range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
		
        NSScanner.init(string: rString).scanHexInt(&r)
        NSScanner.init(string: gString).scanHexInt(&g)
        NSScanner.init(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}