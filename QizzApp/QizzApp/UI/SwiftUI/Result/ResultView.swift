//
//  ResultView.swift
//  QizzApp
//
//  Created by zip520123 on 03/07/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import SwiftUI

struct ResultView: View {
    let title: String
    let summary: String
    let answers: [PresentableAnswer]
    let playAgain: () -> Void
    
    var body: some View {
        HeaderView(title: title, subtitle: summary)
        List(answers, id: \.question) { model in
            ResultAnswerCell(model: model)
        }
        
        Spacer()
        RoundedButton(title: "Play again", isEnabled: true, action: playAgain)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultTestView()
        ResultTestView()
            .preferredColorScheme(.dark)
            .environment(\.sizeCategory, .extraExtraLarge)
    }
    
    struct ResultTestView: View {
        @State var playAgainCount = 0
        var body: some View {
            VStack {
                ResultView(
                    title: "Result",
                    summary: "You got 3/5 correct",
                    answers: [
                        .init(question: "What's the answer to question 1", answer: "A correct answer", wrongAnswer: "A wrong answer"),
                        .init(question: "What's the answer to question 2", answer: "A correct answer", wrongAnswer: nil),
                        .init(question: "What's the answer to question 3", answer: "A correct answer", wrongAnswer: "A wrong answer"),
                        .init(question: "What's the answer to question 4", answer: "A correct answer", wrongAnswer: "A wrong answer"),
                        .init(question: "What's the answer to question 5", answer: "A correct answer", wrongAnswer: "A wrong answer")
                    ],
                    playAgain: {
                        playAgainCount += 1
                    })
                Text("Play again count: \(playAgainCount)")
            }
        }
    }
}

