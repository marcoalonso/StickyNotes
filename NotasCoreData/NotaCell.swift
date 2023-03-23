//
//  NotaCell.swift
//  NotasCoreData
//
//  Created by Marco Alonso Rodriguez on 07/02/23.
//

import UIKit

class NotaCell: UITableViewCell {
    
    @IBOutlet weak var fechaNota: UILabel!
    @IBOutlet weak var tituloNota: UILabel!
    @IBOutlet weak var notaLogo: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
