//
//  LanguagesView.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 16/01/24.
//

import SwiftUI

struct LanguagesView: View {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    @AppStorage("lang") private var lang: String?
    let defaultLanguage: String = "en"
    
    var body: some View {
        VStack {
            List {
                ForEach(supportedLanguages) { supportedLang in
                    LanguageItemRow(supportedLang: supportedLang)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color.white.opacity(0.07))
                        )
                        .listRowSeparator(.hidden)
                }
                
            }
            .listStyle(.plain)
            .listRowSpacing(10)
            .foregroundStyle(.primary)
            .scrollContentBackground(.hidden)
        }
        .onAppear(perform: {
            navigationVM.tabBarHidden = true
        })
        .navigationBarBackButtonHidden()
        .padding()
        .background(.themeBackgroundDarker)
        .toolbarBackground(Color.themeBackgroundDarker, for: .navigationBar)
        .navigationTitle("Language".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { ToolbarBack() }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    func LanguageItemRow(supportedLang: SupportedLanguage) -> some View {
        HStack(spacing: 20) {
            Image(supportedLang.shortName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            Text(supportedLang.displayName.localized)
                .font(.title3.bold())
            Spacer()
            if let lang, lang == supportedLang.shortName {
                Image(.selectedIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
            } else {
                Circle()
                    .stroke(lineWidth: 1.5)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.primary)
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            lang = supportedLang.shortName
                        }
                    }
            }
        }
        .frame(height: 50)
    }
    
    @ViewBuilder
    func ToolbarBack() -> some View {
        Button(action: {
            _ = navigationVM.navigationPath.popLast()
        }, label: {
            Image(systemName: "chevron.left")
                .font(.headline)
        })
        .foregroundStyle(.primary)
    }
}

#Preview {
    LanguagesView()
}
