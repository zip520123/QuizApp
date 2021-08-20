//
//  ResultAnswerCell.swift
//  QizzApp
//
//  Created by zip520123 on 06/07/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import SwiftUI

struct ResultAnswerCell: View {
    let model: PresentableAnswer
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text(model.question)
                .font(.title)
            Text(model.answer)
                .font(.title)
                .foregroundColor(.green)
            if let wrongAnswer = model.wrongAnswer {
                Text(wrongAnswer)
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
    }
}


struct ResultAnswerCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResultAnswerCell(model: PresentableAnswer(question: "A question", answer: "answer", wrongAnswer: "a wrong answer"))
                .previewLayout(.sizeThatFits)
            ResultAnswerCell(model: PresentableAnswer(question: "A question", answer: "answer", wrongAnswer: nil))
                .previewLayout(.sizeThatFits)
        }
    }
}
