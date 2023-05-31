//
//  DataController.swift
//  translateStudy
//
//  Created by Luiza Souza on 31/05/23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DataModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: ) \(error.localizedDescription)")
            }
        }
    }
}

