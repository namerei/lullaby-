//
//  ApphudVariables.swift
//  Lullaby
//
//  Created by Evgeniy Makarov on 04.02.2025.
//

import Foundation
import ApphudSDK

class ApphudVariables {

    static let lifetimeProductID = "nonconsumable.lifetimeaccess"

    @MainActor
    static var isPremium: Bool {
        Apphud.hasActiveSubscription() ||
        Apphud.isNonRenewingPurchaseActive(productIdentifier: lifetimeProductID)
    }
}
