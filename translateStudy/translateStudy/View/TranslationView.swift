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
    @State var textInputed: String = ""
    @State var textOutput: String = ""
    @State private var textInputIsFocused: Bool = false

    @State var translationHappened: Bool = false
    @State var selectedLanguage: LanguageType = LanguageType.none
    
    @StateObject var speechRecognizer = SpeechRecognizer()
    
    @State var recording: Bool = false
    
    @Environment(\.managedObjectContext) var moc
    
    
    
    var body: some View {
        
        ZStack {
            VStack {
                // page background
                Rectangle()
                    .foregroundColor(Color(.systemGray6))
                    
                Spacer()
            }
            .ignoresSafeArea(.all, edges: .top)
            
            ZStack {
                // page content
                VStack(alignment: .leading, spacing: 0) {
                    
                    // page title
                    Text("Translation")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                        .padding(.leading)
                    
                    // language pickers
                    HStack{

                        LanguagePickerView(languageType: LanguageType.source, selectedLanguage: $selectedLanguage)
                            .onChange(of: translationManager.sourceLanguage, perform: { newLanguage in
                                speechRecognizer.setLocale(newLanguage.code)
                            })

                        LanguagePickerView(languageType: LanguageType.target, selectedLanguage: $selectedLanguage)
                            .onChange(of: translationManager.sourceLanguage, perform: { newLanguage in
                                speechRecognizer.setLocale(newLanguage.code)
                            })
                        
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
                                    
                                    
                                    // translation texts
                                    VStack(alignment: .leading, spacing: 0) {
                                        if translationHappened {
                                           
                                            if let languageName = translationManager.sourceLanguage.name{
                                                Text(languageName)
                                                    .foregroundColor(.black)
                                                    .font(.caption2)
                                                    .bold()
                                                    .padding(.leading)
                                                    .padding(.top)
                                            }
                                            
                                            
                                        }
                                        
                                        if textInputIsFocused {
                                            HStack {
                                                Spacer()
                                                // X button
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
                                                            speechRecognizer.stopTranscribing()
                                                            recording = false
                                                            
                                                        }
                                                        
                                                    }
                                            }
                                        }
                                        
                                        TextField(recording ? "Listening..." : "Enter text", text: $textInput)
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
                                                    textInputed = textInput
                                                    translate()
                                                    
                                                    saveTranslation()
                                                    
                                                    withAnimation(.spring()) {
                                                        translationHappened = true
                                                        textInputIsFocused = false
                                                        
                                                    }
                                                    textInput = ""
                                                }
                                                
                                                
                                            }
                                            .textInputAutocapitalization(.never)
                                            .disableAutocorrection(true)
                                        
                                        if translationHappened {
                                            Divider()
                                                .padding()
                                            

                                            if let languageName = translationManager.targetLanguage.name{
                                                Text(languageName)
                                                    .font(.caption2)
                                                    .bold()
                                                    .padding(.leading)
                                                    .foregroundColor(.teal)
                                            }
                                            
                                            
                                            
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
                        if !textInputIsFocused {
                            // translated text card
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .overlay {
                                    ZStack {
                                        // translation texts
                                        VStack(alignment: .leading, spacing: 0) {
                                            
                                            
                                            if let languageName = translationManager.sourceLanguage.name{
                                                Text(languageName)
                                                    .foregroundColor(.black)
                                                    .font(.caption2)
                                                    .bold()
                                                    .padding(.leading)
                                                    .padding(.top)
                                            }
                                            
                                            
                                            Text(textInputed)
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
                                                        
                                                        saveTranslation()
                                                        
                                                        
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
                                            
                                            
                                            if let languageName = translationManager.targetLanguage.name{
                                                Text(languageName)
                                                    .font(.caption2)
                                                    .bold()
                                                    .padding(.leading)
                                                    .foregroundColor(.teal)
                                            }
                                            
                                            
                                            
                                            
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
                        }
                        
                        
                        // new translation card
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .overlay {
                                // translation texts
                                VStack(alignment: .leading, spacing: 0) {
                                    
                                    if textInputIsFocused {
                                        HStack {
                                            Spacer()
                                            // X button
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
                                                        textInput = ""
                                                        speechRecognizer.stopTranscribing()
                                                        recording = false
                                                    }
                                                    
                                                }
                                        }
                                    }
                                    
                                    TextField(recording ? "Listening..." : "Enter text", text: $textInput)
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
                                                textInputed = textInput
                                                translate()
                                                
                                                saveTranslation()
                                                
                                                withAnimation(.spring()) {
                                                    translationHappened = true
                                                    textInputIsFocused = false
                                                    
                                                }
                                                textInput = ""
                                            }
                                            
                                            
                                        }
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                    
                                    Spacer()
                                    
                                }
                                .padding()
                                
                            }
                    }
                }
                .padding(.top, 16)
                
                // microphone button and recording waves
                VStack {
                    Spacer()
                    if recording {
                        WaveView()
                            .padding(.bottom)
                    }
                    
                    Image(systemName: recording ? "mic.circle" : "mic.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 55)
                        .foregroundColor(.teal)
                        .onTapGesture {
                            if !recording {
                                speechRecognizer.resetTranscript()
                                speechRecognizer.startTranscribing()
                                withAnimation(.spring()) {
                                    recording = true
                                    textInputIsFocused = true
                                }
                                
                            } else {
                                speechRecognizer.stopTranscribing()
                                recording = false
                                textInput = speechRecognizer.transcript
                                if textInput != "" {
                                    withAnimation(.spring()) {
                                        translationManager.textToTranslate = textInput
                                        translate()
                                        
                                        saveTranslation()
                                        
                                        
                                        translationHappened = true
                                        textInputed = textInput
                                        textInput = ""
                                        textInputIsFocused = false
                                    }
                                }
                            }
                        }
                        
                }
                .padding(.bottom)
            }
        }
        .task{
            await translationManager.setup()
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
    
    func saveTranslation() {
        //Handling Core Data
        let translationData = Translation(context: moc)
        translationData.sourceLanguage = translationManager.sourceLanguage.name
        translationData.targetLanguage = translationManager.targetLanguage.name
        translationData.textInput = textInput
        translationData.textOutput = textOutput
        translationData.id = UUID()
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(TranslationManager())
        
    }
}
