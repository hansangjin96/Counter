//
//  CounterFeature.swift
//  Counter
//
//  Created by 한상진 on 2022/08/20.
//

import ComposableArchitecture

public struct CounterState: Equatable {
    var currentNumber: Int
    var isNumberFactRequestInFlight: Bool
    var numberFact: String?
    public var favoriteNumbers: [Int]
    var alert: AlertState<CounterAction>?
    
    var isFavoriteNumber: Bool { return favoriteNumbers.contains(currentNumber) }
    
    public init(
        currentNumber: Int = 0,
        isNumberFactRequestInFlight: Bool = false,
        numberFact: String? = nil,
        favoriteNumbers: [Int] = [], 
        alert: AlertState<CounterAction>? = nil
    ) {
        self.currentNumber = currentNumber
        self.isNumberFactRequestInFlight = isNumberFactRequestInFlight
        self.numberFact = numberFact
        self.favoriteNumbers = favoriteNumbers
        self.alert = alert
    }
}

public enum CounterAction: Equatable {
    case incrementButtonTapped
    case decrementButtonTapped
    
    case isPrimeButtonTapped
    case numberFactResponse(TaskResult<String>)
    case cancelButtonTapped
    
    case saveFavoriteNumberButtonTapped
    case deleteFavoriteNumberButtonTapped
    
    case alertDismissed
}

public struct CounterEnvironment {
    var factClient: FactClient
    
    public init(
        factClient: FactClient
    ) {
        self.factClient = factClient
    }
}

public let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> { state, action, environment in
    enum NumberFactRequestID { }
    
    switch action {
    case .incrementButtonTapped:
        state.currentNumber += 1
        state.numberFact = nil
        return .none
        
    case .decrementButtonTapped:
        state.currentNumber -= 1
        state.numberFact = nil
        return .none
        
    case .isPrimeButtonTapped:
        state.isNumberFactRequestInFlight = true
        state.numberFact = nil
        return .task { [number = state.currentNumber] in
            await .numberFactResponse(
                TaskResult {
                    try await environment.factClient.fetch(number)
                }
            )
        }
        .cancellable(id: NumberFactRequestID.self)
        
    case .cancelButtonTapped:
        state.isNumberFactRequestInFlight = false
        state.numberFact = nil
        return .cancel(id: NumberFactRequestID.self)
        
    case let .numberFactResponse(.success(response)):
        state.isNumberFactRequestInFlight = false
        state.numberFact = response
        return .none
        
    case .numberFactResponse(.failure):
        state.isNumberFactRequestInFlight = false
        return .none
        
    case .saveFavoriteNumberButtonTapped:
        guard !state.favoriteNumbers.contains(state.currentNumber) else { return .none }
        state.favoriteNumbers.append(state.currentNumber)
        state.alert = AlertState(
            title: TextState("저장되었습니다."), 
            dismissButton: .cancel(TextState("확인"))
        )
        return .none
        
    case .deleteFavoriteNumberButtonTapped:
        guard state.favoriteNumbers.contains(state.currentNumber) else { return .none }
        state.favoriteNumbers.removeAll { $0 == state.currentNumber }
        state.alert = AlertState(
            title: TextState("삭제되었습니다."), 
            dismissButton: .cancel(TextState("확인"))
        )
        return .none
        
    case .alertDismissed:
        state.alert = nil
        return .none
    }
}.debug()
