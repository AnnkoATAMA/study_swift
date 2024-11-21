//
//  MainView.swift
//  testCore
//
//  Created by takumi.matsubara on 2024/11/20.
//
import SwiftUI
struct MainView: View {
    @State var selected = 1
    
    var body: some View {
        
        TabView(selection: $selected) {
            ShakeView()
                .tabItem {
                    Label("Shake", systemImage:"circle")
                }
                .tag(1)
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "circle")
                }
                .tag(2)
        }
        .tabViewStyle(.page)
    }
}
