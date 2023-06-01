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
    @State var selectedLanguage = -1
    
    @StateObject var speechRecognizer = SpeechRecognizer()
    
    @State var recording: Bool = false
    
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.colorScheme) var colorScheme
    
    
    
    var body: some View {
        
        ZStack {
            VStack {
                // page background
                Rectangle()
                    .foregroundColor(Color(colorScheme == .dark ? .black : .systemGray6))
            }
            .ignoresSafeArea(.all)
            
            ZStack {
                // page content
                VStack(alignment: .leading, spacing: 0) {
                    
                    // page title and ... button
                    HStack(alignment: .bottom) {
                        Text("Translation")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .foregroundColor(.teal)
                            .padding(.trailing)
                            .padding(.bottom, 8)
                    }
                    
                    
                    // language pickers
                    HStack{

                        LanguagePickerView(pickerID: 0, selectedLanguage: $selectedLanguage)
                            .onChange(of: translationManager.sourceLanguage, perform: { newLanguage in
                                speechRecognizer.setLocale(newLanguage.code)
                            })

                        LanguagePickerView(pickerID: 1, selectedLanguage: $selectedLanguage)
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
                            .foregroundColor(Color(colorScheme == .dark ? .systemGray6 : .white))
                            .overlay {
                                // translation texts
                                VStack(alignment: .leading, spacing: 0) {
                                    if translationHappened {
                                       
                                        if let languageName = translationManager.sourceLanguage.name{
                                            Text(languageName)
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
                                                .padding(.horizontal)
                                                .padding(.top)
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
                                        .padding()
                                        .padding(.leading)
                                        .font(.title2)
                                        .bold()
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                if selectedLanguage == -1 {
                                                    selectedLanguage = 0
                                                }
                                                textInputIsFocused = true
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
                                    } else {
                                        Spacer()
                                        // microphone button and recording waves
                                        VStack {
                                            Spacer()
                                            if recording {
                                                WaveView()
                                                    .padding(.bottom)
                                            }
                                            
                                            HStack {
                                                Spacer()
                                                
                                                Image(systemName: recording ? "mic.circle" : "mic.circle.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 55)
                                                    .foregroundColor(.teal)
                                                    .padding()
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
                                                
                                                Spacer()
                                            }
                                            
                                                
                                        }

                                    }

                                    Spacer()
                                    
                                }
                            }
                            .padding(.horizontal)
                            
                            Spacer()
                    } else {
                        if !textInputIsFocused {
                            // translated text card
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(colorScheme == .dark ? .systemGray6 : .white))
                                .overlay {
                                    // translation texts
                                    VStack(alignment: .leading, spacing: 0) {
                                        
                                        
                                        if let languageName = translationManager.sourceLanguage.name{
                                            Text(languageName)
                                                .font(.caption2)
                                                .bold()
                                                .padding(.leading)
                                                .padding(.top)
                                        }
                                        
                                        
                                        Text(textInputed)
                                            .padding(.leading)
                                            .font(.title2)
                                            .bold()
                                            .onTapGesture {
                                                withAnimation(.spring()) {
                                                    textInputIsFocused = true
                                                    textInput = textInputed

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
                                    .padding()
                                    
                                }
                                .padding(.bottom, 8)
                                .padding(.horizontal)
                        }
                        
                        
                        // new translation card
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(colorScheme == .dark ? .systemGray6 : .white))
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
                                                .padding(.top)
                                                .padding(.horizontal)
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
                                        .padding(.leading)
                                        .font(.title2)
                                        .bold()
                                        .padding()
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                if selectedLanguage == -1 {
                                                    selectedLanguage = 0
                                                }
                                                textInputIsFocused = true
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
                                    
                                    // microphone button and recording waves
                                    VStack {
                                        Spacer()
                                        if recording {
                                            WaveView()
                                                .padding(.bottom)
                                        }
                                        
                                        HStack {
                                            Spacer()
                                            
                                            Image(systemName: recording ? "mic.circle" : "mic.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 55)
                                                .foregroundColor(.teal)
                                                .padding()
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
                                            
                                            Spacer()
                                        }
                                        
                                            
                                    }
                                    
                                }
                                
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 4)
                    }
                }
                .padding(.top, 16)
                
                
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
