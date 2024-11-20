import SwiftUI

struct ContentView: View {

    @State var selected = 1
    
    var body: some View {
        
        TabView(selection: $selected) {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1)
            ShakeView()
                .tabItem {
                    Label("Shake", systemImage:"circle")
                }
                .tag(2)
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "circle")
                }
                .tag(3)
        }
        .tabViewStyle(.page)
    }
}
