//
//  RootFeature.swift
//  Counter
//
//  Created by havi.log on 2022/08/19.
//

import ComposableArchitecture

struct RootState: Equatable {
}

enum RootAction: Equatable {
}

struct RootEnvironment: Equatable {
    static let live: Self = .init()
}

let RootReducer = Reducer<
    RootState, RootAction, RootEnvironment
> { state, action, environment in
    switch action {
    }
}

