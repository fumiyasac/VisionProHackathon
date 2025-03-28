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
    @State var initialPosition: SIMD3<Float>? = nil
    
    var translationGesture: some Gesture {
        /// The gesture to move an entity.
        DragGesture()
            .targetedToAnyEntity()
            .onChanged({ value in
                /// The entity that the drag gesture targets.
                let rootEntity = value.entity

                // Set `initialPosition` to the position of the entity if it is `nil`.
                if initialPosition == nil {
                    initialPosition = rootEntity.position
                }

                /// The movement that converts a global world space to the scene world space of the entity.
                let movement = value.convert(value.translation3D, from: .global, to: .scene)

                // Apply the entity position to match the drag gesture,
                // and set the movement to stay at the ground level.
                rootEntity.position = (initialPosition ?? .zero) + movement.grounded
            })
            .onEnded({ _ in
                // Reset the `initialPosition` back to `nil` when the gesture ends.
                initialPosition = nil
            })
    }
    
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            
            let shapeSize = SIMD3<Float>(1.4, 1.4, 1.4)
            
            if let immersiveContentEntity = try? await Entity(
                named: "Small",
                in: realityKitContentBundle
            ) {
            
                immersiveContentEntity.name = "Small"
                immersiveContentEntity.components.set(InputTargetComponent())
                immersiveContentEntity.position.y += 1
                immersiveContentEntity.position.z -= 2
                
                immersiveContentEntity.components.set(
                    CollisionComponent(
                        shapes: [
                            ShapeResource
                                .generateBox(
                                    width: 1, height: 1, depth: 1
                                )
                        ]
                    )
                )
                content.add(immersiveContentEntity)
            }
            
            if let immersiveContentEntity = try? await Entity(
                named: "Medium",
                in: realityKitContentBundle
            ) {
                content.add(immersiveContentEntity)
                immersiveContentEntity.name = "Medium"
                immersiveContentEntity.components.set(InputTargetComponent())
                immersiveContentEntity.position.y += 1
                immersiveContentEntity.position.z -= 2
                
                immersiveContentEntity.components.set(
                    CollisionComponent(
                        shapes: [
                            ShapeResource
                                .generateBox(
                                    width: 1, height: 1, depth: 1
                                )
                        ]
                    )
                )
                content.add(immersiveContentEntity)
            }
            if let immersiveContentEntity = try? await Entity(
                named: "Large",
                in: realityKitContentBundle
            ) {
                content.add(immersiveContentEntity)
                immersiveContentEntity.name = "Large"
                immersiveContentEntity.components.set(InputTargetComponent())
                immersiveContentEntity.position.y += 1
                immersiveContentEntity.position.z -= 2
                
                immersiveContentEntity.components.set(
                    CollisionComponent(
                        shapes: [
                            ShapeResource
                                .generateBox(
                                    width: 1, height: 1, depth: 1
                                )
                        ]
                    )
                )
                content.add(immersiveContentEntity)
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
        .gesture(translationGesture)
        .gesture(
            MagnifyGesture()
                .targetedToAnyEntity()
                .onEnded{value in
                    if(appModel.size == AppModel.Size.small){
                        appModel.size = .medium
                    } else if (appModel.size == AppModel.Size.medium){
                        appModel.size = .large
                    } else if(appModel.size == AppModel.Size.large){
                        appModel.size = .small
                    }
                }
        )
        
    }
}

extension SIMD3 where Scalar == Float {
    /// The variable to lock the y-axis value to 0.
    var grounded: SIMD3<Scalar> {
        return .init(x: x, y: y, z: z)
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
