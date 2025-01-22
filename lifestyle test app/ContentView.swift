//
//  ContentView.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 06/01/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapWithTasksView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Map")
                }
            
            SpeechRecognitionView()
                .tabItem {
                    Label("Voice logging", systemImage: "2.circle")
                }
            
            // Add ur views here --
            
        }
    }
}

#Preview {
    ContentView()
}
