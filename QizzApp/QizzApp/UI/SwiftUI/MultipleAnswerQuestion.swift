//
//  MultipleAnswerQuestion.swift
//  QizzApp
//
//  Created by zip520123 on 07/06/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import SwiftUI

struct MultipleAnswerQuestion: View {
    let title: String
    let question: String
    
    @State var store: MultipleSelectionStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HeaderView(title: title, subtitle: question)
            
            ForEach(store.options.indices) { (i) in
                MultipleTextSelectionCell(option: $store.options[i])
            }
            Spacer()
            RoundedButton(title: "Submit", isEnabled: store.canSubmit, action: store.submit)

        }
    }
}

struct MultipleAnswerQuestion_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MultipleAnswerQuestionTestView()
            
            MultipleAnswerQuestionTestView()
                .preferredColorScheme(.dark).environment(\.sizeCategory, .extraExtraLarge)
        }
        
    }
    struct MultipleAnswerQuestionTestView: View {
        @State var selection = ["none"]
        var body: some View {
            VStack {
                MultipleAnswerQuestion(
                    title: "1 of 2",
                    question: "What'sM Mike's name",
                    store: .init(
                        options: ["Portuguess", "American", "Geek"
                        ], handler: { selection = $0
                        } )
                )
                Text("Last selection: " + selection.joined(separator: ", "))
            }
            
        }
    }
}
