//
//  NuevaNotaViewController.swift
//  NotasCoreData
//
//  Created by Marco Alonso Rodriguez on 12/11/22.
//

import UIKit
import CoreData

class NuevaNotaViewController: UIViewController {

    @IBOutlet weak var textoNota: UITextField!
    @IBOutlet weak var imagenNota: UIImageView!
    @IBOutlet weak var fechaNota: UIDatePicker!
    
    //Conexion a la bd o al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textoNota.delegate = self
        //agregar una gestura a la imagen
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
        imagenNota.addGestureRecognizer(gestura)
        imagenNota.isUserInteractionEnabled = true
        
    }
    
    @objc func clickImagen(){
        print("Debug: Imagen presionada!")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func guardarContexto(){
        do{
            try contexto.save()
        }catch {
            print("Debug: Error al guardar en core data \(error.localizedDescription)")
        }
    }
    func guardarNota(){
        //obtener los datos a guardar
        if let textoNota = textoNota.text, !textoNota.isEmpty {
            let fechaPicker = fechaNota.date
            
            //Crear la nueva nota a guardar
            let nuevaNota = Notas(context: self.contexto)
            
            nuevaNota.titulo = textoNota
            nuevaNota.fecha = fechaPicker
            nuevaNota.imagen = imagenNota.image?.pngData()
            guardarContexto()
            
            //Regresar a una pantalla anterior cuando usamos un NavController
            navigationController?.popToRootViewController(animated: true)
        }
    }
    @IBAction func guardarButton(_ sender: Any) {
        guardarNota()
    }
    
    @IBAction func cancelarButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension NuevaNotaViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("se ha seleccionado una imagen")
        
        //Sin recortar imagen
        imagenNota.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        //Recortando imagen
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imagenNota.image = imagenSeleccionada
        }
        
        picker.dismiss(animated: true)
    }
}

//MARK: UITextFieldDelegate
extension NuevaNotaViewController: UITextFieldDelegate {
    //1.- Habilitar el boton del teclado virtual
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Hacer algo ")
        //ocultar teclado
        textField.endEditing(true)
        return true
    }
    
    //2.- Identificar cuando el usuario termina de editar y que pueda borrar el contenido del textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Hacer algo
        
        guardarNota()
        
        textField.text = ""
        //ocultar teclado
        textField.endEditing(true)
    }
    
    //3.- Evitar que el usuario no escriba nada
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            //el usuario no escribio nada
            textField.placeholder = "Debes escribir algo.."
            return false
        }
    }
}
