//
//  ContentView.swift
//  BonsaiExample
//
//  Created by 酒井文也 on 2025/03/22.
//

import SwiftUI
import RealityKit
import RealityKitContent
import AVFoundation
import UIKit
import ARKit

struct ContentView: View {

    @Environment(AppModel.self) private var appModel
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    private var cellTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 80.0)
    }
    
    private let session = ARKitSession()
    private let handTracking = HandTracking()

    // プレイヤー読み込み
    let soundPlayer = SoundPlayer()

    var body: some View {
        VStack {
//            Text("Hello")
//                .font(.largeTitle)
        }
        .onAppear {
            Task { @MainActor in
                await openImmersiveSpace(id: appModel.immersiveSpaceID)
            }
            
            Task {
//                let request = await session.requestAuthorization(for: [.handTracking])
//                for (authorizationType, authorizationStatus) in request {
//                    await handTracking.runSession()
//                }
//                
//                await handTracking.processHandUpdates()
            }
        }
        .gesture(
//            SimultaneousGesture(DragGesture(), MagnifyGesture())
//                .onEnded{ gesture in
//                    print(gesture.second?.velocity)
//                }
            
            TapGesture()
                .onEnded{ gesture in
                    print(gesture)
                }
        )
        .toolbar{
//            ToolbarItem(placement:.bottomOrnament){
//                Button("New", systemImage: "pencil") {
//                    // new action
//                }
//            }
            ToolbarItem(placement:.bottomOrnament){
                Button(action: {
                    soundPlayer.playSound2()
                }) {
                    HStack {
                        Image(systemName: "waterbottle")
                            .font(.title)
                        Text("Give a Water💧")
                            .font(.title)
                    }
                }
            }
            ToolbarItem(placement:.bottomOrnament){
                Button(action: {
//                    if (appModel.size == AppModel.Size.small) {
//                        appModel.size = AppModel.Size.medium
//                    } else if (appModel.size == AppModel.Size.medium) {
//                        appModel.size = AppModel.Size.large
//                        //追加
//                    }else if (appModel.size == AppModel.Size.large){
//                        
//                    }
                    //追加
                    Task {
                        if appModel.smallEntities.count < 9 {
                            if let position = generateNonOverlappingPosition(existingEntities: appModel.smallEntities) {
                                
                                if let newSmall = try? await Entity(named: "Small", in: realityKitContentBundle) {
                                    
//                                    newSmall.name = "Small_\(appModel.smallEntities.count)"
//                                    newSmall.position = SIMD3<Float>(
//                                        Float.random(in: -1...1),
//                                        0,
//                                        Float.random(in: -1...1)
//                                    )
                                    
                                    
                                    let index = appModel.smallEntities.count + 1 
                                    newSmall.name = "Small_\(index)"
                                    newSmall.position = position
                                    
                                    
//                                    newSmall.scale = SIMD3<Float>(repeating: 0.02)
                                    
                                    newSmall.components.set(InputTargetComponent())
                                    newSmall.components.set(
                                        CollisionComponent(shapes: [ShapeResource.generateBox(size: SIMD3<Float>(1.4, 1.4, 1.4))])
                                    )
                                    appModel.smallEntities.append(newSmall)
                                    // Add to array (triggers update block)
//                                    DispatchQueue.main.async {
                                        addAudioToEntity(newSmall, audioFileName: "bonsai_\(index)")
                                    
//                                    }
                                }
                                
                            }
                        }
                        
                        }
                    
                    
                    soundPlayer.playSound1()
                }) {
                    HStack {
                        Image(systemName: "square.resize.up")
                            .font(.title)
                        Text("Create a Tree🌲")
                            .font(.title)
                    }
                }
                
//                Button("increase", systemImage: "square.resize.up") {
//                    if(appModel.size == AppModel.Size.small){
//                        appModel.size = AppModel.Size.medium
//                    } else if(appModel.size == AppModel.Size.medium){
//                        appModel.size = AppModel.Size.large
//                    }
//                }
            }
            ToolbarItem(placement:.bottomOrnament){
                Button(action: {
//                    if (appModel.size == AppModel.Size.medium) {
//                        appModel.size = AppModel.Size.small
//                    } else if (appModel.size == AppModel.Size.large) {
//                        appModel.size = AppModel.Size.medium
//                    }
                    if let last = appModel.smallEntities.last {
                                last.removeFromParent()
                                appModel.smallEntities.removeLast()
                        }
                    
                }) {
                    HStack {
                        Image(systemName: "square.resize.down")
                            .font(.title)
                        Text("Delete a Tree🪵")
                            .font(.title)
                    }
                }

//                Button("descrease", systemImage: "square.resize.down") {
//                    if(appModel.size == AppModel.Size.medium){
//                        appModel.size = AppModel.Size.small
//                    } else if(appModel.size == AppModel.Size.large){
//                        appModel.size = AppModel.Size.medium
//                    }
//                }
            }
        }
        
    
    }
    private func addAudioToEntity(_ entity: Entity, audioFileName: String) {
        let audioSource = Entity()
        audioSource.spatialAudio = SpatialAudioComponent(gain: -5)
        audioSource.spatialAudio?.directivity = .beam(focus: 0.5)
        entity.addChild(audioSource)

        Task {
            do {
                let resource = try AudioFileResource.load(
                    named: audioFileName,
                    configuration: .init(shouldLoop: true)
                )
                audioSource.playAudio(resource)
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        }
    }

    func generateNonOverlappingPosition(existingEntities: [Entity], minDistance: Float = 1.0) -> SIMD3<Float>? {
        let maxAttempts = 20
        
        for _ in 0..<maxAttempts {
            // ランダムな位置（例：-2〜2の範囲）
            let randomPosition = SIMD3<Float>(
                Float.random(in: -2.0...2.0),
                0,
                Float.random(in: -2.0...2.0)
            )

            var isOverlapping = false
            for entity in existingEntities {
                let distance = simd_distance(entity.position, randomPosition)
                if distance < minDistance {
                    isOverlapping = true
                    break
                }
            }

            if !isOverlapping {
                return randomPosition
            }
        }
        
        // 見つからなかった場合は nil を返す
        return nil
    }

}

class SoundPlayer: NSObject {

    let soundData1 = NSDataAsset(name: "bonsai_create")!.data
    let soundData2 = NSDataAsset(name: "bonsai_watering")!.data
    var player: AVAudioPlayer!

    func playSound1() {
        do {
            player = try AVAudioPlayer(data: soundData1)
            player.play()
        } catch {
            print("Error: 音楽の再生に失敗しました。")
        }
    }

    func playSound2() {
        do {
            player = try AVAudioPlayer(data: soundData2)
            player.play()
        } catch {
            print("Error: 音楽の再生に失敗しました。")
        }
    }
}

class HandTracking {
    let session = ARKitSession()
    let handTracking = HandTrackingProvider()
    
    func runSession() async {
        do {
            try await session.run([handTracking])
        } catch {
            print("error starting session: \(error)")
        }
    }
    func processHandUpdates() async {
        for await update in handTracking.anchorUpdates {
            let handAnchor = update.anchor
            
            guard handAnchor.isTracked else { continue }
            
            
            
            print(handAnchor)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
