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
    @State var textInput: String = ""
    @State var textOutput: String = ""
    @State var selectedSourceLanguage = TranslationLanguage(code: "pt", name: "Portuguese")
    @State var selectedTargetLanguage = TranslationLanguage(code: "en", name: "English")
    @FocusState private var textInputIsFocused: Bool
    @State var translationHappened: Bool = false
    
    var body: some View {
        
        ZStack {
            VStack {
                Rectangle()
                    .foregroundColor(Color(.systemGray6))
                    .frame(height: 500)
                    
                Spacer()
            }
            .ignoresSafeArea()
            
            
            VStack {
                HStack{
                    LanguagePickerView(supportedLanguages: translationManager.supportedLanguages, selectedLanguage: $selectedSourceLanguage)
                
                    LanguagePickerView(supportedLanguages: translationManager.supportedLanguages, selectedLanguage: $selectedTargetLanguage)
                }
                .padding(.top)
                .padding(.horizontal)
                .padding(.bottom, 8)
                    
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .overlay {
                        VStack(alignment: .leading) {
                            if translationHappened {
                                Text(selectedSourceLanguage.name!)
                                    .foregroundColor(.black)
                                    .font(.caption2)
                                    .bold()
                                    .padding(.leading)
                                    .padding(.top)
                            }
                             
                            TextField("Enter text", text: $textInput)
                                .foregroundColor(.black)
                                .padding(.leading)
                                .font(.title2)
                                .bold()
                                .onSubmit {
                                    translationManager.textToTranslate = textInput
                                    translate()
                                    withAnimation(.spring()) {
                                        translationHappened = true
                                    }
                                    
                                }
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                            
                            if translationHappened {
                                Divider()
                                    .padding()
                                
                                Text(selectedTargetLanguage.name!)
                                    .font(.caption2)
                                    .bold()
                                    .padding(.leading)
                                    .foregroundColor(.teal)
                                
                                Text(textOutput)
                                    .font(.title2)
                                    .bold()
                                    .padding(.leading)
                                    .foregroundColor(.teal)
                            }
                            
                            
                            Spacer()
                        }
                        .padding()
                    }
                    
                    
                    
                    Spacer()

            }
        }
    }
    
    func translate(){
        translationManager.translate(completion: { (translation) in
            if let translationS = translation {
                textOutput = translationS
            } else {
                textOutput =  "error"
            }
            
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(TranslationManager())
        
    }
}
