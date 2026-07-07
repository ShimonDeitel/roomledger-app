import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var items: [Charge] = []
    @Published var isProUnlocked: Bool = false

    /// Free tier item cap. Deliberately kept above the seed data count
    /// so a fresh install never opens directly into the paywall.
    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        self.fileURL = dir.appendingPathComponent("roomledger_items.json")
        load()
    }

    var canAddMore: Bool {
        isProUnlocked || items.count < Store.freeLimit
    }

    func add(_ item: Charge) {
        guard canAddMore else { return }
        items.append(item)
        save()
    }

    func update(_ item: Charge) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Charge) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Charge].self, from: data) {
            items = decoded
        } else {
            items = [
        Charge(hotelName: "Sample Hotelname 1", itemDescription: "Sample Itemdescription 1", amount: 12.50, date: Date().addingTimeInterval(-259200), notes: "Sample Notes 1"),
        Charge(hotelName: "Sample Hotelname 2", itemDescription: "Sample Itemdescription 2", amount: 25.00, date: Date().addingTimeInterval(-518400), notes: "Sample Notes 2"),
        Charge(hotelName: "Sample Hotelname 3", itemDescription: "Sample Itemdescription 3", amount: 37.50, date: Date().addingTimeInterval(-777600), notes: "Sample Notes 3")
            ]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
