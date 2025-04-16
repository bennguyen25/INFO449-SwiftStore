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

class Receipt {
    private var items: [SKU] = []
    
    func add(_ sku: SKU) {
        items.append(sku)
    }
    
    func total() -> Int {
        return items.reduce(0) { $0 + $1.price() }
    }
    
    func output() -> String {
        var lines: [String] = ["Receipts:"]
        
        for sku in items {
            let p = sku.price()
            let dollars = p / 100
            let cents = p % 100
            let centsString = String(format: "%02d", cents)
            lines.append("\(sku.name): \(dollars).\(centsString)")
        }
        
        lines.append("------------------")
        
        let grandTotal = total()
        let td = grandTotal / 100
        let tc = grandTotal % 100
        let tcString = String(format: "%02d", tc)
        lines.append("Grand Total: \(td).\(tcString)")
        
        return lines.joined(separator: "\n")
    }
}

class Register {
    private var receipt: Receipt
    
    init() {
        self.receipt = Receipt()
    }
    
    func scan(_ sku: SKU) {
        receipt.add(sku)
    }
    
    func subtotal() -> Int {
        return receipt.total()
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

