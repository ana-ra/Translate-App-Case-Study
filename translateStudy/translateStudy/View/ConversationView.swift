//
//  ConversationView.swift
//  translateStudy
//
//  Created by Silvana Rodrigues Alves on 25/05/23.
//

import SwiftUI

struct ConversationView: View {
    var body: some View {
        VStack() {
            HStack() {
                Text("Conversations")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding(.top, 16)
            Spacer()
            
            VStack{
                Image(systemName: "figure.2.arms.open")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 55, height: 55)
                    .padding(.bottom, 8)
                    .foregroundColor(.gray)
                Text("No conversations")
                    .bold()
                    .font(.title2)
                Text("Your conversations translataions will appear here.")
                    .foregroundColor(Color(.gray))
                    .font(.subheadline)
                
            }
            Spacer()
        }
        .padding()
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView()
    }
}
