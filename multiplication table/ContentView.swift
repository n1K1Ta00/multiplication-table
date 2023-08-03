//
//  ContentView.swift
//  multiplication table
//
//  Created by Никита Мартьянов on 3.08.23.
//

import SwiftUI

struct ContentView: View {
    @State private var number1 = 1
    @State private var number2 = 1
    @State private var answer = ""
    @State private var score = 0
    @State private var showingScore = false
    @State private var selectedTables = [Int]()
    @State private var numberOfQuestions = 5
    @State private var colvo = 0
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Spacer()
                
                Text("Сколько будет \(number1) умножить на \(number2)?")
                    .foregroundColor(.white)
                
                TextField("Ответ", text: $answer)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Проверить ответ") {
                    checkAnswer()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                Spacer()
                
                VStack {
                    Text("Выберите таблицы умножения")
                    
                    ForEach(1...10, id: \.self) { table in
                        Toggle("\(table)", isOn: Binding(
                            get: { self.selectedTables.contains(table) },
                            set: { if $0 {
                                self.selectedTables.append(table)
                            } else {
                                self.selectedTables.removeAll(where: { $0 == table })
                            }}
                        ))
                    }
                }
              
                Picker("Количество вопросов", selection: $numberOfQuestions) {
                    Text("5").tag(5)
                    Text("10").tag(10)
                    Text("20").tag(20)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text("Результат"), message: Text("Ваш счет: \(score) из \(numberOfQuestions)"), dismissButton: .default(Text("Продолжить")) {
                    nextQuestion()
                })
            }
        }}
        
    func checkAnswer() {
        guard let userAnswer = Int(answer) else { return }
        
        if userAnswer == number1 * number2 {
            score += 1
            colvo += 1
        }
        else {
            colvo += 1
        }
        
        
        if colvo == numberOfQuestions {
            showingScore = true
        } else {
            nextQuestion()
        }
    }

        
        func nextQuestion() {
            var availableTables = selectedTables
            if availableTables.isEmpty {
                availableTables = Array(1...10)
            }
            
            var questions = [(Int, Int)]()
            while questions.count < numberOfQuestions {
                let number1 = availableTables.randomElement()!
                let number2 = Int.random(in: 1...10)
                let question = (number1, number2)
                
                if !questions.contains(where: { $0 == question }) {
                    questions.append(question)
                }
            }
            
            if let (number1, number2) = questions.first {
                self.number1 = number1
                self.number2 = number2
            }
            
            answer = ""
            showingScore = false
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }


