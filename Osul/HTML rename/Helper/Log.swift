//
//  Log.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/13/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

enum LogLevel {
    case verbose
    case debug
    case info
    case warning
    case error
}

protocol Loggable {
    func log(level: LogLevel, _ message: @autoclosure () -> Any)
}

//    now, we use protocol extension to provide default implementation of the protocol metods
extension HTML2PDFRenderer: Loggable {
    func log(level: LogLevel, _ message: @autoclosure () -> Any) {
    }
}
