//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by PC on 21/09/22.
//

import SwiftUI
import ComposableArchitecture

@main
struct TicTacToeApp: App {
    var body: some Scene {
        WindowGroup {
            GameView(
                store: Store(
                    initialState: GameState(),
                    reducer: GameReducer,
                    environment: GameEnvironment()
                )
            )
        }
    }
}
