//
//  Logger.swift
//  GPS-Camera-iOS
//
//  Created by Infinity_IOS_01 on 10/16/24.
//

import Foundation

struct Logger {
    static func log(_ mess: Any, name: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let last = name.components(separatedBy: "/").last ?? ""
        print("[DEBUG] - [fileName: \(last) - function: \(function) - line: \(line)] - message: \(String(describing: mess))")
        #endif
    }
    
    static func logWithTime(_ mess: Any, name: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "hh:mm:ss"
        let last = name.components(separatedBy: "/").last ?? ""
        print("[DEBUG] - [\(formater.string(from: date))] - [fileName: \(last) - function: \(function) - line: \(line)] - message: \(String(describing: mess))")
        #endif
    }
    static func logFuncWithTime(_ mess: Any, function name: String = #function) {
        #if DEBUG
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "hh:mm:ss"
        print("[DEBUG] - [\(formater.string(from: date))] - [function: \(name)] - message: \(String(describing: mess))")
        #endif
    }
}
