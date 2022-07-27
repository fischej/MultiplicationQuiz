//
//  ContentView.swift
//  MultiplicationQuiz
//
//  Created by Jeff Fischer on 7/26/22.
//

import SwiftUI

struct ContentView: View {
    @State private var gameInProgress = false

    @State private var table = 2
    @State private var numberOfQuestions = 5
    @State private var correct = 0
    @State private var incorrect = 0

    @State private var questions = [Int]()
    @State private var questionText = ""
    @State private var questionCounter = 0
    @State private var answer = 0

    @FocusState var isFocused: Bool

    let questionChoices = [5, 10, 20]

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Picker("Which table?", selection: $table) {
                            ForEach(2..<13, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .foregroundColor(gameInProgress ? .secondary : .primary)

                        Picker("How many questions?", selection: $numberOfQuestions) {
                            ForEach(questionChoices, id: \.self) { choice in
                                Text("\(choice)")
                            }
                        }
                        .foregroundColor(gameInProgress ? .secondary : .primary)
                    }
                    .disabled(gameInProgress)

                    Section {
                        HStack {
                            Spacer()
                            Button("Go") {
                                startGame()
                            }
                            .font(.title.bold())
                            Spacer()
                        }
                    }
                    .disabled(gameInProgress)

                    Section {
                        if gameInProgress {
                            HStack {
                                Text(questionText)

                                Spacer()

                                TextField("", value: $answer, formatter: NumberFormatter(), onCommit: { saveAnswer() })
                                    .frame(width: 50)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .multilineTextAlignment(.trailing)
                                    .focused($isFocused)
                            }
                        }
                    }
                }

                HStack {
                    Text("Correct: \(correct)")
                    Spacer()
                    Text("Incorrect: \(incorrect)")
                }
                .padding()
                .foregroundColor(.mint)
            }
            .navigationTitle("Multiplication Quiz")
        }
    }


    func startGame() {
        questions.removeAll()
        for _ in 0..<numberOfQuestions {
            questions.append(Int.random(in: 2...12))
        }

        questionCounter = 0
        answer = 0
        correct = 0
        incorrect = 0
        gameInProgress.toggle()
        nextQuestion()
    }

    func nextQuestion() {
        if questionCounter > numberOfQuestions - 1 {
            gameInProgress.toggle()
            return
        }

        questionText = "Question \(questionCounter + 1): What is \(table) times \(questions[questionCounter])?"
    }

    func saveAnswer() {
        isFocused = false

        if answer == table * questions[questionCounter] {
            correct += 1
        }
        else {
            incorrect += 1
        }

        questionCounter += 1
        answer = 0
        nextQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
