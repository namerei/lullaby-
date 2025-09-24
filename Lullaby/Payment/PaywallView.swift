//
//  PaywallView.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 05/12/23.
//

import SwiftUI
import StoreKit
import ApphudSDK

struct PaywallView: View {
    
    @AppStorage("paid") private var paid: Bool = false
    @AppStorage("skipped_payment") private var skippedPayment: Bool = false
    @AppStorage("passed_parent_test") private var passedParentTest: Bool = false
    @State private var showParentTestQuestion: Bool = false
    
    @StateObject private var paywallVM: PaywallViewModel = PaywallViewModel()
    @StateObject private var customNavigation: NavigationViewModel = .init()
    @State private var showPrivacyView: Bool = false
    @State private var showTermsView: Bool = false
    
    @State private var justSwitched: Bool = false
    @State private var selectedAnnual: Bool = true
    @State private var selectedWithFreeTrial: Bool = false
    
    // Apphud
    @Environment(\.presentationMode) var presentationMode
    @State var products = [Product]()
    
    var weklyProduct: Product? {
        paywallVM.products.first { $0.id == "autorenewable.weeklyaccess" }
    }
    
    var body: some View {
        NavigationStack(path: $customNavigation.navigationPath) {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(.themeBackgroundLighter.opacity(0.7))
                    .ignoresSafeArea()
                Image(.paymentBackground)
                    .resizable()
                    .scaledToFit()
                    .overlay(content: {
                        Rectangle()
                            .fill(Color.black.opacity(0.4).gradient)
                    })
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            skippedPayment = true
                        }, label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        })
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .padding(.top, 40)
                    Spacer()
                    HStack {
                        Text("Bedtime".localized)
                            .customFont(.xl, size: 50)
                        Text("PRO".localized)
                            .customFont(.xl, size: 35)
                            .frame(width: 100, height: 100)
                            .background {
                                RoundedRectangle(cornerRadius: 17.0)
                                    .fill(.paymentPro)
                            }
                    }
                    Spacer()
                    HStack { // From onboard
                        VStack {
                            Text("White Noise".localized)
                            Image(.paymentWhiteNoise)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        VStack {
                            Text("Fairy Tales".localized)
                            Image(.paymentFairyTales)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        VStack {
                            Text("Lullabies".localized)
                            Image(.paymentLullabies)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .font(.headline)
                    VStack(alignment: .leading, spacing: 25) { // Options
                        ForEach(paywallVM.products) { product in
                            Button {
                                paywallVM.selectedProduct = product
                                
                                if paywallVM.products.contains(where: {$0.subscription?.introductoryOffer != nil}) {
                                    justSwitched = true
                                    selectedWithFreeTrial = product.subscription?.introductoryOffer != nil
                                } else {
                                    justSwitched = true
                                    selectedAnnual = product.subscription?.subscriptionPeriod.unit == .year
                                }
                            } label: {
                                HStack {
                                    LeadingSectionOfProduct(product: product)
                                    Spacer()
                                    TrailingSectionOfProduct(product: product)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                                .background { BackgroundSection(product: product) }
                            }
                            .foregroundStyle(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
//                    .padding(.horizontal)
                    HStack {
                        Toggle(isOn: paywallVM.products.contains(where: {$0.subscription?.introductoryOffer != nil}) ? $selectedWithFreeTrial : $selectedAnnual) {
                            if paywallVM.products.contains(where: {$0.subscription?.introductoryOffer != nil}) {
                                Text("Free trial enabled".localized)
                            } else {
                                Text("Switch to another plan".localized)
                            }
                        }
                    }
                    .padding(12)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.paymentProBG)
                    }
                    
                    Button {
                        if passedParentTest {
                            Task {
                                do {
                                    if let product = paywallVM.selectedProduct {
                                        _ = try await paywallVM.purchase(product)
                                        let result = await Apphud.purchase(product)
                                        if result.success {
                                            print("Success purchase -> \(product.id)")
                                        } else {
                                            print("Not purchase some error")
                                        }
                                    }
                                } catch {
                                    print(error)
                                }
    
                            }
                        } else {
                            showParentTestQuestion = true
                        }
                    } label: {
                        Text("Continue".localized)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 12.0)
                                    .fill(.paymentPro)
                            )
                    }
                    .padding(.vertical)
                    
                    .task {
                        do {
                            products = try await Apphud.fetchProducts()
                            print("Fetched StoreKit2 Products: \(products.map { $0.id })")
                        } catch {
                            print("Failed to fetch StoreKit2 Products error: \(error)")
                        }
                    }
                    HStack {
                        Image("PaymentTickIcon")
                        if let product = paywallVM.selectedProduct, product.subscription?.introductoryOffer != nil {
                            Text("No payment due now".localized)
                        } else {
                            Text("100% money-back guarantee".localized)
                        }
                    }
                    
                    HStack {
                        Button(action: {
                            if passedParentTest {
                                Task {
                                    await Apphud.restorePurchases()
                                    if ApphudVariables.isPremium {
                                        paid = true
                                        presentationMode.wrappedValue.dismiss()
                                        print("Is Premium")
                                    } else {
                                        print("Not premium")
                                    }
                                }
                            } else {
                                showParentTestQuestion = true
                            }
                        }, label: {
                            Text("Restore".localized)
                        })
                        .frame(maxWidth: .infinity)
                        if passedParentTest {
                            Button("Terms".localized) {
                                customNavigation.navigationPath.append(.termsOfUse)
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.secondary)
    //                        Link("Terms".localized, destination: URL(string: "https://evgenii-krutov.jimdosite.com/terms-of-use/")!)
    //                            .frame(maxWidth: .infinity)
                        } else {
                            Button(action: {
                                showParentTestQuestion = true
                            }, label: {
                                Text("Terms".localized)
                                    .frame(maxWidth: .infinity)
                            })
                        }
                        if passedParentTest {
                            Button("Privacy".localized) {
                                customNavigation.navigationPath.append(.privacy)
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.secondary)
    //                        Link("Privacy".localized, destination: URL(string: "https://evgenii-krutov.jimdosite.com")!)
    //                            .frame(maxWidth: .infinity)
                        } else {
                            Button(action: {
                                showParentTestQuestion = true
                            }, label: {
                                Text("Privacy")
                                    .frame(maxWidth: .infinity)
                            })
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 30)
                }
                .padding()
                
                if paywallVM.purchasing {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
            .ignoresSafeArea()
            .sheet(isPresented: $showParentTestQuestion, content: {
                ParentTestQuestionView()
            })
            .onChange(of: paywallVM.purchased) { newValue in
                if !newValue.isEmpty {
                    paid = true
                }
            }
            .onChange(of: selectedAnnual, perform: { newValue in
                if justSwitched {
                    justSwitched = false
                } else {
                    paywallVM.selectedProduct = paywallVM.products.first(where: {$0.id != paywallVM.selectedProduct?.id})
                }
            })
            .onChange(of: selectedWithFreeTrial, perform: { newValue in
                if justSwitched {
                    justSwitched = false
                } else {
                    paywallVM.selectedProduct = paywallVM.products.first(where: {$0.id != paywallVM.selectedProduct?.id})
                }
            })
            .navigationDestination(for: NavigationOption.self) { value in
                switch value {
                case .player(let id, let type):
                    PlayerView(id: id, type: type)
                        .environmentObject(customNavigation)
                case .chooseLanguage:
                    LanguagesView()
                        .environmentObject(customNavigation)
                case .privacy:
                    PrivacyView()
                        .environmentObject(customNavigation)
                case .termsOfUse:
                    TermsOfUseView()
                        .environmentObject(customNavigation)
                }
            }
        }
    }
    
    @ViewBuilder
    private func LeadingSectionOfProduct(product: Product) -> some View {
        HStack {
            Image(paywallVM.selectedProduct == product ? .paywallProductSelectedCircleIcon : .paywallProductUnselectedIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .shadow(color: paywallVM.selectedProduct == product ? .accent : .paymentProBG, radius: 20)
            VStack(alignment: .leading) {
                if #available(iOS 16.4, *), let subscription = product.subscription, subscription.subscriptionPeriod == .yearly {
                    Text("Year".localized)
                        .font(.headline)
                    Text("\(((product.price/10)*100).formatted(.currency(code: product.priceFormatStyle.currencyCode)))")
                        .strikethrough()
                        .font(.caption)
                    Text("\(product.displayPrice)" + "/year".localized)
                        .font(.subheadline)
                } else { // There will be only weekly option
                    if let subscription = product.subscription {
                        if let introductoryOffer = subscription.introductoryOffer, introductoryOffer.type == .introductory {
                            if #available(iOS 16.4, *) {
                                if introductoryOffer.period == .everyThreeDays {
                                    Text("3 Days Free".localized)
                                        .font(.headline)
                                    Text("Then".localized + " \(product.displayPrice)" + "/week".localized)
                                        .font(.subheadline)
                                }
                            } else {
                                // Fallback on earlier versions
                                Text("3 Days Free".localized)
                                    .font(.headline)
                                Text("Then".localized + " \(product.displayPrice)" + "/week".localized)
                                    .font(.subheadline)
                            }
                        } else { // If there is no Introductory offers
                            Text("Listen without restrictions,".localized)
                                .font(.caption)
                            Text("\(product.displayPrice)" + "/week".localized)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .padding(10)
        }
    }
    
    @ViewBuilder
    private func TrailingSectionOfProduct(product: Product) -> some View {
        HStack {
            VStack(alignment: .trailing) {
                if let subscription = product.subscription {
                    if subscription.subscriptionPeriod.unit == .year {
                        Text("\((product.price/52).formatted(.currency(code: product.priceFormatStyle.currencyCode)))" + "/week".localized)
                            .font(.title3.bold())
                    } else {
                        Text("BEST DEAL".localized)
                            .font(.headline)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func BackgroundSection(product: Product) -> some View {
        Group {
            if paywallVM.selectedProduct == product {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.paymentPro)
                    }
            } else {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.paymentProBG)
            }
        }
        .overlay(alignment: .topTrailing) {
            if product.subscription?.subscriptionPeriod.unit == .year {
                HStack {
                    Text("SAVE 90%".localized)
                        .bold()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.paymentPro)
                }
                .offset(x: -20, y: -10)
            }
        }
    }
}

#Preview {
    PaywallView()
        .preferredColorScheme(.dark)
}
