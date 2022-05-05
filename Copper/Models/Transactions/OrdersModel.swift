//
//  OrdersModel.swift
//  Copper
//
//  Created by Paul Davis on 05/05/2022.
//

import Foundation

class OrdersModel: Codable {
    
    var orders: [TransactionModel]?
    
    enum CodingKeys: String, CodingKey {
        
        case orders
    }

    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orders = try container.decodeIfPresent([TransactionModel].self, forKey: .orders)
    }
}
