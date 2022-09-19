//
//  FavoriteFeature.swift
//  Counter
//
//  Created by 한상진 on 2022/08/20.
//

import Foundation
import ComposableArchitecture

public struct FavoriteState: Equatable {
    public var favoriteNumbers: [Int]
    
    public init(favoriteNumbers: [Int]) {
        self.favoriteNumbers = favoriteNumbers
    }
}

public enum FavoriteAction: Equatable {
    case deleteFavoriteNumberTapped(IndexSet)
}

public struct FavoriteEnvironment: Equatable { 
    public init() { }
}

public let favoriteReducer = Reducer<FavoriteState, FavoriteAction, FavoriteEnvironment> { state, action, environment in
    switch action {
    case let .deleteFavoriteNumberTapped(index):
        state.favoriteNumbers.remove(atOffsets: index)
        return .none
    }
}

