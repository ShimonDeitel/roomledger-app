import XCTest
@testable import roomledger

@MainActor
final class ChargeStoreTests: XCTestCase {
    var store: Store!

    override func setUp() async throws {
        store = Store()
    }

    func testSeedDataLoadsBelowFreeLimit() {
        XCTAssertLessThan(store.items.count, Store.freeLimit)
    }

    func testCanAddMoreWhenUnderLimit() {
        XCTAssertTrue(store.canAddMore)
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        store.add(Charge(hotelName: "Sample Hotelname 10", itemDescription: "Sample Itemdescription 10", amount: 125.00, date: Date().addingTimeInterval(-2592000), notes: "Sample Notes 10"))
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testAddBeyondFreeLimitIsBlocked() {
        while store.canAddMore {
            store.add(Charge(hotelName: "Sample Hotelname 2", itemDescription: "Sample Itemdescription 2", amount: 25.00, date: Date().addingTimeInterval(-518400), notes: "Sample Notes 2"))
        }
        let countAtLimit = store.items.count
        store.add(Charge(hotelName: "Sample Hotelname 3", itemDescription: "Sample Itemdescription 3", amount: 37.50, date: Date().addingTimeInterval(-777600), notes: "Sample Notes 3"))
        XCTAssertEqual(store.items.count, countAtLimit)
    }

    func testProUnlockBypassesLimit() {
        while store.canAddMore {
            store.add(Charge(hotelName: "Sample Hotelname 2", itemDescription: "Sample Itemdescription 2", amount: 25.00, date: Date().addingTimeInterval(-518400), notes: "Sample Notes 2"))
        }
        store.isProUnlocked = true
        XCTAssertTrue(store.canAddMore)
    }

    func testDeleteRemovesItem() {
        let item = store.items[0]
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testUpdateModifiesItem() {
        var item = store.items[0]
        item.hotelName = "Sample Hotelname 6"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.hotelName, item.hotelName)
    }

    func testDeleteAtOffsetsRemovesCorrectItem() {
        let target = store.items[0]
        store.delete(at: IndexSet(integer: 0))
        XCTAssertFalse(store.items.contains(target))
    }
}
