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
    
    var body: some View {
        
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(height: 70)
                    HStack{
                        LanguagePickerView(supportedLanguages: translationManager.supportedLanguages, selectedLanguage: $selectedSourceLanguage)
                    
                        LanguagePickerView(supportedLanguages: translationManager.supportedLanguages, selectedLanguage: $selectedTargetLanguage)
                    }
                    .padding()
                }
                
                VStack(alignment: .leading) {
                    Text(selectedSourceLanguage.name!)
                        .font(.caption2)
                        .bold()
                        .padding(.leading)
                    
                    TextField("Enter text", text: $textInput)
                        .padding(.leading)
                        .font(.title2)
                        .bold()
                        .onSubmit {
                            translationManager.textToTranslate = textInput
                            translate()
                        }
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    
                    Divider()
                        .padding()
                    
                    Text(selectedTargetLanguage.name!)
                        .font(.caption2)
                        .bold()
                        .padding(.leading)
                        .padding(.bottom, 2)
                        .foregroundColor(.teal)
                    
                    Text(textOutput)
                        .font(.title2)
                        .bold()
                        .padding(.leading)
                        .foregroundColor(.teal)
                }
                
                
                Spacer()

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
        ContentView()
    }
}
