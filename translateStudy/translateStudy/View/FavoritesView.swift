//
//  FavoritesView.swift
//  translateStudy
//
//  Created by Silvana Rodrigues Alves on 25/05/23.
//

import SwiftUI

struct FavoritesView: View {
    @State var favoritesEmpty = false
    
    var body: some View {
        ZStack {
            // page background
            Rectangle()
                .foregroundColor(Color(.systemGray6))
                .ignoresSafeArea()
            
            VStack() {
                HStack() {
                    Text("Favorites")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding(.top, 16)
                
                if favoritesEmpty {
                    Spacer()
                    VStack{
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 55, height: 55)
                            .padding(.bottom, 8)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                favoritesEmpty = false
                            }
                        
                        
                        Text("No Favorites")
                            .bold()
                            .font(.title2)
                        Text("Your favorite translataions will appear here.")
                            .foregroundColor(Color(.gray))
                            .font(.subheadline)
                        
                    }
                    
                } else {
                    VStack(alignment: .leading) {
                        Text("Recents")
                            .font(.title2)
                            .bold()
                            .padding(.top, 4)
                            .padding(.bottom)
                        
                        RecentsCardView(sourceLanguage: TranslationLanguage(code: "en", name: "English"), targetLanguage: TranslationLanguage(code: "pt", name: "Português"), sourceText: "oi", translatedText: "hi")
                    }
                    
                }
                Spacer()

                
            }
            .padding()
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
