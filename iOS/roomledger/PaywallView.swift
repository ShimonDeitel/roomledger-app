import SwiftUI
import StoreKit

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(Theme.accent)
                .padding(.top, 32)

            Text("Roomservice Ledger Pro")
                .font(Theme.titleFont)
                .foregroundStyle(Theme.ink)

            Text("Unlimited stays, itemized totals, and dispute-ready export")
                .font(Theme.bodyFont)
                .foregroundStyle(Theme.secondaryInk)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            if let product = purchases.product {
                Button {
                    Task { await purchases.purchase() }
                } label: {
                    Text("Unlock for \(product.displayPrice)")
                        .font(Theme.headingFont)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
                .accessibilityIdentifier("paywallPurchaseButton")
                .padding(.horizontal, 24)
            } else {
                ProgressView()
            }

            Button("Restore Purchases") {
                Task { await purchases.restore() }
            }
            .accessibilityIdentifier("paywallRestoreButton")
            .font(Theme.captionFont)
            .foregroundStyle(Theme.secondaryInk)

            Button("Not Now") { dismiss() }
                .accessibilityIdentifier("paywallDismissButton")
                .font(Theme.captionFont)
                .foregroundStyle(Theme.secondaryInk)
                .padding(.bottom, 24)
        }
        .themedBackground()
    }
}
