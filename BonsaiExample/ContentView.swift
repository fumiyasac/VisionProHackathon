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

struct ContentView: View {

    @Environment(AppModel.self) private var appModel
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    private var cellTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 80.0)
    }

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
        }
        .toolbar{
            ToolbarItem(placement:.bottomOrnament){
                Button("New", systemImage: "pencil") {
                    // new action
                }
            }
            ToolbarItem(placement:.bottomOrnament){
                Button("New", systemImage: "pencil") {
                    // new action
                }
            }
            ToolbarItem(placement:.bottomOrnament){
                Button("increase", systemImage: "square.resize.up") {
                    if(appModel.size == AppModel.Size.small){
                        appModel.size = AppModel.Size.medium
                    } else if(appModel.size == AppModel.Size.medium){
                        appModel.size = AppModel.Size.large
                    }
                }
            }
            ToolbarItem(placement:.bottomOrnament){
                Button("descrease", systemImage: "square.resize.down") {
                    if(appModel.size == AppModel.Size.medium){
                        appModel.size = AppModel.Size.small
                    } else if(appModel.size == AppModel.Size.large){
                        appModel.size = AppModel.Size.medium
                    }
                }
            }
        }
    }
}

class SoundPlayer: NSObject {

    let soundData1 = NSDataAsset(name: "cut_kusa")!.data
    let soundData2 = NSDataAsset(name: "mushiru_kusa")!.data
    var player : AVAudioPlayer!

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

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
