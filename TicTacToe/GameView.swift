//
//  GameView.swift
//  TicTacToe
//
//  Created by PC on 21/09/22.
//

import SwiftUI
import ComposableArchitecture

struct GameView: View {
    let store:  Store<GameState, GameAction>
    @State var animationAmount: Double = 0.0

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack{
                LinearGradient(colors: [Color(viewStore.bg1), Color(viewStore.bg2)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .onAppear {       
                        print(type(of: viewStore))
                    }
                VStack {
                    pointBars(oPoint: viewStore.oPoint, xPoint: viewStore.xPoint)
                        .padding()

                    board(viewStore: viewStore)

                    resetData(viewStore: viewStore)
                        .padding()

                }
            }
        }
    }

    func pointBars(oPoint: Int, xPoint: Int) -> some View{
        HStack{
            Group{
                Text("OPoint:-\(oPoint)")
                    .padding()
                    .background(Color.yellow)

                Spacer()

                Text("XPoint:-\(xPoint)")
                    .padding()
                    .background(Color.orange)
            }
            .font(.title2.bold())
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding(20)
        //.offset(y: -100)
    }

    private func board(viewStore: ViewStore<GameState, GameAction>) -> some View {
        VStack{
            ForEach(0..<3){ i in
                HStack{
                    ForEach(0..<3){ j in
                        Button {
                            viewStore.send(.boardButtonClicked(i: i, j: j))
                            if viewStore.winer{
                                animationAmount = viewStore.animationAmount
                            }

                        } label: {
                            cell(i: i, j: j, viewStore: viewStore)
                        }
                        .allowsHitTesting(!viewStore.winer && viewStore.data[i][j] == 0)
                    }
                }
            }
        }
        .padding(20)
    }

    func cell(i: Int, j: Int, viewStore: ViewStore<GameState, GameAction>) -> some View {
        VStack{
            if viewStore.data[i][j] == 0{
                Rectangle()
                    .aspectRatio(contentMode: .fit)
                    .background(Color.black)

            }else {
                Group{
                    if viewStore.data[i][j] == 1{
                        Image(systemName: "circle")
                            .resizable()
                            .foregroundColor(.yellow)
                    }else{
                        Image(systemName: "multiply")
                            .resizable()
                            .foregroundColor(.orange)
                    }
                }
                .shadow(color: .yellow, radius: 5, x: 0, y: 0)
                .aspectRatio(contentMode: .fit)
                .padding()
                .background(viewStore.greenLocation.contains(GameState.Location(x: i, y: j)) ? Color.green : viewStore.data[i][j] != 1 ? Color(viewStore.cross) : Color(viewStore.circle))
            }
        }
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white, lineWidth: 4)
        )
    }

    func resetData(viewStore: ViewStore<GameState, GameAction>) -> some View {

        Button(action: {
            viewStore.send(.resetData)
        }, label: {
            Text(viewStore.winer ? "Reset" : "Erase")
                .font(.title)
                .frame(width: 200, height: 50)
                .background(Color.red)
                .cornerRadius(20)
        })
            .overlay(
                Group {
                    if viewStore.winer {
                        Capsule()
                            .stroke(.red)
                            .scaleEffect(animationAmount)
                            .opacity(2 - animationAmount)
                            .animation(
                                .easeInOut(duration: 1)
                                    .repeatForever(autoreverses: false),
                                value: animationAmount

                            )
                            .onAppear{
                                animationAmount = 2
                            }
                    }
                }
            )
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
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
