//
//  CounterFeature.swift
//  Counter
//
//  Created by 한상진 on 2022/08/20.
//

@testable import Counter

import XCTest
import ComposableArchitecture

@MainActor
final class CounterTests: XCTestCase {
    
    // MARK: 더하기 빼기
    
    func test_더하기버튼이_눌렸을때_숫자증가() async {
        let store: TestStore = .init(
            initialState: CounterState(),
            reducer: counterReducer,
            environment: .unimplemented
        )
        
        // let _ = Xcode 버그 때문에 warning 생겨서 붙여줌
        let _ = await store.send(.incrementButtonTapped) {
            $0.currentNumber = 1
        }
        
        let _ = await store.send(.incrementButtonTapped) {
            $0.currentNumber = 2
        }
    }
    
    func test_빼기버튼이_눌렸을때_숫자감소() async {
        let store: TestStore = .init(
            initialState: CounterState(),
            reducer: counterReducer,
            environment: .unimplemented
        )
        
        let _ = await store.send(.decrementButtonTapped) {
            $0.currentNumber = -1
        }
        
        let _ = await store.send(.decrementButtonTapped) {
            $0.currentNumber = -2
        }
    }
    
    // MARK: NumberFact
    
    func test_numberFact버튼이_눌렸을때_성공이면_fact표시() async {
        let store: TestStore = .init(
            initialState: CounterState(),
            reducer: counterReducer,
            environment: .unimplemented
        )
        
        store.environment.factClient.fetch = { "\($0)은 하비가 좋아하는 숫자!" }
        
        let _ = await store.send(.incrementButtonTapped) {
            $0.currentNumber = 1
        }
        
        let _ = await store.send(.numberFactButtonTapped) {
            $0.isNumberFactRequestInFlight = true
        }
        
        let _ = await store.receive(.numberFactResponse(.success("1은 하비가 좋아하는 숫자!"))) {
            $0.isNumberFactRequestInFlight = false
            $0.numberFact = "1은 하비가 좋아하는 숫자!"
        }
    }
    
    func test_numberFact버튼이_눌렸을때_실패면_에러() async {
        struct FactTestError: Equatable, Error { }
        
        let store: TestStore = .init(
            initialState: CounterState(),
            reducer: counterReducer,
            environment: .unimplemented
        )
        
        store.environment.factClient.fetch = { _ in throw FactTestError() }
        
        let _ = await store.send(.numberFactButtonTapped) {
            $0.isNumberFactRequestInFlight = true
        }
        
        let _ = await store.receive(.numberFactResponse(.failure(FactTestError()))) {
            $0.isNumberFactRequestInFlight = false
        }
    }
    
    func test_numberFact버튼_누르고_cancel버튼_누르면_취소() async {
        struct FactTestError: Equatable, Error { }
        
        let store: TestStore = .init(
            initialState: CounterState(),
            reducer: counterReducer,
            environment: .unimplemented
        )
        
        store.environment.factClient.fetch = {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            return "havi will cancel task \($0)"
        }
        
        let _ = await store.send(.numberFactButtonTapped) {
            $0.isNumberFactRequestInFlight = true
        }
        
        let _ = await store.send(.cancelButtonTapped) {
            $0.isNumberFactRequestInFlight = false
            $0.numberFact = nil
        }
    }
    
    // MARK: Favorite
    
    func test_saveFavoriteButton이눌리면_저장() async {
        let store: TestStore = .init(
            initialState: CounterState(),
            reducer: counterReducer,
            environment: .unimplemented
        )
        
        let _ = await store.send(.incrementButtonTapped) {
            $0.currentNumber = 1
        }
        
        let _ = await store.send(.saveFavoriteNumberButtonTapped) {
            $0.alert = AlertState(
                title: TextState("저장되었습니다."),
                dismissButton: .cancel(TextState("확인"))
            )
            $0.favoriteNumbers = [1]
        }
        
        let _ = await store.send(.alertDismissed) {
            $0.alert = nil
        }
    }
    
    func test_deleteFavoriteButton이눌리면_삭제() async {
        let store: TestStore = .init(
            initialState: CounterState(favoriteNumbers: [1, 2, 3]),
            reducer: counterReducer,
            environment: .unimplemented
        )
        
        let _ = await store.send(.incrementButtonTapped) {
            $0.currentNumber = 1
        }
        
        let _ = await store.send(.deleteFavoriteNumberButtonTapped) {
            $0.alert = AlertState(
                title: TextState("삭제되었습니다."),
                dismissButton: .cancel(TextState("확인"))
            )
            $0.favoriteNumbers = [2, 3]
        }
        
        let _ = await store.send(.incrementButtonTapped) {
            $0.currentNumber = 2
        }
        
        let _ = await store.send(.incrementButtonTapped) {
            $0.currentNumber = 3
        }
        
        let _ = await store.send(.deleteFavoriteNumberButtonTapped) {
            $0.alert = AlertState(
                title: TextState("삭제되었습니다."),
                dismissButton: .cancel(TextState("확인"))
            )
            $0.favoriteNumbers = [2]
        }
        
        let _ = await store.send(.alertDismissed) {
            $0.alert = nil
        }
    }
    
}

extension CounterEnvironment {
    static let unimplemented: Self = .init(
        factClient: .unimplemented
    )
}
