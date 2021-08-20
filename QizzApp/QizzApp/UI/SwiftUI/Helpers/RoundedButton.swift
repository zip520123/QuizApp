//
//  RoundedButton.swift
//  QizzApp
//
//  Created by zip520123 on 28/06/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import SwiftUI

struct RoundedButton: View {
   
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    init(title: String, isEnabled: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            HStack{
                Spacer()
                Text(title)
                    .padding()
                    .foregroundColor(.white)
                Spacer()
            }
            .background(Color.blue)
            .cornerRadius(25)
            
        })
        .buttonStyle(PlainButtonStyle())
        .padding()
        .disabled(!isEnabled)
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RoundedButton(title: "isEnabled", isEnabled: true, action: {})
            RoundedButton(title: "disable", isEnabled: false, action: {})
        }
        
    }
}
