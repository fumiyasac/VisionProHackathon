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
    
    private var cellTitleFont: Font {
        return Font.custom("AvenirNext-Bold", size: 80.0)
    }

    // プレイヤー読み込み
    let soundPlayer = SoundPlayer()


    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("BONSAI MASTER")
                .font(cellTitleFont)

            ToggleImmersiveSpaceButton()

            Spacer()
                .frame(height: 48.0)

            HStack {
                Button(action: {
                    soundPlayer.playSound1()
                }, label: {
                    Text("音楽を流す(1)")
                })
                
                Button(action: {
                    soundPlayer.playSound2()
                }, label: {
                    Text("音楽を流す(2)")
                })
            }
        }
        .padding()
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
