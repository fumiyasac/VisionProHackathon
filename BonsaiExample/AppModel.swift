//
//  AppModel.swift
//  BonsaiExample
//
//  Created by 酒井文也 on 2025/03/22.
//

import SwiftUI
import RealityFoundation //追加

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
    
    //追加
    var smallEntities: [Entity] = []
    var entitiesToRemove: [Entity] = []
}
