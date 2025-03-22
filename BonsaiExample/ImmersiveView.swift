//
//  ImmersiveView.swift
//  BonsaiExample
//
//  Created by 酒井文也 on 2025/03/22.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            
            if let immersiveContentEntity = try? await Entity(
                named: "Small",
                in: realityKitContentBundle
            ) {
                content.add(immersiveContentEntity)
                immersiveContentEntity.name = "Small"
            }
            if let immersiveContentEntity = try? await Entity(
                named: "Medium",
                in: realityKitContentBundle
            ) {
                content.add(immersiveContentEntity)
                immersiveContentEntity.name = "Medium"
            }
            if let immersiveContentEntity = try? await Entity(
                named: "Large",
                in: realityKitContentBundle
            ) {
                content.add(immersiveContentEntity)
                immersiveContentEntity.name = "Large"
            }
        } update: { content in
            let entities = content.entities
            entities
                .first(where: {entity in entity.name == "Small"})?.components
                .set(
                    OpacityComponent(
                        opacity: appModel.size == AppModel.Size.small ? 1.0 : 0.0
                    )
                )
            
            entities
                .first(where: {entity in entity.name == "Medium"})?.components
                .set(
                    OpacityComponent(
                        opacity: appModel.size == AppModel.Size.medium ? 1.0 : 0.0
                    )
                )
            
            entities
                .first(where: {entity in entity.name == "Large"})?.components
                .set(
                    OpacityComponent(
                        opacity: appModel.size == AppModel.Size.large ? 1.0 : 0.0
                    )
                )
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
