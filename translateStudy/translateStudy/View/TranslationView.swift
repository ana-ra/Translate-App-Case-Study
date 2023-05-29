//
//  ContentView.swift
//  translateStudy
//
//  Created by Silvana Rodrigues Alves on 22/05/23.
//

import Foundation
import SwiftUI

enum LanguageType {
    case source
    case target
    case none
}

struct TranslationView: View {
    @EnvironmentObject var translationManager: TranslationManager
    @State var textInput: String = ""
    @State var textOutput: String = ""
    @State var selectedSourceLanguage = TranslationLanguage(code: "pt", name: "Portuguese")
    @State var selectedTargetLanguage = TranslationLanguage(code: "en", name: "English")
    @State private var textInputIsFocused: Bool = false

    @State var translationHappened: Bool = false
    @State var selectedLanguage: LanguageType = LanguageType.none
    
    @StateObject var speechRecognizer = SpeechRecognizer()
    
    @State var recording: Bool = false
    
    var body: some View {
        
        ZStack {
            VStack {
                // page background
                Rectangle()
                    .foregroundColor(Color(.systemGray6))
                    
                Spacer()
            }
            .ignoresSafeArea(.all, edges: .top)
            
            VStack(alignment: .leading, spacing: 0) {
                // page title
                Text("Translation")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .padding(.leading)
                
                // language pickers
                HStack{

                    LanguagePickerView(supportedLanguages: translationManager.supportedLanguages, pickerLanguage: $selectedSourceLanguage, languageType: LanguageType.source, selectedLanguage: $selectedLanguage)
                    
                    LanguagePickerView(supportedLanguages: translationManager.supportedLanguages, pickerLanguage: $selectedTargetLanguage, languageType: LanguageType.target, selectedLanguage: $selectedLanguage)
                    
                }
                .padding(.top)
                .padding(.horizontal)
                .padding(.bottom, 12)
                
                // translation card
                if translationHappened == false {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .overlay {
                            ZStack {
                                // microphone button
                                VStack {
                                    Spacer()
                                    Image(systemName: "mic.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 55)
                                        .foregroundColor(.teal)
                                        .onTapGesture {
                                            if !recording {
                                                speechRecognizer.resetTranscript()
                                                speechRecognizer.startTranscribing()
                                                recording = true
                                            } else {
                                                speechRecognizer.stopTranscribing()
                                                recording = false
                                                textInput = speechRecognizer.transcript
                                                translationManager.textToTranslate = textInput
                                                translate()
                                                translationHappened = true
                                                textInput = ""
                                            }
                                        }
                                }
                                
                                // translation texts
                                VStack(alignment: .leading, spacing: 0) {
                                    if translationHappened {
                                        Text(selectedSourceLanguage.name!)
                                            .foregroundColor(.black)
                                            .font(.caption2)
                                            .bold()
                                            .padding(.leading)
                                            .padding(.top)
                                    }
                                    
                                    if textInputIsFocused {
                                        HStack {
                                            Spacer()
                                            Image(systemName: "xmark.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 28, height: 28)
                                                .symbolRenderingMode(.hierarchical)
                                                .foregroundColor(.secondary)
                                                .onTapGesture {
                                                    withAnimation(.spring()) {
                                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                        textInputIsFocused = false
                                                    }
                                                    
                                                }
                                        }
                                    }
                                    
                                    TextField("Enter text", text: $textInput)
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                        .font(.title2)
                                        .bold()
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                textInputIsFocused = true
                                                selectedLanguage = LanguageType.source
                                            }
                                        }
                                        .onSubmit {
                                            translationManager.textToTranslate = textInput
                                            if textInput != "" {
                                                translate()
                                                withAnimation(.spring()) {
                                                    translationHappened = true
                                                    textInputIsFocused = false
                                                    
                                                }
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
                                            .padding(.top, 2)
                                            .foregroundColor(.teal)
                                    }
                                    Spacer()
                                    
                                }
                            }
                            .padding()
                        }
                        
                        Spacer()
                } else {
                    // translated text card
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .overlay {
                            ZStack {
                                // translation texts
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(selectedSourceLanguage.name!)
                                        .foregroundColor(.black)
                                        .font(.caption2)
                                        .bold()
                                        .padding(.leading)
                                        .padding(.top)
                                    
                                    Text(textInput)
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                        .font(.title2)
                                        .bold()
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                textInputIsFocused = true
                                                selectedLanguage = LanguageType.source
                                            }
                                        }
                                        .onSubmit {
                                            translationManager.textToTranslate = textInput
                                            if textInput != "" {
                                                translate()
                                                withAnimation(.spring()) {
                                                    translationHappened = true
                                                    textInputIsFocused = false
                                                    
                                                }
                                            }
                                            
                                            
                                        }
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                    
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
                                        .padding(.top, 2)
                                        .foregroundColor(.teal)
                                    Spacer()
                                    
                                }
                            }
                            .padding()
                        }
                        .padding(.bottom, 8)
                    
                    // new translation card
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .overlay {
                            ZStack {
                                // microphone button
                                VStack {
                                    Spacer()
                                    Image(systemName: "mic.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 55)
                                        .foregroundColor(.teal)
                                        .onTapGesture {
                                            if !recording {
                                                speechRecognizer.resetTranscript()
                                                speechRecognizer.startTranscribing()
                                                recording = true
                                            } else {
                                                speechRecognizer.stopTranscribing()
                                                recording = false
                                                textInput = speechRecognizer.transcript
                                                translationManager.textToTranslate = textInput
                                                translate()
                                                translationHappened = true
                                            }
                                        }
                                }
                                
                                // translation texts
                                VStack(alignment: .leading, spacing: 0) {
                                    
                                    if textInputIsFocused {
                                        HStack {
                                            Spacer()
                                            Image(systemName: "xmark.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 28, height: 28)
                                                .symbolRenderingMode(.hierarchical)
                                                .foregroundColor(.secondary)
                                                .onTapGesture {
                                                    withAnimation(.spring()) {
                                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                        textInputIsFocused = false
                                                    }
                                                    
                                                }
                                        }
                                    }
                                    
                                    TextField("Enter text", text: $textInput)
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                        .font(.title2)
                                        .bold()
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                textInputIsFocused = true
                                                selectedLanguage = LanguageType.source
                                            }
                                        }
                                        .onSubmit {
                                            translationManager.textToTranslate = textInput
                                            if textInput != "" {
                                                translate()
                                                withAnimation(.spring()) {
                                                    translationHappened = true
                                                    textInputIsFocused = false
                                                    
                                                }
                                            }
                                            
                                            
                                        }
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                    
                                }
                            }
                            .padding()
                        }
                    
                }
                

            }
            .padding(.top, 16)
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
