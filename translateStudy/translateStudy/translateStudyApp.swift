//
//  translateStudyApp.swift
//  translateStudy
//
//  Created by Silvana Rodrigues Alves on 22/05/23.
//

import SwiftUI

@main
struct translateStudyApp: App {
    @StateObject private var translationManager = TranslationManager()
    

    var body: some Scene {
        
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Translation", systemImage: "bubble.left.and.bubble.right")
                    }
                ContentView()
                    .tabItem {
                        Label("Camera", systemImage: "camera.fill")
                    }
                ContentView()
                    .tabItem {
                        Label("Conversation", systemImage: "person.2.fill")
                    }
                ContentView()
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                    }
            }
            .foregroundColor(.accentColor)
            .environmentObject(translationManager)
        }
    }
}
