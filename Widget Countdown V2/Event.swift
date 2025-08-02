//
//  Item.swift
//  Widget Countdown V2
//
//  Created by Bradley Cable on 02/08/2025.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Event {
    
    var timestamp: Date
    var name: String
    
    var background: Gradient?
    var image: Image?
    
    init(timestamp: Date = .now, name: String, background: Gradient? = nil, image: Image? = nil) {
        self.timestamp = timestamp
        self.name = name
        self.background = background
        self.image = image
    }
}
