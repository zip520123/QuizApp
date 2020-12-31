//
//  Copyright © 2020 zip520123. All rights reserved.
//

import Foundation
public struct Result<Question: Hashable, Answer> {
    public let answers:[Question: Answer]
    public let score: Int
}
