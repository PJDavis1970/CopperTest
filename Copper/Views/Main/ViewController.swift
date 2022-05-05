//
//  ViewController.swift
//  Copper
//
//  Created by Paul Davis on 05/05/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
          return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        OrdersModelManager.shared.loadTransactions()
        self.configureViews()
    }
    
    func configureViews() {
        
        if OrdersModelManager.shared.getNumberOfOrders() > 0 {
            
            self.tableView.isHidden = false
        } else {
            
            self.tableView.isHidden = true
        }
    }
    
    @IBAction func downloadButtonPressed(_ sender: Any) {
        
        self.showSpinner(onView: self.view)
        OrdersModelManager.shared.downOrders(completion: {_,_ in
            
            self.configureViews()
            self.tableView.reloadData()
            self.removeSpinner()
        })
    }
}

extension ViewController {
                
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return OrdersModelManager.shared.getNumberOfOrders()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        cell.selectionStyle = .none
        cell.configure(index: indexPath.row)
        return cell
    }
}
