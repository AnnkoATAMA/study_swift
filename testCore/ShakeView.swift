//
//  ShakeView.swift
//  testCore
//
//  Created by takumi.matsubara on 2024/11/19.
//
import SwiftUI

struct ShakeView: View {
    
    @StateObject private var motionViewModel = MotionViewModel()
    
    var body: some View {
        VStack {
            Text("マッチング中")
                .font(.largeTitle)
                .padding()
            
            Text(motionViewModel.motionMessage)
                .font(.title)
                .foregroundColor(.blue)
                .padding()
            
            Spacer()
        }
        .onDisappear {
            // Viewが非表示になったらセンサーを停止
            motionViewModel.stopAccelerometer()
        }
    }
}
