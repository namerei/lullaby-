//
//  SettingsView.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 04/12/23.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    @EnvironmentObject private var navigationVM: NavigationViewModel
    @StateObject private var settingsVM: SettingsViewModel = SettingsViewModel()
    
    @AppStorage("passed_parent_test") private var passedParentTest: Bool = false
    @State private var showParentTestQuestion: Bool = false
    
    var body: some View {
        List {
            HStack {
                Text("Rate the app".localized)
                Spacer()
                Image(systemName: "star")
            }
            .onTapGesture {
                requestReview()
            }
            .listRowBackground(Color.white.opacity(0.07))
            
            Button {
                navigationVM.navigationPath.append(.chooseLanguage)
            } label: {
                HStack {
                    Text("Choose language".localized)
                    Spacer()
                    Image(systemName: "globe")
                }
            }
            .listRowBackground(Color.white.opacity(0.07))
            
//            if passedParentTest {
//                Link(destination: URL(string: "mailto:krutov89bk@gmail.com")!) {
//                    HStack {
//                        Text("Contact us".localized)
//                        Spacer()
//                        Image(systemName: "envelope")
//                    }
//                }
//                .listRowBackground(Color.white.opacity(0.07))
//            } else {
//                Button(action: {
//                    showParentTestQuestion = true
//                }, label: {
//                    HStack {
//                        Text("Contact us".localized)
//                        Spacer()
//                        Image(systemName: "envelope")
//                    }
//                })
//                .listRowBackground(Color.white.opacity(0.07))
//            }
            
//            if passedParentTest {
//                Button {
//                    Task {
//                        do {
//                            try await settingsVM.deleteCache()
//                        } catch {
//                            print(error)
//                        }
//                    }
//                } label: {
//                    Text("Clear cache".localized)
//                }
//                .listRowBackground(Color.white.opacity(0.07))
//            } else {
//                Button(action: {
//                    showParentTestQuestion = true
//                }, label: {
//                    Text("Clear cache".localized)
//                })
//                .listRowBackground(Color.white.opacity(0.07))
//            }
//            
//            if passedParentTest {
//                Link("Privacy policy".localized, destination: URL(string: "https://evgenii-krutov.jimdosite.com")!)
//                    .listRowBackground(Color.white.opacity(0.07))
//            } else {
//                Button(action: {
//                    showParentTestQuestion = true
//                }, label: {
//                    Text("Privacy policy".localized)
//                })
//                .listRowBackground(Color.white.opacity(0.07))
//            }
            Button {
                navigationVM.navigationPath.append(.privacy)
            } label: {
                Text("Privacy policy".localized)
            }
            .listRowBackground(Color.white.opacity(0.07))
            Button {
                navigationVM.navigationPath.append(.termsOfUse)
            } label: {
                Text("Terms of use".localized)
            }
            .listRowBackground(Color.white.opacity(0.07))
//            if passedParentTest {
//                Link("Terms of use".localized, destination: URL(string: "https://evgenii-krutov.jimdosite.com/terms-of-use/")!)
//                    .listRowBackground(Color.white.opacity(0.07))
//            } else {
//                Button(action: {
//                    showParentTestQuestion = true
//                }, label: {
//                    Text("Terms of use".localized)
//                })
//                .listRowBackground(Color.white.opacity(0.07))
//            }
        }
        .onAppear(perform: {
            showParentTestQuestion = true
        })
        .sheet(isPresented: $showParentTestQuestion, content: {
            ParentTestQuestionView()
        })
        .sheet(isPresented: $settingsVM.isDeleting, content: {
            VStack {
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.themeBackgroundDarker.opacity(0.2))
        })
        .background(.themeBackgroundDarker)
        .foregroundStyle(.primary)
        .scrollContentBackground(.hidden)
        .toolbarBackground(Color.themeBackgroundDarker, for: .navigationBar)
        .navigationTitle("Settings ⚙️".localized)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}
