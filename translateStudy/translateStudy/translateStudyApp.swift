//
//  translateStudyApp.swift
//  translateStudy
//
//  Created by Silvana Rodrigues Alves on 22/05/23.
//

import SwiftUI
import Foundation

@main
struct translateStudyApp: App {
    @StateObject private var translationManager = TranslationManager()
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environmentObject(translationManager)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(.light)
        }
    }
}
