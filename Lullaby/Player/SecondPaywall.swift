//
//  SecondPaywall.swift
//  Lullaby
//
//  Created by namerei on 24.09.2025.
//

import SwiftUI
import RevenueCat

struct PaywallLifetimeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var offering: Offering? = nil
    @State private var package: Package? = nil
    @State private var pending: Bool = false
//    @Environment(PaywallObservable.self) private var observable
    
    var body: some View {
//        @Bindable var observable = observable
        
        ZStack {
            ScrollView {
                content
                    .padding(.horizontal, 26)
                    .frame(maxWidth: .infinity)
                    .background {
                        UnevenRoundedRectangle(cornerRadii:
                                .init(topLeading: 32, topTrailing: 32))
                        .fill(.accent)
                    }
            }
            .task {
                let offerings = try? await Purchases.shared.offerings()
                await MainActor.run {
                    self.offering = offerings?.all["lifetime"]
                    self.package = self.offering?.availablePackages[0]
                }
            }
            .navigationBarBackButtonHidden()
            .ignoresSafeArea()
//            .defaultScrollAnchor(.bottom)
            .background {
//                Image(.paywallLifetimeBackground)
//                    .resizable()
//                    .scaledToFill()
//                    .ignoresSafeArea()
//                    .padding(.bottom, 50)
            }
            .overlay {
                VStack {
                    Button {
                        dismiss()
                    } label: {
//                        Image(.paywallExitIcon)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 26, height: 26)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    Spacer()
                }
                .padding()
                .padding(.vertical, 20)
                .padding(.top, 20)
            }
            
            
            if pending {
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                    .ignoresSafeArea()
                    .overlay {
                        if #available(iOS 26.0, *) {
                            ProgressView()
                                .padding()
//                                .glassEffect()
                        } else {
                            ProgressView()
                                .padding()
                                .background(Color.black.opacity(0.75))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
            }
            
            
        }
        .ignoresSafeArea()
//        .onChange(of: observable.purchasedProducts) { _, newValue in
//            if !newValue.isEmpty { dismiss() }
//        }
//        .onAppear {
//            if observable.premiumGranted { dismiss() }
//            AmplitudeManager.shared.amplitude.track(eventType: "lifetime_paywall_opened")
//        }
        
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private var content: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("Don’t want another subscription?")
                .font(.title)
                .fontWeight(.bold)
//                .foregroundStyle(.maProductItemBG)
                .padding(.top, 26)
            
            Text("Get lifetime access!")
                .font(.title3)
                .fontWeight(.semibold)
//                .foregroundStyle(.maMain)
                .padding(.top, 21)
                .padding(.bottom)
            
            Group {
                textWithIcon(String(localized: "Only billed once"))
                textWithIcon(String(localized: "No recurring charges"))
                textWithIcon(String(localized: "Use the app anytime, forever"))
            }
            .padding(.bottom, 8)
            
            Group {
                Text("\(package?.localizedPriceString ?? "-") / \(package?.storeProduct.localizedTitle ?? "")")
                    .font(.system(size: 19, weight: .bold))
                    .padding(.top, 30)
                Text("One-time opportunity")
                    .font(.system(size: 14))
            }
//            .foregroundStyle(.maProductItemBG)
            .frame(maxWidth: .infinity)
            
            MA_PrimaryButton(title: "Purchase") {
                Task.detached {
                    await self.paywallLifetimeRCPurchase()
                }
            }
            .padding(.top, 40)
            
            privacyView
                .padding(.top, 26)
                .padding(.bottom, 46)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func textWithIcon(_ text: String) -> some View {
        HStack(spacing: 15) {
            //FIXME: -
//            Image(.done)
            Text(text)
                .font(.system(size: 19))
//                .foregroundStyle(.maProductItemBG)
        }
    }
    
    private var privacyView: some View {
        HStack {
            Link("Terms", destination: URL(string: "https://sites.google.com/view/melaniya90/terms-of-use")!)
            Link("Privacy policy", destination: URL(string: "https://sites.google.com/view/melaniya90/privacy-policy")!)
            Button("Restore") {
            }
        }
        .frame(maxWidth: .infinity)
//        .foregroundStyle(Color.maProductItemBG)
        .font(.caption)
    }
    
    
    private func paywallLifetimeRCPurchase() async {
        do {
            guard let package = self.package else { throw URLError(.unknown) }
            await MainActor.run {
                self.pending = true
            }
            AmplitudeManager.shared.amplitude.track(eventType: "lifetime_paywall_purchase_button_clicked")
            
            let result = try await Purchases.shared.purchase(package: package)
            
            AmplitudeManager.shared.amplitude.track(eventType: "lifetime_paywall_purchase_successful", eventProperties: [
                "transactionId": result.transaction?.id ?? "",
                "productId": package.storeProduct.sk2Product?.id ?? "",
                "productName": package.storeProduct.sk2Product?.displayName ?? "",
                "productPrice": NSDecimalNumber(decimal: package.storeProduct.sk2Product?.price ?? 0.0).doubleValue,
                "productCurrencyCode": package.storeProduct.sk2Product?.priceFormatStyle.currencyCode ?? ""
            ])
            
//            await observable.updateCustomerProductStatus()
            
            await MainActor.run {
                self.pending = false
            }
        } catch {
            AmplitudeManager.shared.amplitude.track(eventType: "lifetime_paywall_purchase_user_cancelled")
        }
    }
}

#Preview {
    PaywallLifetimeView()
}


struct MA_PrimaryButton: View {
    let title: LocalizedStringKey
    let comment: StaticString?
    let systemImage: String?
    let action: () -> Void
    
    init(title: LocalizedStringKey, comment: StaticString? = nil, systemImage: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.comment = comment
        self.systemImage = systemImage
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Group {
                if let systemImage {
                    HStack {
                        Image(systemName: systemImage)
                        Text(title, comment: comment)
                    }
                } else {
                    Text(title, comment: comment)
                }
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            //FIXME: -
//            .background(Color.maMain, in: .rect(cornerRadius: 14.0))
        }
        .foregroundStyle(.white)
    }
}

