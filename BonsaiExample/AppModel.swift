//
//  AppModel.swift
//  BonsaiExample
//
//  Created by 酒井文也 on 2025/03/22.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    enum Size {
        case small
        case medium
        case large
    }
    var size = Size.small
}
