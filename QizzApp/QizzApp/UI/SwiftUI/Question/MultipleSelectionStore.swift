//
//  MultipleSelectionStore.swift
//  QizzApp
//
//  Created by zip520123 on 07/06/2021.
//  Copyright © 2021 zip520123. All rights reserved.
//

import Foundation
struct MultipleSelectionStore {
    var canSubmit : Bool {
        options.filter{ $0.isSelected }.endIndex > 0
    }
    
    var options: [MultipleSelectionOption]
    private let handler: ([String])->Void
    
    internal init(options: [String], handler: @escaping ([String])-> Void = {_ in}) {
        self.options = options.map {MultipleSelectionOption(text: $0)}
        self.handler = handler
    }
    
    func submit() {
        guard canSubmit else {return}
        handler(options.filter{ $0.isSelected }.map {$0.text})
    }
}

struct MultipleSelectionOption {
    let text: String
    var isSelected = false
    mutating func select() {
        isSelected.toggle()
    }
}
