//
//  StoriesView.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 04/12/23.
//

import SwiftUI

struct StoriesView: View {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    @EnvironmentObject private var paywallVM: PaywallViewModel
    @StateObject private var storiesVM: StoriesViewModel = StoriesViewModel()
    @AppStorage("paid") private var paid: Bool = false
    
    let columns: [GridItem] = [
        .init(.flexible()),
        .init(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 10, content: {
                ForEach(storiesVM.stories) { story in
                    VStack(alignment: .leading, content: {
                        Image(story.image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 12.0))
                        Text(story.title.localized)
                            .lineLimit(1)
                        if let duration = story.duration {
                            Text("\(duration) mins".localized)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(5)
                    .onTapGesture {
                        navigationVM.navigationPath.append(.player(story.id, story.type))
                    }
                }
            })
        }
        .background(.themeBackgroundDarker)
        .toolbarBackground(Color.themeBackgroundDarker, for: .navigationBar)
        .navigationTitle("Bedtime Stories ✨".localized)
    }
}

#Preview {
    NavigationStack {
        StoriesView()
            .preferredColorScheme(.dark)
    }
}
