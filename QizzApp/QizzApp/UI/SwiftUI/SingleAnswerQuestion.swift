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
            VStack(alignment: .leading, spacing: 16.0) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Text(question)
                    .font(.largeTitle)
                    .fontWeight(.medium)
            }.padding()
            
            ForEach(options, id: \.self) { (option) in
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    HStack {
                        Circle()
                            .stroke(Color.secondary, lineWidth: 2.5)
                            .frame(width: 40.0, height: 40.0)
                        Text(option)
                            .font(.title)
                            .foregroundColor(Color.secondary)
                        Spacer()
                    }.padding()
                    
                })

            }
            Spacer()
        }
    }
}

struct SingleAnswerQuestion_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SingleAnswerQuestion(title: "1 of 2",
                                 question: "What's Mike's name",
                                 options: ["Portuguess", "American", "Geek"
                                 ], selection: {_ in
                                    
                                 })
            SingleAnswerQuestion(title: "1 of 2",
                                 question: "What's Mike's name",
                                 options: ["Portuguess", "American", "Geek"
                                 ], selection: {_ in
                                    
                                 }).preferredColorScheme(.dark).environment(\.sizeCategory, .extraExtraLarge)
        }
        
    }
}
