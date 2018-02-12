//
//  ViewController.swift
//  LearningWords
//
//  Created by Administrador on 10/02/18.
//  Copyright © 2018 Administrador. All rights reserved.
//

import UIKit


let kLevel = "record_level"
let kDate = "record_date"
let kHour = "record_hour"
let kSiriHelp = "siri_help"

class ViewController: UIViewController {
    @IBOutlet weak var talbeView: UITableView!
    
    var arrayRecords = [[String:String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cargarRegistros()
    }

    func cargarRegistros(){
        if let registros = DataBase.shared().ejecutarSelect("select * from records order by \(kLevel) desc, \(kSiriHelp) asc limit 10") as? [[String:String]]{
            arrayRecords = registros
            talbeView.reloadData()
        }
        
    }
    
    @IBAction func retornoListaRecords(segue:UIStoryboardSegue) {
        if let _ = segue.source as? PlayViewController {
            cargarRegistros()
        }
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    // Definir el numero de secciones
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Definir el numero de filas por seccion
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRecords.count
    }
    
    // Definir la vista por cada celda
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = arrayRecords[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell
        
        let level = record[kLevel]
        let siri = record[kSiriHelp]
        let fecha = record[kDate]
        let hour = record[kHour]
        
        cell.configurarCelda(fecha: fecha, hora: hour, level: level, siri: siri)
        return cell
    }
    
    // Definir altura de la celda
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
