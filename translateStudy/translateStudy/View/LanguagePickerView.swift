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
    @State var selected: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
        .foregroundColor(.white)
        .frame(height: 50)
        .overlay {
            HStack {
                // button with language name
                Button {
                    if !selected {
                        selected.toggle()
                    }
                    
                } label: {
                    HStack {
                        if selected {
                            Image(systemName: "smallcircle.filled.circle.fill")
                                .foregroundStyle(.teal, .teal.opacity(0.5))
                                .font(.subheadline)
                                .padding(.leading)
                        } else {
                            Image(systemName: "smallcircle.filled.circle.fill")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .padding(.leading)
                        }
                        
                        
                        VStack(alignment: .leading) {
                            if let languageName = selectedLanguage.name {
                                Text(languageName)
                                    .foregroundColor(.black)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
//                            Text("US")
//                                .foregroundColor(.gray)
//                                .font(.footnote)
                        }
                        
                        Spacer()
                    }
                }
                .padding(.trailing, 0)
                
                // divider
                Rectangle()
                    .foregroundColor(Color(.systemGray6))
                    .padding(.vertical, 0)
                    .frame(width: 2)
                
                // picker button
                Menu {
                    Picker(selection: $selectedLanguage, label: Text("")) {
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
                        .font(.callout)
                        .padding(.bottom, 2)
                }
            }
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
