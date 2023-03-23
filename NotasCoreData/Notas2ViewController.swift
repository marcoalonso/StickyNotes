//
//  Notas2ViewController.swift
//  NotasCoreData
//
//  Created by Marco Alonso Rodriguez on 22/03/23.
//

import UIKit
import CoreData

class Notas2ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    var notas2 : [Notas] = []
    
    //Conexion a la bd o al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        
        return celda
    }

}
//EXTENSION
extension Notas2ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 197, height: 235)
    }
}
