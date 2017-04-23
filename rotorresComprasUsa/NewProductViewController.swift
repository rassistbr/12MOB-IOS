//
//  NewProductViewController.swift
//  rotorresComprasUsa
//
//  Created by Rober Torres on 23/04/17.
//  Copyright © 2017 Rober Torres. All rights reserved.
//

import UIKit
import CoreData

class NewProductViewController: UIViewController {

    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var tfProductValue: UITextField!
    @IBOutlet weak var swProductByCard: UISwitch!
    @IBOutlet weak var ivProductPoster: UIImageView!
    @IBOutlet weak var btNewProduct: UIButton!
    @IBOutlet weak var btClose: UIButton!
    
    var product: Product!
    var smallImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func close(_ sender: UIButton?) {
        dismiss(animated: true, completion: nil)
        if product != nil && product.name == nil {
            context.delete(product)
        }
    }
    
    
    @IBAction func addNewProduct(_ sender: UIButton) {
        if product == nil {
            product = Product(context: context)
        }
        product.name = tfProductName.text!
        product.value = Double(tfProductValue.text!)!
        product.bycard = swProductByCard.isOn

        if smallImage != nil {
            product.poster = smallImage
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        close(nil)
    }
    

}
