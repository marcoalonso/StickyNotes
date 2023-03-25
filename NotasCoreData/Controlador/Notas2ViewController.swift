//
//  Notas2ViewController.swift
//  NotasCoreData
//
//  Created by Marco Alonso Rodriguez on 22/03/23.
//

import UIKit
import CoreData
import AVFoundation

class Notas2ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    var notas2 : [Notas] = []
    var player: AVAudioPlayer?  //Es un opcional
    
    //Conexion a la bd o al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var colores = [UIColor.red, UIColor.blue, UIColor.systemPink, UIColor.yellow, UIColor.green, UIColor.orange, UIColor.gray, UIColor.purple, UIColor.brown, UIColor.magenta, UIColor.cyan]

    @IBOutlet weak var notasCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notasCollection.delegate = self
        notasCollection.dataSource = self
        
        notasCollection.register(UINib(nibName: "NotaCuadradaCell", bundle: nil), forCellWithReuseIdentifier: "NotaCuadradaCell")
        
        notasCollection.collectionViewLayout = UICollectionViewFlowLayout()
        if let flowLayout = notasCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        leerNotas()
    }
    
    // MARK:  Read
    private func leerNotas(){
        let solicitud: NSFetchRequest<Notas> = Notas.fetchRequest()
        do{
            notas2 = try contexto.fetch(solicitud)
            print("Debug: Se leyo correctamente de la BD !")
        } catch {
            print("error al leer de la BD")
        }
        notasCollection.reloadData()
    }
    
    // MARK:  Edit
    private func goEditNote(_ Nota: Notas){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditarNotaViewController") as! EditarNotaViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.recibirNota = Nota
        self.present(vc, animated: true)
    }
    
    // MARK:  Delete
    private func deleteNote(_ nota: Notas, position: Int) {
        self.contexto.delete(nota)
        self.notas2.remove(at: position)
        do{
            try self.contexto.save()
        } catch {
            print("Error al guardar contexto")
        }
        
        UIView.animate(withDuration: 1, delay: 0) {
            self.notasCollection.reloadData()
        }
        
        playSound(cualNota: "drop")
    }
    
    private func playSound(cualNota: String){
        // guard - sirve para desenvoler una variable opcional
        guard let url = Bundle.main.url(forResource: cualNota, withExtension: "wav") else {
            return
        }
        
        ///Tratar de reproducir el contenido de una url
        do {
            //Preparamos al reproductor con el sonido a reproducir
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error al reproducir sonido")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        goEditNote(notas2[indexPath.row])
    }
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notas2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "NotaCuadradaCell", for: indexPath) as! NotaCuadradaCell
        
        celda.textoNota.text = notas2[indexPath.row].titulo
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy, hh:mm"
        
        let dataFromAPI = dateFormatter.date(from: "\(notas2[indexPath.row].fecha ?? Date.now)")
        let date = dateFormatter.string(from: dataFromAPI ?? Date.now)
        celda.fechaNota.text = date
        celda.imagenNota.image = UIImage(data: notas2[indexPath.row].imagen!)
        
        let color = Int.random(in: 0..<colores.count)
        celda.fondoNota.backgroundColor = colores[color]
        celda.didTapDotsButton = { [weak self] in
            guard let self = self else { return }
            self.notePressed(cualNota: self.notas2[indexPath.row], positionNote: indexPath.row)
        }
        return celda
    }
    
    private func notePressed(cualNota: Notas, positionNote: Int){
        //Vibracion
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        let alerta = UIAlertController(title: "Hola", message: "¿Qué te gustaría realizar?", preferredStyle: .alert)
        let editar = UIAlertAction(title: "Editar nota", style: .default) { _ in
            self.goEditNote(cualNota)
        }
        
        let borrar = UIAlertAction(title: "Borrar nota", style: .destructive) { _ in
            self.deleteNote(cualNota, position: positionNote)
        }
        
        let compartir = UIAlertAction(title: "Compartir nota", style: .default) { _ in
            
            let date = cualNota.fecha ?? Date.now
            let format = date.getFormattedDate(format: "MM-dd-yyyy HH:mm")
            
            let vc = UIActivityViewController(activityItems:
                                                ["\(cualNota.titulo ?? ""), \(format)", UIImage(data: cualNota.imagen!) ?? UIImage(systemName: "heart.fill")!], applicationActivities: nil)
            self.present(vc, animated: true)
        }
        alerta.addAction(editar)
        alerta.addAction(compartir)
        alerta.addAction(borrar)
        present(alerta, animated: true)
    }
    
    
    
    @IBAction func nuevaNotaButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NuevaNotaViewController") as! NuevaNotaViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true)
    }
    

}
//EXTENSION
extension Notas2ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 197, height: 251)
    }
}
