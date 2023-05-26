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
            TabBarView()
                .environmentObject(translationManager)

        }
    }
}
