//
//  LanguagePickerView.swift
//  translateStudy
//
//  Created by Raphael Ferezin Kitahara on 24/05/23.
//

import SwiftUI

struct LanguagePickerView: View {
    var supportedLanguages: [TranslationLanguage]
    @Binding var selectedLanguage: TranslationLanguage
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
        .foregroundColor(.white)
        .overlay {
            
            
            HStack {
                Button {
                } label: {
                    VStack(alignment: .leading) {
                        if let languageName = selectedLanguage.name {
                            Text(languageName)
                                .font(.system(size: 15))
                                .foregroundColor(.black)
                        }
                        Text("US")
                            .foregroundColor(.gray)
                    }
                }
                
                Text("|")
                
                Menu {
                    Picker(selection: $selectedLanguage, label: Text(">")) {
                        ForEach(supportedLanguages, id: \.self) { language in // 4
                            if let languageName = language.name {
                                Text(languageName)
                                
                            }
                        }
                    }
                }
                label: {
                    Label("", systemImage: "chevron.down")
                }
            }.padding()
            
        }
    
    
    }
}
