//
//  statics.swift
//  ChineseChess
//
//  Created by 姚明 on 16/8/24.
//  Copyright © 2016年 姚明. All rights reserved.
//

import Foundation
import UIKit

let screenBounds:CGRect = UIScreen.mainScreen().bounds


let chessLogic:ChessLogic = ChessLogic()

let board = ChessBoardUIView()
let blackKilledPanel = KilledPanel()
let redKilledPanel = KilledPanel()
// let ctrlPanel = CtrlPanel()

let color_board_line = UIColor.hexToColor("000000")
let color_board_line_shadow = UIColor.hexToColor("FFFFFF")
let bgcolor_board = UIColor.hexToColor("CDDAD3")
let bgcolor_blackKilledPanel = UIColor.hexToColor("CDDAD3")
let bgcolor_redKilledPanel = UIColor.hexToColor("CDDAD3")
let color_black_chess = UIColor.hexToColor("0F1311")
let color_red_chess = UIColor.hexToColor("8C111A")
let bgcolor_chess = UIColor.hexToColor("FFF2E8")
let color_chess_shadow = UIColor.hexToColor("EFE2D8")

let color_focus_volatile = UIColor.hexToColor("bbbbbb")
let color_focus_stable = UIColor.orangeColor()