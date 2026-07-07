import SwiftUI

struct SettingsView: View {
    @AppStorage("roomledger.notifyEnabled") private var notifyEnabled: Bool = true
    @AppStorage("roomledger.compactMode") private var compactMode: Bool = false
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Reminders", isOn: $notifyEnabled)
                        .accessibilityIdentifier("settingsNotifyToggle")
                    Toggle("Compact List", isOn: $compactMode)
                        .accessibilityIdentifier("settingsCompactToggle")
                }

                Section("Roomservice Ledger Pro") {
                    if purchases.isPurchased {
                        Label("Pro Unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Upgrade to Pro") { showPaywall = true }
                            .accessibilityIdentifier("settingsUpgradeButton")
                    }
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("settingsRestoreButton")
                }

                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/roomledger-app/privacy.html")!)
                    Text("Version 1.0")
                        .foregroundStyle(Theme.secondaryInk)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
}
