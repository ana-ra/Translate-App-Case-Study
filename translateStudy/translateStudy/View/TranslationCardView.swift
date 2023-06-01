//
//  TranslationCardView.swift
//  translateStudy
//
//  Created by Raphael Ferezin Kitahara on 01/06/23.
//

//import SwiftUI
//
//struct TranslationCardView: View {
//    @Binding var textInput: String
//    @Binding var textInputed: String
//    @Binding var textInputIsFocused: Bool
//    @Binding var recording: Bool
//    var translationManager: TranslationManager
//    var translationHappened: Bool
//    var sourceLanguage: LanguageType
//    
//    var body: some View {
//        RoundedRectangle(cornerRadius: 10)
//            .foregroundColor(Color(colorScheme == .dark ? .systemGray6 : .white))
//            .overlay {
//                ZStack {
//
//                    // translation texts
//                    VStack(alignment: .leading, spacing: 0) {
//                        if translationHappened {
//                           
//                            if let languageName = sourceLanguage.name{
//                                Text(languageName)
//                                    .foregroundColor(.black)
//                                    .font(.caption2)
//                                    .bold()
//                                    .padding(.leading)
//                                    .padding(.top)
//                            }
//                            
//                            
//                        }
//                        
//                        if textInputIsFocused {
//                            HStack {
//                                Spacer()
//                                // X button
//                                Image(systemName: "xmark.circle.fill")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 28, height: 28)
//                                    .symbolRenderingMode(.hierarchical)
//                                    .foregroundColor(.secondary)
//                                    .onTapGesture {
//                                        withAnimation(.spring()) {
//                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                                            textInputIsFocused = false
//                                            speechRecognizer.stopTranscribing()
//                                            recording = false
//                                            
//                                        }
//                                        
//                                    }
//                            }
//                        }
//                        
//                        TextField(recording ? "Listening..." : "Enter text", text: $textInput)
//                            .padding(.leading)
//                            .font(.title2)
//                            .bold()
//                            .onTapGesture {
//                                withAnimation(.spring()) {
//                                    textInputIsFocused = true
//                                    translationManager.selectedLanguage = LanguageType.source
//                                }
//                            }
//                            .onSubmit {
//                                translationManager.textToTranslate = textInput
//                                if textInput != "" {
//                                    textInputed = textInput
//                                    translate()
//                                    
//                                    saveTranslation()
//                                    
//                                    withAnimation(.spring()) {
//                                        translationHappened = true
//                                        textInputIsFocused = false
//                                        
//                                    }
//                                    textInput = ""
//                                }
//                                
//                                
//                            }
//                            .textInputAutocapitalization(.never)
//                            .disableAutocorrection(true)
//                        
//                        if translationHappened {
//                            Divider()
//                                .padding()
//                            
//
//                            if let languageName = translationManager.targetLanguage.name{
//                                Text(languageName)
//                                    .font(.caption2)
//                                    .bold()
//                                    .padding(.leading)
//                                    .foregroundColor(.teal)
//                            }
//                            
//                            
//                            
//                            Text(textOutput)
//                                .font(.title2)
//                                .bold()
//                                .padding(.leading)
//                                .padding(.top, 2)
//                                .foregroundColor(.teal)
//                        }
//                        
//                        
//                        Spacer()
//                        
//                    }
//                }
//                .padding()
//            }
//    }
//}
//
//struct TranslationCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        TranslationCardView()
//    }
//}
