//
//  FactClient.swift
//  Counter
//
//  Created by 한상진 on 2022/08/27.
//

import Foundation
import XCTestDynamicOverlay
import ComposableArchitecture

struct FactClient {
    var fetch: @Sendable (Int) async throws -> String
}

extension FactClient {
    static let live: Self = .init { number in
        try await Task.sleep(nanoseconds: NSEC_PER_SEC)
        let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)/trivia")!)
        return String(decoding: data, as: UTF8.self)
    }
}

#if DEBUG
extension FactClient {
    static let unimplemented: Self = .init(fetch: XCTUnimplemented("\(Self.self).fetch"))
}
#endif
