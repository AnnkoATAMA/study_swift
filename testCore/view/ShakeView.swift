//
//  ShakeView.swift
//  testCore
//
//  Created by takumi.matsubara on 2024/11/19.
//
import SwiftUI

struct ShakeView: View {
    @State var isMatting: Bool = false
    @StateObject private var motionModel = MotionModel()
    
    var body: some View {
        VStack {
            if !isMatting {
                Button("マッチング開始") {
                    motionModel.startAccelerometer()
                    isMatting = true
                }
            }
            if isMatting {
                Text("マッチング中")
                Text("\(motionModel.motionMessage)")
                
                Button("マッチング終了") {
                    motionModel.stopAccelerometer()
                    isMatting = false
                }
            }
        }
        .onDisappear {
            // Viewが非表示になったらセンサーを停止
            motionModel.stopAccelerometer()
        }
    }
}
