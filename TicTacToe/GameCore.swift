//
//  GameCore.swift
//  TicTacToe
//
//  Created by PC on 21/09/22.
//

import Foundation
import ComposableArchitecture
import SwiftUI



struct GameState : Equatable {
    var data : [[Int]] = [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
    ]
    var turn : Bool = true
    var winer : Bool = false
    var greenLocation : [Location] = []
    var xPoint : Int = 0
    var oPoint : Int = 0
    var animationAmount = 1.0
    var bg1 = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
    var bg2 = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
    var circle = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    var cross = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    enum Result{
        case winer
        case draw
        case continues
    }
    struct Location: Equatable {
        let x: Int
        let y: Int
    }
    let all = [
        [Location(x: 0, y: 0), Location(x: 0, y: 1), Location(x: 0, y: 2)],
        [Location(x: 1, y: 0), Location(x: 1, y: 1), Location(x: 1, y: 2)],
        [Location(x: 2, y: 0), Location(x: 2, y: 1), Location(x: 2, y: 2)],
        [Location(x: 0, y: 0), Location(x: 1, y: 0), Location(x: 2, y: 0)],
        [Location(x: 0, y: 1), Location(x: 1, y: 1), Location(x: 2, y: 1)],
        [Location(x: 0, y: 2), Location(x: 1, y: 2), Location(x: 2, y: 2)],
        [Location(x: 0, y: 0), Location(x: 1, y: 1), Location(x: 2, y: 2)],
        [Location(x: 0, y: 2), Location(x: 1, y: 1), Location(x: 2, y: 0)]
    ]
}

enum GameAction : Equatable {
    case boardButtonClicked(i: Int, j: Int)
    case resetData

}

struct GameEnvironment {
    public init() {}
}

let GameReducer = Reducer<GameState, GameAction, GameEnvironment> { state, action, environment in
    switch action {
    case let .boardButtonClicked(i, j):
        state.data[i][j] = state.turn ? 1 : 2
        state.turn.toggle()
        for i in state.all{

            let ans = Set(i.map({state.data[$0.x][$0.y]}))

            switch ans {
                case [1]:
                    state.oPoint += 1
                    state.greenLocation = i
                    state.animationAmount = 1
                    state.winer = true

                case [2]:
                    state.xPoint += 1
                    state.greenLocation = i
                    state.animationAmount = 1
                    state.winer = true

                default:
                    break
                }
        }

        return .none

    case .resetData:
        state.data = [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
        ]
        state.winer = false
        state.greenLocation = []
        return .none
    
    }
}

