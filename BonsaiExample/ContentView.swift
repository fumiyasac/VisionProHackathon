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
                    if (appModel.size == AppModel.Size.small) {
                        appModel.size = AppModel.Size.medium
                    } else if (appModel.size == AppModel.Size.medium) {
                        appModel.size = AppModel.Size.large
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
                    if (appModel.size == AppModel.Size.medium) {
                        appModel.size = AppModel.Size.small
                    } else if (appModel.size == AppModel.Size.large) {
                        appModel.size = AppModel.Size.medium
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
