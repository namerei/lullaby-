//
//  ParentTestQuestionView.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 25/01/24.
//

import SwiftUI

struct ParentTestQuestionView: View {
    @FocusState private var focused: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var answerField: String = ""
    @AppStorage("passed_parent_test") private var passedParentTest: Bool = false
    
    let question: ParentTestQuestion
    
    init() {
        self.question = questions.randomElement()!
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("For Parents".localized)
                .font(.title2.bold())
            Text("How much is".localized + " \(question.question)")
                .font(.headline)
            TextField("Your answer".localized, text: $answerField)
                .focused($focused)
                .keyboardType(.numberPad)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 15.0)
                        .fill(Color.gray.gradient.opacity(0.4))
                )
            Button(action: {
                if answerField == question.answer {
                    passedParentTest = true
                    dismiss()
                }
            }, label: {
                Text("Submit".localized)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .font(.headline)
                    .background(
                        RoundedRectangle(cornerRadius: 16.0)
                            .fill(Color.accent.gradient)
                    )
            })
            .foregroundStyle(.primary)
        }
        .onAppear(perform: {
            focused = true
        })
        .padding()
    }
}

#Preview {
    ParentTestQuestionView()
}

struct ParentTestQuestion {
    let question: String
    let answer: String
}

let questions: [ParentTestQuestion] = [
    .init(question: "5+4", answer: "9"),
    .init(question: "2+8", answer: "10"),
    .init(question: "7+1", answer: "8"),
    .init(question: "8-5", answer: "3"),
    .init(question: "9-4", answer: "5"),
    .init(question: "10-5", answer: "5"),
    .init(question: "1+3", answer: "4"),
    .init(question: "3+2", answer: "5"),
    .init(question: "10-9", answer: "1"),
    .init(question: "1+5", answer: "6")
]
