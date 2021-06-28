//
//  QuestionHeader.swift
//  QizzApp
//
//  Created by zip520123 on 01/06/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Text(subtitle)
                .font(.largeTitle)
                .fontWeight(.medium)
        }.padding()
    }
}


struct QuestionHeader_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "A title", subtitle: "A subtitle")
    }
}
