import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let productID = "roomledger_pro"

    @Published private(set) var isPurchased: Bool = false
    @Published private(set) var product: Product?
    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await update in Transaction.updates {
                await self?.handle(update: update)
            }
        }
        Task { await loadProduct() }
        Task { await refreshEntitlement() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.productID])
            product = products.first
        } catch {
            print("Failed to load product: \(error)")
        }
    }

    func purchase() async {
        guard let product else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                await handle(update: verification)
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlement()
    }

    private func handle(update: VerificationResult<Transaction>) async {
        if case .verified(let transaction) = update {
            if transaction.productID == Self.productID {
                isPurchased = true
            }
            await transaction.finish()
        }
    }

    private func refreshEntitlement() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.productID == Self.productID {
                isPurchased = true
                return
            }
        }
        isPurchased = false
    }
}
