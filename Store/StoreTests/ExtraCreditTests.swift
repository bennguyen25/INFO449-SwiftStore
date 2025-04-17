//
//  ExtraCreditTests.swift
//  Store
//
//  Created by Ben Nguyen on 4/16/25.
//


import XCTest

final class ExtraCreditTests: XCTestCase {
    var register: Register!

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws {
        register = nil
    }

    func testTwoForOneExactlyThree() {
        let beansSKU = "Beans (8oz Can)"
        let twoForOne = TwoForOne(
            skuName: beansSKU,
            triggerCount: 3,
            payForCount: 2
        )
        register.addPricingScheme(twoForOne)

        register.scan(Item(name: beansSKU, priceEach: 199))
        register.scan(Item(name: beansSKU, priceEach: 199))
        register.scan(Item(name: beansSKU, priceEach: 199))

        XCTAssertEqual(398, register.subtotal())
    }

    func testTwoForOneAppliesMultipleTimes() {
        let penSKU = "Pen"
        let scheme = TwoForOne(
            skuName: penSKU,
            triggerCount: 3,
            payForCount: 2
        )
        register.addPricingScheme(scheme)

        for _ in 0..<7 {
            register.scan(Item(name: penSKU, priceEach: 100))
        }
        XCTAssertEqual(500, register.subtotal())
    }
}
