//
//  EditarNotaViewController.swift
//  NotasCoreData
//
//  Created by Marco Alonso Rodriguez on 12/11/22.
//

import UIKit
import CoreData

class EditarNotaViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //Conexion a la bd o al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var recibirNota: Notas?
 
    @IBOutlet weak var imagenNotaEditar: UIImageView!
    @IBOutlet weak var fechaNotaEditar: UIDatePicker!
    @IBOutlet weak var textoNotaEditar: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textoNotaEditar.text = recibirNota?.titulo
        fechaNotaEditar.date = recibirNota?.fecha ?? Date.now
        imagenNotaEditar.image = UIImage(data: (recibirNota?.imagen)!)
        
        //Al seleccionar una imagen pueda realizar algo
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
        imagenNotaEditar.addGestureRecognizer(gestura)
        imagenNotaEditar.isUserInteractionEnabled = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func clickImagen(){
        let vc = UIImagePickerController()
        vc.delegate = self
        
        let alerta = UIAlertController(title: "Seleccionar imagen", message: "¿Desde donde quieres elegir una imagen?", preferredStyle: .actionSheet)
        let camara = UIAlertAction(title: "Camara", style: .default) { _ in
            vc.sourceType = .camera
            self.present(vc, animated: true)
        }
        
        let galeria = UIAlertAction(title: "Galeria", style: .default) { _ in
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true)
        }
        
        alerta.addAction(camara)
        alerta.addAction(galeria)
        
        present(alerta, animated: true)
          
        
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("se ha seleccionado una imagen")
        
        //Sin recortar imagen
        imagenNotaEditar.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        //Recortando imagen
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imagenNotaEditar.image = imagenSeleccionada
        }
        
        picker.dismiss(animated: true)
    }

    @IBAction func cancelarButton(_ sender: UIButton) {
        if navigationController != nil {
            navigationController?.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    @IBAction func guardarButton(_ sender: UIButton) {
        
        recibirNota?.titulo = textoNotaEditar.text ?? ""
        recibirNota?.fecha = fechaNotaEditar.date
        recibirNota?.imagen = imagenNotaEditar.image?.jpegData(compressionQuality: 0.5)
        
        do{
            try contexto.save()
        }catch {
            print("Debug: Error al guardar en core data \(error.localizedDescription)")
        }
        
        if navigationController != nil {
            navigationController?.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
}
