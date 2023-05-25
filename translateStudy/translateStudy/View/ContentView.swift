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
                
                TextField("Enter text", text: $textInput)
                .disableAutocorrection(true)
                .onSubmit {
                    translationManager.textToTranslate = textInput
                    translate()
                }
                
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .font(Font.system(size: 24))
                .background{
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                        .overlay{
                            RoundedRectangle(cornerRadius: 8).stroke(.black, lineWidth: 1)
                        }
                        .shadow(radius: 2, x: -2, y: 2)
                }
                Text(textOutput)
                
                Spacer()

            .padding()
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
