//
//  FavoritesView.swift
//  translateStudy
//
//  Created by Silvana Rodrigues Alves on 25/05/23.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        VStack() {
            HStack() {
                Text("Favorites")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding(.top, 16)
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
            Spacer()
        }
        .padding()
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
