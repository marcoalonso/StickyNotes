//
//  ViewController.swift
//  NotasCoreData
//
//  Created by Marco Alonso Rodriguez on 12/11/22.
//

import UIKit
import CoreData

class NotasViewController: UIViewController {

    //Conexion a la bd o al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var colores = [UIColor.red, UIColor.blue, UIColor.systemPink, UIColor.yellow, UIColor.green, UIColor.orange, UIColor.gray, UIColor.purple, UIColor.brown, UIColor.magenta, UIColor.cyan]
    
    var notas = [Notas]()
    var notaEditar: Notas?
    
    
    @IBOutlet weak var tablaNotas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablaNotas.register(UINib(nibName: "NotaCell", bundle: nil), forCellReuseIdentifier: "celda")
        
        tablaNotas.delegate = self
        tablaNotas.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        leerNotas()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func leerNotas(){
        let solicitud: NSFetchRequest<Notas> = Notas.fetchRequest()
        do{
            notas = try contexto.fetch(solicitud)
            print("Debug: Se leyo correctamente de la BD !")
        } catch {
            print("error al leer de la BD")
        }
        tablaNotas.reloadData()
    }
    
    
}

extension NotasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! NotaCell
        celda.tituloNota.text = notas[indexPath.row].titulo
        
        let date = notas[indexPath.row].fecha ?? Date.now
        let format = date.getFormattedDate(format: "dd MM dd")
        
        celda.fechaNota.text = format
        
        let color = Int.random(in: 0..<colores.count)
        celda.backgroundColor = colores[color]
        celda.fechaNota.textColor = .black
        celda.fechaNota.font = .systemFont(ofSize: 20)
          
        let imagenBD = UIImage(data: notas[indexPath.row].imagen!)
        celda.notaLogo.image =  imagenBD
        celda.notaLogo.layer.cornerRadius = 15
        celda.notaLogo.layer.masksToBounds = true
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Guardar la nota a mandar
        notaEditar = notas[indexPath.row]
        performSegue(withIdentifier: "editar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar"{
            let objDestino = segue.destination as! EditarNotaViewController
            objDestino.recibirNota = notaEditar
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "") { _, _, _ in
            
            self.contexto.delete(self.notas[indexPath.row])
            self.notas.remove(at: indexPath.row)
            do{
                try self.contexto.save()
            } catch {
                
            }
            self.tablaNotas.reloadData()
        }
        
        accionEliminar.image = UIImage(systemName: "trash")
        accionEliminar.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEjemplo = UIContextualAction(style: .normal, title: "algo") { _, _, _ in
            print("Debug: Hacer algo ... ")
        }
        
        let accionEnviarCorreo = UIContextualAction(style: .destructive, title: "") { _, _, _ in
            print("Enviar correo")
        }
        
        accionEnviarCorreo.backgroundColor = .green
        accionEnviarCorreo.image = UIImage(systemName: "note")
        
        accionEjemplo.image = UIImage(systemName: "person")
        accionEjemplo.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [accionEjemplo, accionEnviarCorreo])
    }
    
    
    
}
