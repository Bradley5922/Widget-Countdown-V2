//
//  Item.swift
//  Widget Countdown V2
//
//  Created by Bradley Cable on 02/08/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
