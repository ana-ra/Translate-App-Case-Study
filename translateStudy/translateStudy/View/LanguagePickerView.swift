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
                    //
                } label: {
                    VStack(alignment: .leading) {
                        if let languageName = selectedLanguage.name {
                            Text(languageName)
                                .foregroundColor(.black)
                        }
                        Text("US")
                            .foregroundColor(.gray)
                    }
                }
                
                
                Picker(">", selection: $selectedLanguage) {
                    ForEach(supportedLanguages, id: \.self) { language in // 4
                        if let languageName = language.name {
                            Text(languageName)
                        }
                    }
                }
            }.padding()
            
        }
    
    
    }
}

//struct LanguagePickerView_Previews: PreviewProvider {
//    @State var language = TranslationLanguage(code: "en", name: "English")
//    
//    static var previews: some View {
//        LanguagePickerView(supportedLanguages: [TranslationLanguage(code: "en", name: "English"), TranslationLanguage(code: "pt", name: "Português")], selectedLanguage: $language)
//    }
//}
