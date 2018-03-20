//
//  RecordCell.swift
//  LearningWords
//
//  Created by Administrador on 11/02/18.
//  Copyright © 2018 Administrador. All rights reserved.
//

import UIKit

protocol RecordCellDelegate:NSObjectProtocol {
    func llamarSiri(text:String)
}

class RecordCell: UITableViewCell {
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var horaLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var siriLabel: UILabel!
    
    weak var delegate:RecordCellDelegate?
    
    func configurarCelda(fecha:String?, hora:String?, level:String?, siri:String?  ){
        fechaLabel.text = fecha
        horaLabel.text = hora
        levelLabel.text = level
        siriLabel.text = siri
    }

    @IBAction func callProtocolSiri(_ sender: Any) {
        let text = "Level \(levelLabel.text ?? "")"
        delegate?.llamarSiri(text: text)
    }
}
