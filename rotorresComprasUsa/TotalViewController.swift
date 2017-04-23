//
//  TotalViewController.swift
//  rotorresComprasUsa
//
//  Created by Rober Torres on 23/04/17.
//  Copyright © 2017 Rober Torres. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {

    @IBOutlet weak var lTotal: UILabel!
    @IBOutlet weak var lTotalTax: UILabel!
    @IBOutlet weak var lTotalIOF: UILabel!
    @IBOutlet weak var lTotalAll: UILabel!
    @IBOutlet weak var lTotalBRZ: UILabel!
    
    var fetchedResultController: NSFetchedResultsController<Product>!
    
    
    var total: Double = 0.0
    var totalTax: Double = 0.0
    var totalIOF: Double = 0.0
    var totalAll: Double = 0.0
    var totalBRL: Double = 0.0
    
    
    func loadProducts() {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        //fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func calculateTotals() {
        
        let iof = UserDefaults.standard.double(forKey: "tfSettingsIOF") as Double?
        let dolar = UserDefaults.standard.double(forKey: "tfSettingsDolar") as Double?
        
        var individualTax: Double = 0.0
        for product in fetchedResultController.fetchedObjects! {
            total = total + product.value
            if let stateTax = (product.states?.tax) as Double? {
                individualTax = ((product.value * stateTax)/100)
            }
            
            totalTax = totalTax + individualTax
            if product.bycard {
                totalIOF = totalIOF + ((product.value + individualTax)*iof!/100)
            }
        }
        totalAll = totalIOF + totalTax + total
        totalBRL = totalAll * dolar!
    }
    
    
    func setLayout() {
        lTotal.text = "\(total)"
        lTotalTax.text = "\(totalTax)"
        lTotalIOF.text = "\(totalIOF)"
        lTotalAll.text = "\(totalAll)"
        lTotalBRZ.text = "\(totalBRL)"
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        total = 0.0
        totalTax = 0.0
        totalIOF = 0.0
        totalAll = 0.0
        totalBRL = 0.0
        
        loadProducts()
        calculateTotals()
        setLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
