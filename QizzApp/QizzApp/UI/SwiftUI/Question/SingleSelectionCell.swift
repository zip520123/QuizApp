//
//  SingleSelectionCell.swift
//  QizzApp
//
//  Created by zip520123 on 01/06/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import SwiftUI

struct SingleTextSelectionCell: View {
    let text: String
    let selection: ()-> Void
    var body: some View {
        Button(action: selection, label: {
            HStack {
                Circle()
                    .stroke(Color.secondary, lineWidth: 2.5)
                    .frame(width: 40.0, height: 40.0)
                Text(text)
                    .font(.title)
                    .foregroundColor(Color.secondary)
                Spacer()
            }.padding()
            
        })
    }
}

struct SingleSelectionCell_Previews: PreviewProvider {
    static var previews: some View {
        SingleTextSelectionCell(text: "A text", selection: {})
            .previewLayout(.sizeThatFits)
    }
}
