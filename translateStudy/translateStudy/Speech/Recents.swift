//
//  Recents.swift
//  translateStudy
//
//  Created by Luiza Souza on 26/05/23.
//

import Foundation

struct Recents: Identifiable, Codable {
    let id: UUID
    var transcript: String?
    
    init(id: UUID = UUID(), transcript: String? = nil) {
        self.id = id
        self.transcript = transcript
    }
}
