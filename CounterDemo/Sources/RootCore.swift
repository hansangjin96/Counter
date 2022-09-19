//
//  RootFeature.swift
//  Counter
//
//  Created by havi.log on 2022/08/19.
//

import Counter
import Favorite
import ComposableArchitecture

struct RootState: Equatable {
    var counter = CounterState()
    /// favorite은 favoriteNumbers를 shared state로 공유함
    var favorite: FavoriteState {
        get { FavoriteState(favoriteNumbers: counter.favoriteNumbers) }
        set { counter.favoriteNumbers = newValue.favoriteNumbers }
    }
}

enum RootAction: Equatable {
    case counter(CounterAction)
    case favorite(FavoriteAction)
}

struct RootEnvironment: Equatable {
    static var live: Self = .init()
}

/// `/RootAction.counter` 여기서 `/`는 
/// Enum에서 `WritableKeyPath`처럼 Action을 꺼내올 수 있게 point-free가 구현한 `CasePath` 문법
///
let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    counterReducer.pullback(
        state: \.counter,
        action: /RootAction.counter,
        environment: { _ in .init(factClient: .live) }
    ),
    favoriteReducer.pullback(
        state: \.favorite,
        action: /RootAction.favorite,
        environment: { _ in .init() }
    )
)
