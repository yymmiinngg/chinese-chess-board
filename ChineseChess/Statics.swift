//
//  statics.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/24.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation
import UIKit

let screenBounds:CGRect = UIScreen.main.bounds // 屏幕边界对象

let chessLogic:ChessLogic = ChessLogic() // 象棋逻辑对象

let board = ChessBoard() // 棋盘视图
let blackKilledPanel = KilledPanel() // 黑棋死子面板
let redKilledPanel = KilledPanel() // 红棋死子面板

let bgcolor = UIColor.hexToColor("111111") // 整个屏幕的背景颜色

let color_board_line = UIColor.hexToColor("000000") // 棋盘线颜色
let color_board_line_shadow = UIColor.hexToColor("FFFFFF") // 棋盘边框颜色
let bgcolor_board = UIColor.hexToColor("CDDAD3") // 棋盘背景颜色
let bordercolor_board = UIColor.hexToColor("333333") // 棋盘边框颜色

let bgcolor_killedPanel = UIColor.hexToColor("ADBAB3") // 死子面板背景颜色
let bordercolor_killedPanel = UIColor.hexToColor("333333") // 死子面板边框颜色

let color_black_chess = UIColor.hexToColor("0F1311") // 黑棋颜色
let color_red_chess = UIColor.hexToColor("8C111A") // 红棋颜色
let color_chess_shadow = UIColor.hexToColor("EFE2D8") // 棋子阴影颜色
let bgcolor_chess = UIColor.hexToColor("FFF2E8") // 棋子背景颜色

let color_focus_volatile = UIColor.gray // 不稳定焦点颜色
let color_focus_stable = UIColor.orange // 稳定焦点颜色

let color_chess_tag_awkward = UIColor.black // 棋子尴尬颜色
let color_chess_tag_lose = UIColor.hexToColor("000000", alpha: 0.4) // 棋子失败颜色
let color_chess_tag_win = UIColor.red // 棋子胜利颜色

let color_board_label = UIColor.hexToColor("353535") // 棋盘线颜色
