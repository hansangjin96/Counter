//
//  FactClient.swift
//  Counter
//
//  Created by 한상진 on 2022/08/27.
//

import Foundation
import XCTestDynamicOverlay
import ComposableArchitecture

public struct FactClient {
    var fetch: @Sendable (Int) async throws -> String
}

extension FactClient {
    public static let live: Self = .init { number in
        try await Task.sleep(nanoseconds: NSEC_PER_SEC / 2)
        let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)/trivia")!)
        return String(decoding: data, as: UTF8.self)
    }
}

#if DEBUG
extension FactClient {
    public static let unimplemented: Self = .init(fetch: XCTUnimplemented("\(Self.self).fetch"))
}
#endif
