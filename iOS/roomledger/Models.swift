import Foundation

struct Charge: Identifiable, Codable, Equatable {
    let id: UUID
    var hotelName: String
    var itemDescription: String
    var amount: Double
    var date: Date
    var notes: String

    init(id: UUID = UUID(), hotelName: String, itemDescription: String, amount: Double, date: Date, notes: String) {
        self.id = id
        self.hotelName = hotelName
        self.itemDescription = itemDescription
        self.amount = amount
        self.date = date
        self.notes = notes
    }
}
