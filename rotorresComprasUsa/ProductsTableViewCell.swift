//
//  ProductsTableViewCell.swift
//  rotorresComprasUsa
//
//  Created by Rober Torres on 23/04/17.
//  Copyright © 2017 Rober Torres. All rights reserved.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var ivCellProduct: UIImageView!
    @IBOutlet weak var lCellProductName: UILabel!
    @IBOutlet weak var lCellProductValue: UILabel!
    @IBOutlet weak var lCellProductState: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
