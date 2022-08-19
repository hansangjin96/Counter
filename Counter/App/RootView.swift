//
//  RootView.swift
//  Counter
//
//  Created by havi.log on 2022/08/19.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    let store: Store<RootState, RootAction>
    
    // MARK: Body
    
    var body: some View {
        Text("Hello, World!")
    }
} 

// MARK: Preview

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: Store(
                initialState: RootState(),
                reducer: RootReducer,
                environment: .live
            )
        )
    }
}
