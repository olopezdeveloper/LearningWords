//
//  TableViewController.swift
//  LearningWords
//
//  Created by Administrador on 22/02/18.
//  Copyright © 2018 Administrador. All rights reserved.
//

import UIKit

let kLevel = "record_level"
let kDate = "record_date"
let kHour = "record_hour"
let kSiriHelp = "siri_help"

class TableViewController: UITableViewController {
    var arrayRecords = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarRegistros()
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    func cargarRegistros(){
        if let registros = DataBase.shared().ejecutarSelect("select * from records order by \(kLevel) desc, \(kSiriHelp) asc limit 10") as? [[String:String]]{
            arrayRecords = registros
            self.tableView.reloadData()
        }
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayRecords.count
    }

    // Definir la vista por cada celda
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
