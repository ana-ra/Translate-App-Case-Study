//
//  ContentView.swift
//  translateStudy
//
//  Created by Silvana Rodrigues Alves on 22/05/23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var translationManager: TranslationManager
    @State var fetched = false
    @State var fetchError = false
    var body: some View {
        ScrollView{
            VStack {
                Text("Languages Fetched:")
                    .font(.system(size: 50))
                
                if(translationManager.fetched){
                    ForEach(translationManager.supportedLanguages, id: \.self){ language in
                        HStack{
                            if let code = language.code {
                                Text(code)
                            }
                            Text("-")
                            if let name = language.name {
                                Text(name)
                            }
                            
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    func changeFetchStatus(){
        fetched.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
