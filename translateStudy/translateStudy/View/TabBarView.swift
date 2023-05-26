//
//  TabBarView.swift
//  translateStudy
//
//  Created by Silvana Rodrigues Alves on 25/05/23.
//

import SwiftUI

struct TabBarView: View {
    @State private var isDarkMode = false
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Translation", systemImage: "bubble.left.and.exclamationmark.bubble.right.fill")
                }
                .preferredColorScheme(isDarkMode ? .dark : .none)
            
            CameraView()
                .tabItem {
                    Label("Camera", systemImage: "camera.fill")
                }
                .onAppear {
                    isDarkMode = true
                }
                .onDisappear {
                    isDarkMode = false
                }
            
            ConversationView()
                .tabItem {
                    Label("Conversation", systemImage: "person.2.fill")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(TranslationManager())
        
    }
}
