//
//  RecentsCardView.swift
//  translateStudy
//
//  Created by Raphael Ferezin Kitahara on 29/05/23.
//

import SwiftUI

struct RecentsCardView: View {
    var sourceLanguage: String
    var targetLanguage: String
    var sourceText: String
    var translatedText: String
    @State var cardOpen: Bool = false
    @State var favorited: Bool = false
    
    var body: some View {
        if !cardOpen {
            HStack {
                VStack(alignment: .leading) {
                    Text(sourceLanguage)
                        .font(.callout)
                        .fontWeight(.medium)
                    
                    Text(sourceText)
                        .font(.title3)
                        .bold()
                        .padding(.bottom)
                    
                    
                    
                    Text(targetLanguage)
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
            .padding()
            .onTapGesture {
                withAnimation(.spring()) {
                    cardOpen.toggle()
                }
            }
            
        } else {
            HStack {
                // translation texts
                VStack(alignment: .leading, spacing: 0) {
                    Text(sourceLanguage)
                        .foregroundColor(.black)
                        .font(.caption2)
                        .bold()
                        .padding(.leading)
                        .padding(.top)

                    Text(sourceText)
                        .foregroundColor(.black)
                        .padding(.leading)
                        .font(.title2)
                        .bold()
                    
                    Divider()
                        .padding()
                    
                    Text(targetLanguage)
                        .font(.caption2)
                        .bold()
                        .padding(.leading)
                        .foregroundColor(.teal)

                    Text(translatedText)
                        .font(.title2)
                        .bold()
                        .padding(.leading)
                        .padding(.top, 2)
                        .foregroundColor(.teal)
                    
                    HStack {
                        Spacer()
                        
                        Image(systemName: favorited ? "star.fill" : "star")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28)
                            .foregroundColor(.teal)
                            .onTapGesture {
                                favorited.toggle()
                            }
                            
                        
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28)
                            .foregroundColor(.teal)
                            .padding(.leading, 8)
                        
                        
                    }.padding()
                    
                }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                        }
            }
            Spacer()
        }
    }
}

//struct RecentsCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecentsCardView(sourceLanguage: TranslationLanguage(code: "en", name: "English"), targetLanguage: TranslationLanguage(code: "pt", name: "Português"), sourceText: "oi", translatedText: "hi")
//    }
//}
