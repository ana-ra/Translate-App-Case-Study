//
//  FavoritesView.swift
//  translateStudy
//
//  Created by Silvana Rodrigues Alves on 25/05/23.
//

import SwiftUI

struct FavoritesView: View {
    @FetchRequest(sortDescriptors: []) var translations: FetchedResults<Translation>
    
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
                .padding(.leading)
                
                if translations.count == 0 {
                    Spacer()
                    VStack{
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 55, height: 55)
                            .padding(.bottom, 8)
                            .foregroundColor(.gray)
                        
                        
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
                            .padding(.leading)
                        
                        ScrollView(.vertical) {
                            ForEach(translations) { translation in
                                RecentsCardView(sourceLanguage: translation.sourceLanguage ?? "Unknown", targetLanguage: translation.targetLanguage ?? "Unknown", sourceText: translation.textInput ?? "Unknown", translatedText: translation.textOutput ?? "Unknown")
                            }
                            .padding(.horizontal)
                        }
                        

                    }
                    
                }
                Spacer()

                
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
