//
//  NotaCuadradaCell.swift
//  NotasCoreData
//
//  Created by Marco Alonso Rodriguez on 22/03/23.
//

import UIKit

class NotaCuadradaCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imagenNota: UIImageView!
    @IBOutlet weak var fondoNota: UIView!
    @IBOutlet weak var textoNota: UILabel!
    @IBOutlet weak var didTapNota: UIView!
    
    //Closure cuando se presiona devuelve la info a la vista que incorpora esta celda
    var didTapDotsButton: (()->Void)?
    
    @IBOutlet weak var fechaNota: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let gestura = UITapGestureRecognizer()
//        gestura.numberOfTapsRequired = 2
//        gestura.numberOfTouchesRequired = 1
//        didTapNota.isUserInteractionEnabled = true
////
////        didTapNota.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapNote)))
//        gestura.addTarget(self, action: #selector(didTapNote))
//        didTapNota.addGestureRecognizer(gestura)
//
        didTapNota.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didTapNote)))
    }
    
    @objc func didTapNote(){
        if let tap = didTapDotsButton { //como es opcional tengo que validar que alguien lo este utilizando
            tap()
        }
    }
    
    
    
    
    

}
