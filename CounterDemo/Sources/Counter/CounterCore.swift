//
//  CounterFeature.swift
//  Counter
//
//  Created by 한상진 on 2022/08/20.
//

import ComposableArchitecture

struct CounterState: Equatable {
    var currentNumber: Int = 0
    var isNumberFactRequestInFlight: Bool = false
    var numberFact: String?
    var favoriteNumbers: [Int] = []
    var alert: AlertState<CounterAction>?
    
    var isFavoriteNumber: Bool { return favoriteNumbers.contains(currentNumber) }
}

enum CounterAction: Equatable {
    case incrementButtonTapped
    case decrementButtonTapped
    
    case isPrimeButtonTapped
    case numberFactResponse(TaskResult<String>)
    case cancelButtonTapped
    
    case saveFavoriteNumberButtonTapped
    case deleteFavoriteNumberButtonTapped
    
    case alertDismissed
}

struct CounterEnvironment {
    var factClient: FactClient
}

let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> { state, action, environment in
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
}
