//
//  ProductsTableViewController.swift
//  rotorresComprasUsa
//
//  Created by Rober Torres on 23/04/17.
//  Copyright © 2017 Rober Torres. All rights reserved.
//

import UIKit
import CoreData

class ProductsTableViewController: UITableViewController {
    
    var fetchedResultController: NSFetchedResultsController<Product>!
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = 105//UITableViewAutomaticDimension
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
        label.text = "Sem compras"
        label.textAlignment = .center
        label.textColor = .black
        
        loadProducts()
    }

    func loadProducts() {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController.fetchedObjects?.count {
            tableView.backgroundView = (count == 0) ? label : nil
            return count
        } else {
            tableView.backgroundView = label
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductsTableViewCell
        
        let product = fetchedResultController.object(at: indexPath)
        
        cell.lCellProductName.text = product.name
        cell.lCellProductState.text = "\(product.bycard)"
        cell.lCellProductValue.text = "\(product.value)"

        if let image = product.poster as? UIImage {
            cell.ivCellProduct.image = image
        }
        return cell
    }

}


extension ProductsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
