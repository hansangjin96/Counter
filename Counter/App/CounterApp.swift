//
//  CounterApp.swift
//  Counter
//
//  Created by havi.log on 2022/08/19.
//

import SwiftUI
import ComposableArchitecture

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(
                    initialState: RootState(),
                    reducer: RootReducer,
                    environment: .live
                )
            )
        }
    }
}
