//
//  TransactionTableViewCell.swift
//  Copper
//
//  Created by Paul Davis on 05/05/2022.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
                
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(index: Int) {

        let data = OrdersModelManager.shared.getTransactionFromIndex(index: index)
        let orderType = data.value(forKeyPath: "orderType") as? String
        let currency = data.value(forKeyPath: "currency") as? String
        let createdAt = data.value(forKeyPath: "createdAt") as? String
        let amount = data.value(forKeyPath: "amount") as? String
        let orderStatus = data.value(forKeyPath: "orderStatus") as? String
        
        let orderTypeEnum = OrderType(rawValue: orderType ?? "")
        
        /// handle currency
        ///
        var currencyStr = "void"
        if let cprefix = orderTypeEnum?.getCurrencyPrefix() {
            
            if let curr = currency {
                
                currencyStr = "\(cprefix)\(curr)"
            }
            
        }
        self.currencyLabel.text = currencyStr
        
        /// handle date
        ///
        var dateString = "void"
        if let date = Double(createdAt ?? "") {
            
            let date = NSDate(timeIntervalSince1970: date / 1000.0)
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM dd, YYYY hh:mm a"
            dateString = dayTimePeriodFormatter.string(from: date as Date)
        }
        self.createdLabel.text = dateString.replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
        
        /// handle amount
        ///
        var amountStr = "void"
        if let aprefix = orderTypeEnum?.getAmountPrefix() {
            
            if let amt = Double(amount ?? "0.0") {
                
                amountStr = "\(aprefix)\(String(format: "%.4f", amt))"
            }
        }
        self.amountLabel.text = amountStr
        
        /// handle status
        ///
        self.statusLabel.text = orderStatus
    }
}

