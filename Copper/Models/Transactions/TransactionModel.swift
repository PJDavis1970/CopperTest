//
//  TransactionModel.swift
//  Copper
//
//  Created by Paul Davis on 05/05/2022.
//

import Foundation

enum OrderType: String, Codable {
    
    case deposit = "deposit"
    case withdraw = "withdraw"
    case buy = "buy"
    case sell = "sell"
    
    func getAmountPrefix() -> String {
        
        switch self {
        case .deposit:
            return "+"
        case .withdraw:
            return "-"
        case .buy:
            return "+"
        case .sell:
            return "-"
        }
    }
    
    func getCurrencyPrefix() -> String {
        
        switch self {
        case .deposit:
            return "In "
        case .withdraw:
            return "Out "
        case .buy:
            return "BTC -> "
        case .sell:
            return "BTC -> "
        }
    }
}

class TransactionModel: Codable {
    
    var orderId: String?
    var currency: String?
    var amount: String?
    var orderType: String?
    var orderStatus: String?
    var createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        
        case orderId
        case currency
        case amount
        case orderType
        case orderStatus
        case createdAt
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderId = try container.decodeIfPresent(String.self, forKey: .orderId)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
        self.amount = try container.decodeIfPresent(String.self, forKey: .amount)
        self.orderType = try container.decodeIfPresent(String.self, forKey: .orderType)
        self.orderStatus = try container.decodeIfPresent(String.self, forKey: .orderStatus)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
    }
}
