//
//  NotaCuadradaCell.swift
//  NotasCoreData
//
//  Created by Marco Alonso Rodriguez on 22/03/23.
//

import UIKit

class NotaCuadradaCell: UICollectionViewCell {
    
    @IBOutlet weak var imagenNota: UIImageView!
    @IBOutlet weak var textoNota: UILabel!
    
    @IBOutlet weak var fechaNota: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
