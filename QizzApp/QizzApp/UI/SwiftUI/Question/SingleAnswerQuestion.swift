//
//  SingleAnswerQuestion.swift
//  QizzApp
//
//  Created by zip520123 on 29/05/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import SwiftUI

struct SingleAnswerQuestion: View {
    let title: String
    let question: String
    let options: [String]
    let selection: (String) -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HeaderView(title: title, subtitle: question)
            
            ForEach(options, id: \.self) { (option) in
                SingleTextSelectionCell(text: option, selection: {
                    selection(option)
                })

            }
            Spacer()
        }
    }
}

struct SingleAnswerQuestion_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SingleAnswerQuestionTestView()
            
            SingleAnswerQuestionTestView()
                .preferredColorScheme(.dark).environment(\.sizeCategory, .extraExtraLarge)
        }
        
    }
    struct SingleAnswerQuestionTestView: View {
        @State var selection: String = "none"
        var body: some View {
            VStack {
                SingleAnswerQuestion(title: "1 of 2", question: "What'sM Mike's name", options: ["Portuguess", "American", "Geek"
                ]) { selection = $0
                }
                Text("Last selection: " + selection)
            }
            
        }
    }
}



