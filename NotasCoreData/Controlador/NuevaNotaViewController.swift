//
//  NuevaNotaViewController.swift
//  NotasCoreData
//
//  Created by Marco Alonso Rodriguez on 12/11/22.
// https://stackoverflow.com/questions/23835093/storing-uicolor-object-in-core-data
/// - Guardar el color como data

import UIKit
import CoreData
import PhotosUI

class NuevaNotaViewController: UIViewController {

    @IBOutlet weak var textoNota: UITextField!
    @IBOutlet weak var imagenNota: UIImageView!
    @IBOutlet weak var fechaNota: UIDatePicker!
    
    var accessOfUser: Bool = false
    
    //Conexion a la bd o al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textoNota.delegate = self
        
        requestUserPermission()
        setupUI()
        
    }
    
    private func setupUI(){
        //agregar una gestura a la imagen
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
        imagenNota.addGestureRecognizer(gestura)
        imagenNota.isUserInteractionEnabled = true
    }
    
    private func requestUserPermission(){
        // Request permission to access photo library
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [unowned self] (status) in
            DispatchQueue.main.async { [unowned self] in
                showUI(for: status)
            }
        }
    }
    
    func showUI(for status: PHAuthorizationStatus) {
        
        switch status {
        case .authorized:
//            showFullAccessUI()
            accessOfUser = true

        case .limited:
//            showLimittedAccessUI()
            print("Acceso limitado")
            accessOfUser = true

        case .restricted:
//            showRestrictedAccessUI()
            print("Restingido")

        case .denied:
//            showAccessDeniedUI()
            accessOfUser = false

        case .notDetermined:
            print("No determinado")

        @unknown default:
            break
        }
    }
    
    @objc func clickImagen(){
        if accessOfUser {
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
        } else {
            let alerta = UIAlertController(title: "Atención", message: "Para poder seleccionar una foto necesitamos tu permiso para acceder a la galeria de fotos", preferredStyle: .alert)
            let aceptar = UIAlertAction(title: "Otogar Permiso", style: .default) { _ in
                self.gotoAppPrivacySettings()
            }
            
            let despues = UIAlertAction(title: "Omitir", style: .destructive) { _ in
                //Do something
            }
            
            alerta.addAction(aceptar)
            alerta.addAction(despues)
            
            present(alerta, animated: true)
        }
        
    }
    
    private func gotoAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                assertionFailure("Not able to open App privacy settings")
                return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func guardarContexto(){
        do{
            try contexto.save()
            print("Se guardo el contexto")
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
            
            if navigationController != nil {
                navigationController?.popToRootViewController(animated: true)
            } else {
                dismiss(animated: true)
            }
          
        }
    }
    @IBAction func guardarButton(_ sender: Any) {
        guardarNota()
    }
    
    @IBAction func cancelarButton(_ sender: Any) {
        if navigationController != nil {
            navigationController?.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
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
        //ocultar teclado
        textField.endEditing(true)
        return true
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
