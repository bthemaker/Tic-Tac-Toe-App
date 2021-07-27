//
//  ContentView.swift
//  TicTacToe
//
//  Created by Bruno Garcia on 7/27/21.
//

import SwiftUI

struct ContentView: View {
    @State private var moves = Array(repeating: "", count: 9)
    @State private var xTurn = true
    @State private var gameOver = false
    @State private var winMessage = ""
    
    var body: some View {
        VStack {
            // Title Text
            Text("Tic Tac Toe")
                .font(.title)
                .bold()
                .padding()
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(120), spacing: 15), count: 3), spacing: 15, content: {
                ForEach(0 ..< 9) { index in
                    ZStack {
                        Color.blue
                            .frame(width: 120, height: 120, alignment: .center)
                            .cornerRadius(30)
                        Color.gray
                            .opacity(moves[index] == "" ? 1 : 0)
                        Image(systemName: moves[index])
                            .font(.system(size: 90, weight: .bold))
                    }
                    .frame(width: 120, height: 120, alignment: .center)
                    .cornerRadius(30)
                    .onTapGesture {
                        withAnimation(Animation.default) {
                            if moves[index] == "" {
                                moves[index] = xTurn ? "multiply" : "circle"
                                xTurn.toggle()
                            }
                        }
                    }
                    .rotation3DEffect(
                        .init(degrees: moves[index] != "" ? 180 : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                }
            })
        }
        .preferredColorScheme(.dark)
        .alert(isPresented: $gameOver, content: {
            Alert(title: Text(winMessage), dismissButton: .destructive(Text("Play again"), action: {
                withAnimation(Animation.default) {
                    moves = Array(repeating: "", count: 9)
                    gameOver = false
                }
            }))
        })
        .onChange(of: moves, perform: { value in
            checkForWinner()
        })
    }
    
    private func checkForWinner() {
        checkLine(a: 0, b: 1, c: 2)
        checkLine(a: 3, b: 4, c: 5)
        checkLine(a: 6, b: 7, c: 8)
        checkLine(a: 0, b: 3, c: 6)
        checkLine(a: 1, b: 4, c: 7)
        checkLine(a: 2, b: 5, c: 8)
        checkLine(a: 0, b: 4, c: 8)
        checkLine(a: 2, b: 4, c: 6)
        if !(gameOver || moves.contains("")) {
            winMessage = "Cat's Game"
            gameOver = true
        }
    }
    
    private func checkLine(a: Int, b: Int, c: Int) {
        if moves[a] != "" && moves[a] == moves[b] && moves[b] == moves[c] {
            var winner = ""
            if moves[a] == "multiply" {
                winner = "X"
            } else if moves[a] == "circle" {
                winner = "O"
            }
            winMessage = "\(winner) is the winner!"
            gameOver = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
