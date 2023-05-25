//
//  LanguagePickerView.swift
//  translateStudy
//
//  Created by Raphael Ferezin Kitahara on 24/05/23.
//

import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct LanguagePickerView: View {
    var supportedLanguages: [TranslationLanguage]
    @Binding var selectedLanguage: TranslationLanguage
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.white)
            .frame(height: 50)
            .overlay {
                HStack {
                    // button with language name
                    Button {
                        //
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                if let languageName = selectedLanguage.name {
                                    Text(languageName)
                                        .foregroundColor(.black)
                                        .font(.footnote)
                                }
                                Text("US")
                                    .foregroundColor(.gray)
                                    .font(.footnote)
                            }
                            .padding()
                            
                            Spacer()
                        }
                    }
                    .padding(.trailing, 0)
                    
                    // divider
                    Rectangle()
                        .foregroundColor(.gray)
                        .padding(.vertical, 0)
                        .frame(width: 2)
                    
                    // picker button
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
                            .foregroundColor(.cyan)
                    }

                }
            }.padding()
            
        }

        
    }

