//
//  FacturasCellController.swift
//  ProyectoIOS
//
//  Created by Francisco López Gómez on 30/5/18.
//  Copyright © 2018 Francisco López Gómez. All rights reserved.
//

import UIKit

class FacturasCellController: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblMes: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var btnPDF: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnPDF.isHidden = true
    }
    
    
}
