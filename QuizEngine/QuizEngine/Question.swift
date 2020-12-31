//
//  Question.swift
//  QizzApp
//
//  Created by zip520123 on 12/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import Foundation
public enum Question<T: Hashable> : Hashable {
    case singleAnswer(T)
    case multibleAnswer(T)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .singleAnswer(let value):
            hasher.combine(value.hashValue)
            break
        case .multibleAnswer(let value):
            hasher.combine(value.hashValue)
            break
        }
        
    }
    
}
