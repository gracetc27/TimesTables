//
//  ContentView.swift
//  TimesTables
//
//  Created by Grace couch on 01/08/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    @State private var timesTablesLimit = 20
    @State private var questionCount = 20

    var body: some View {
        NavigationStack {
            Form {
                Section("Select times table limit") {
                    Picker("Practice up to...", selection: $timesTablesLimit) {
                        ForEach(2..<21) {
                            Text("\($0) times table")
                        }
                    }
                }
                Section("Select number of questions") {
                    Stepper("\(questionCount) questions", value: $questionCount, in: 5...30, step: 5)
                }
            }
            .navigationTitle("Game Setup")
            .toolbar {
                NavigationLink("Start") {
                    QuestionView(
                        timesTablesLimit: timesTablesLimit,
                        questionCount: questionCount
                    )
                }
            }
        }
    }
}


struct QuestionView: View {
    let timesTablesLimit: Int
    let questionCount: Int

    var correctAnswer: Int {
        number1 * number2
    }

    @State private var inputAnswer: Int = 0
    @State private var questionNumber = 1
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var gameOver = false
    @State private var showingScore = false
    @State private var number1: Int = 1
    @State private var number2: Int = 1
    @FocusState var isFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 50) {

                Text("What is \(number1) x \(number2) ? ")
                    .font(.largeTitle.bold())
                    .padding()
                    .frame(width: 300, height: 100)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 30))

                TextField("Enter Answer", value: $inputAnswer, format: .number)
                    .font(.title)
                    .padding()
                    .frame(width: 300, height: 100)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .keyboardType(.numberPad)
                    .focused($isFocused)

            }
            .task {
                askNextQuestion()
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askNextQuestion)
            } message: {
                Text("Your score is \(userScore)")
            }
            .alert("Game over!", isPresented: $gameOver) {
                Button("Reset Game", action: gameReset)
            } message: {
                Text("You finished with score of \(userScore)/\(questionCount)")
            }
        } .toolbar {
            if isFocused {
                Button("Done") {
                    submitAnswer(inputAnswer)
                    isFocused = false
                }
            }
        }
    }

    func askNextQuestion() {
        number1 = Int.random(in: 2...timesTablesLimit)
        number2 = Int.random(in: 2...timesTablesLimit)
    }

    func submitAnswer(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            userScore += 1
        } else {
            scoreTitle = "Wrong! The correct answer was \(correctAnswer)..."
        }
        questionNumber += 1

        if questionNumber > questionCount {
            gameOver = true
        } else {
            showingScore = true
        }
        inputAnswer = 0
    }

    func gameReset() {
        questionNumber = 1
        userScore = 0
        askNextQuestion()
    }
}




#Preview {
    ContentView()
}

#Preview {
    QuestionView(timesTablesLimit: 12, questionCount: 10)
}
