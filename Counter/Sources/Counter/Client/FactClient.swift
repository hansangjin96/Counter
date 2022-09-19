//
//  FactClient.swift
//  Counter
//
//  Created by 한상진 on 2022/08/27.
//

import Foundation
import XCTestDynamicOverlay
import ComposableArchitecture

/// `Protocol`처럼 FactClient의 역할을 정의
///  
public struct FactClient {
    var fetch: @Sendable (Int) async throws -> String
}

extension FactClient {
    public static let live: Self = .init(
        fetch: { number in
            try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)/trivia")!)
            return String(decoding: data, as: UTF8.self)
        }
    )
}

/// `unimplemented`는 테스트 시 effect를 내보내는 client에 관계 없이 상태를 검증하기 위해 구현되지 않음을 보장
///  
#if DEBUG
extension FactClient {
    public static let unimplemented: Self = .init(fetch: XCTUnimplemented("\(Self.self).fetch"))
}
#endif
