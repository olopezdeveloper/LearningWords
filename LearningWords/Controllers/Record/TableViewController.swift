//
//  TableViewController.swift
//  LearningWords
//
//  Created by Administrador on 22/02/18.
//  Copyright © 2018 Administrador. All rights reserved.
//

import UIKit

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
    func borrarRegistros(pk:String){
        DataBase.shared().ejecutarSelect("delete from records where id = \(pk)")
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
        cell.delegate = self
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
    
    // Delete Record
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // send to delete sql
            let record = arrayRecords[indexPath.row]
            if let pk = record[kId]{
                borrarRegistros(pk: pk)
            }
            arrayRecords.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
}

extension TableViewController:RecordCellDelegate {
    func llamarSiri(text: String) {
        reproducir(message: text)
    }
}
