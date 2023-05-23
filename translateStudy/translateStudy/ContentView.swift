//
//  ContentView.swift
//  translateStudy
//
//  Created by Silvana Rodrigues Alves on 22/05/23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    var translationManager = TranslationManager()
    @State var fetched = false
    @State var fetchError = false
    var body: some View {
        ScrollView{
            VStack {
                Button {
                    TranslationManager.shared.fetchSupportedLanguages(completion: { (success) in
                        
                        // Check if supported languages were fetched successfully or not.
                        if success {
                            // Display languages in the tableview.
                            fetched = true
                        } else {
                            // Show an alert saying that something went wrong.
                            fetchError = true
                        }
                        
                    })
                } label: {
                    Text((!fetched && !fetchError) ? "Fetch Languages" : (fetched && !fetchError) ? "Fetched" : "Error")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background{
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color.accentColor)
                                .shadow(radius: (fetched || fetchError) ? 0 : 2, x: -2, y: 2)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color(red: 217/255, green: 217/255, blue: 217/255))
                                .opacity((fetched || fetchError) ? 0.5 : 0)
                        }
                }
                .disabled(fetched || fetchError)
                .padding(.bottom, 16)
                
                if(fetched){
                    ForEach(TranslationManager.shared.supportedLanguages, id: \.self){ language in
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
