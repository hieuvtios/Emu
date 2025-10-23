//
//  Task+.swift
//  GoEmulator
//
//  Created by Đỗ Việt on 18/10/25.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: TimeInterval) async throws {
        let duration = seconds * 1000_000_000
        return try await sleep(nanoseconds: UInt64(duration))
    }
    
    static func sleep(miliseconds: TimeInterval) async throws {
        let duration = miliseconds * 1_000_000
        return try await sleep(nanoseconds: UInt64(duration))
    }
}
