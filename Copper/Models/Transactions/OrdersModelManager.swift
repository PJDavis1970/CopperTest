//
//  OrdersModelManager.swift
//  Copper
//
//  Created by Paul Davis on 05/05/2022.
//

import UIKit
import Alamofire
import CoreData

class OrdersModelManager {

    static let shared = OrdersModelManager()
    
    var transactionData = [TransactionModel]()
    var transactions: [NSManagedObject] = []
    
    private init() {

    }
    
    func downOrders(completion: @escaping (Bool, String)-> Void) {

        AF.request("https://assessments.stage.copper.co/ios/orders").response { response in

            switch (response.result) {

                case .success( _):

                do {

                    guard let resData = response.data else {
                        
                        completion(false, "Invalid data returned")
                        return
                    }
                    
                    let data = try JSONDecoder().decode(OrdersModel.self, from: resData)
                    self.transactionData = data.orders ?? [TransactionModel]()
                    self.saveTransactions()
                    completion(true, "" )

                } catch let error as NSError {
                    
                    print(String(describing: error))
                    completion(false, String(describing: error) )
                }
                case .failure(let error):

                    completion(false, String(describing: error) )
             }
         }
    }
    
    func loadTransactions() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Transaction")
        
        do {
            
            transactions = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveTransactions() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: managedContext)!
        
        /// for now save each transaction individually in case we want to modify data as we save
        
        for trans in self.transactionData {
            
            let transaction = NSManagedObject(entity: entity, insertInto: managedContext)
            transaction.setValue(trans.orderId, forKeyPath: "orderId")
            transaction.setValue(trans.orderType, forKeyPath: "orderType")
            transaction.setValue(trans.orderStatus, forKeyPath: "orderStatus")
            transaction.setValue(trans.currency, forKeyPath: "currency")
            transaction.setValue(trans.createdAt, forKeyPath: "createdAt")
            transaction.setValue(trans.amount, forKeyPath: "amount")
            self.transactions.append(transaction)

        }
        do {
            
            try managedContext.save()
            
        } catch let error as NSError {
            
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func getNumberOfOrders() -> Int {
        
        return self.transactions.count
    }
    
    func getTransactionFromIndex(index: Int) -> NSManagedObject {
        
        return self.transactions[index]
    }
}
