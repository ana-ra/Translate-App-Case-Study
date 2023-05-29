//
//  RecentsCardView.swift
//  translateStudy
//
//  Created by Raphael Ferezin Kitahara on 29/05/23.
//

import SwiftUI

struct RecentsCardView: View {
    var sourceLanguage: TranslationLanguage
    var targetLanguage: TranslationLanguage
    var sourceText: String
    var translatedText: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(sourceLanguage.name!)
                    .font(.callout)
                    .fontWeight(.medium)
                
                Text(sourceText)
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                
                
                
                Text(targetLanguage.name!)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.teal)
                
                Text(translatedText)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.teal)
            }
            .padding()
            
            Spacer()
             
        }.background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
        }
        

    }
}

struct RecentsCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecentsCardView(sourceLanguage: TranslationLanguage(code: "en", name: "English"), targetLanguage: TranslationLanguage(code: "pt", name: "Português"), sourceText: "oi", translatedText: "hi")
    }
}
