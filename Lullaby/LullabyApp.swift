//
//  LullabyApp.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 04/12/23.
//

import SwiftUI
import StoreKit
import ApphudSDK
import FirebaseCore
import FirebaseAnalytics
import AppTrackingTransparency

class AppDelegate: NSObject, UIApplicationDelegate {
    /// For StoreKit
    var productIds: [String: String] = [:]
    var products = [SKProduct]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Amplitude
        AmplitudeManager.shared.amplitude.track(eventType: "app_start")
        
        // Apphud
        Apphud.start(apiKey: "app_J4KCDSXEzA1CVqBtRc8kGcbtnhbApp")
        Apphud.setDelegate(self)
        
        // Firebase
        FirebaseApp.configure()
        // Повышенные требования (COPPA в США, GDPR — детское согласие в ЕС)
        Analytics.setConsent([
                    .adStorage: .denied,
                    .analyticsStorage: .granted,
                    .adUserData: .denied,
                    .adPersonalization: .denied
                ])
        
        return true
    }
}

extension AppDelegate: ApphudDelegate {

    func apphudDidFetchStoreKitProducts(_ products: [SKProduct], _ error: Error?) {
        if error != nil {
            print("Some error to get SKProduct")
        } else {
            print("We get products from Store Kit ==== \(products)")
        }
    }

    func apphudDidObservePurchase(result: ApphudPurchaseResult) -> Bool {

        print("Did observe purchase made without Apphud SDK: \(result)")

        return true
    }
}

@main
struct LullabyApp: App {
    @AppStorage("onboarding") private var onboarding: Bool = true
    @AppStorage("paid") private var paid: Bool = false
    @AppStorage("skipped_payment") private var skippedPayment: Bool = false
    @AppStorage("passed_parent_test") private var passedParentTest: Bool = false
    @AppStorage("lang") private var lang: String?
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var paywallVM = PaywallViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if onboarding == true {
                    OnboardingView()
                } else {
                    if paywallVM.ready {
                        Group {
                            if paid == true {
                                ContentView()
                            } else {
                                if skippedPayment == true {
                                    ContentView()
                                } else {
                                    PaywallView()
                                }
                            }
                        }
                        .onAppear(perform: {
//                            paid = paywallVM.purchased.contains(where: {$0.id == "autorenewable.weeklyaccess"})
                            paid = paywallVM.purchased.count > 0
                        })
                    } else {
                        ProgressView()
                    }
                }
            }
            .onAppear(perform: {
                if lang == nil, let preferredLanguage = Locale.preferredLanguages.first {
                    if preferredLanguage.starts(with: "ru") {
                        lang = "ru"
                    } else if preferredLanguage.starts(with: "de") {
                        lang = "de"
                    } else if preferredLanguage.starts(with: "fr") {
                        lang = "fr"
                    } else if preferredLanguage.starts(with: "it") {
                        lang = "it"
                    } else if preferredLanguage.starts(with: "pt") {
                        lang = "pt-PT"
                    } else if preferredLanguage.starts(with: "es") {
                        lang = "es"
                    } else {
                        lang = "en"
                    }
                }
                passedParentTest = false
            })
            .environmentObject(paywallVM)
            .preferredColorScheme(.dark)
        }
    }
}
