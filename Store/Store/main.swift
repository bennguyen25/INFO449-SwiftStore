//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String {get}
    func price() -> Int
}

class Item: SKU {
    let name: String
    private let priceEach: Int
    
    init(name: String, priceEach: Int) {
        self.name = name
        self.priceEach = priceEach
    }
    
    func price() -> Int {
        return priceEach
    }
}

protocol PricingScheme {
    func adjustment(on items: [SKU]) -> Int
}

class TwoForOne: PricingScheme {
    let skuName: String
    let triggerCount: Int
    let payForCount: Int
    
    init(skuName: String, triggerCount: Int, payForCount: Int) {
        self.skuName = skuName
        self.triggerCount = triggerCount
        self.payForCount = payForCount
    }
    
    func adjustment(on items: [SKU]) -> Int {
        let matchingItems = items.filter { $0 is Item && ($0 as! Item).name == skuName }
        let count = matchingItems.count
        
        let groups = count / triggerCount
        guard groups > 0 else { return 0 }
        
        let freeUnits = groups * (triggerCount - payForCount)
        guard let price = matchingItems.first?.price() else { return 0 }
        
        return -(freeUnits * price)
    }
}

class Receipt {
    private var items: [SKU] = []
    
    func add(_ sku: SKU) {
        items.append(sku)
    }
    
    func total() -> Int {
        return items.reduce(0) { $0 + $1.price() }
    }
    
    func itemsList() -> [SKU] {
        return items
    }
    
    func output() -> String {
        var lines: [String] = ["Receipt:"]
        
        for sku in items {
            let p = sku.price()
            let dollars = p / 100
            let cents = p % 100
            let centsString = String(format: "%02d", cents)
            lines.append("\(sku.name): $\(dollars).\(centsString)")
        }
        
        lines.append("------------------")
        
        let grandTotal = total()
        let td = grandTotal / 100
        let tc = grandTotal % 100
        let tcString = String(format: "%02d", tc)
        lines.append("TOTAL: $\(td).\(tcString)")
        
        return lines.joined(separator: "\n")
    }
}

class Register {
    private var receipt: Receipt
    private var pricingSchemes: [PricingScheme] = []
    
    init() {
        self.receipt = Receipt()
    }
    
    func scan(_ sku: SKU) {
        receipt.add(sku)
    }
    
    func addPricingScheme(_ scheme: PricingScheme) {
        pricingSchemes.append(scheme)
    }
    
    func subtotal() -> Int {
        let raw = receipt.total()
        let adjustment = pricingSchemes
            .map { $0.adjustment(on: receipt.itemsList()) }
            .reduce(0, +)
        return raw + adjustment
    }
    
    func total() -> Receipt {
        let finishedReceipt = receipt
        receipt = Receipt()
        return finishedReceipt
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

