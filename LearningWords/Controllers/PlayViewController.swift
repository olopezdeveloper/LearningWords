//
//  PlayViewController.swift
//  LearningWords
//
//  Created by Administrador on 11/02/18.
//  Copyright © 2018 Administrador. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController {
    @IBOutlet weak var labelLevel: UILabel!
    @IBOutlet weak var imageWord: UIImageView!
    @IBOutlet weak var fieldWord: UITextField!
    @IBOutlet weak var labelGreat: UILabel!
    @IBOutlet weak var labelBad: UILabel!
    
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var buttonAway: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonAgain: UIButton!
    
    var current_word = ""
    var current_level = 1
    var current_siri = 0
    var hasSiriHelped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cargarJuego()
    }
    
    // iniciador de juego
    func cargarJuego(){
        labelLevel.text = String(current_level)
        let randonWord = getRandomWord()
        imageWord.image = UIImage(named: randonWord)
        labelGreat.isHidden = true
        labelBad.isHidden = true
        buttonNext.isHidden = true
        buttonAway.isHidden = true
        buttonAgain.isHidden = true
        buttonSend.isEnabled = true
        fieldWord.text = ""
        hasSiriHelped = false
        current_word = randonWord
    }
    // respuesta correcta
    func showGreat() {
        labelGreat.isHidden = false
        buttonNext.isHidden = false
    }
    // respuesta equivocada
    func showBad() {
        labelBad.isHidden = false
        buttonAgain.isHidden = false
        buttonAway.isHidden = false
    }
    // traer palabra ramdon
    func getRandomWord() -> String{
        
        if let registros = DataBase.shared().ejecutarSelect("select * from words ORDER BY RANDOM() limit 1") as? [[String:String]]{
            let arrayRecords = registros
            if let randonWord = arrayRecords[0]["text"]{
                return randonWord
            }
        }
        return ""
    }
    // checkear si palabra ingresada es correcta
    func checkWord(word:String?) -> Bool {
        if current_word.lowercased() == word?.lowercased() {
            current_level += 1
            return true
        }else{
            saveRecord()
            return false
        }
    }
    // Guardar Record de la partida
    func saveRecord(){
        let date = Date()
        let formatter = DateFormatter()
        let formatterHour = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy"
        formatterHour.dateFormat = "hh:mm a"
        let current_date = formatter.string(from: date)
        let current_hour = formatterHour.string(from: date)
        let insertSQL = "insert into records(\(kLevel),\(kSiriHelp),\(kDate),\(kHour)) values ('\(current_level)','\(current_siri)','\(current_date)','\(current_hour)')"
        //print(insertSQL)
        DataBase.shared().ejecutarInsert(insertSQL)
        
    }
    // Reproducir palabra
    func reproducir(message:String?) {
        guard let message = message else {
            return
        }
        let synthesizer   = AVSpeechSynthesizer()
        //synthesizer.delegate = self
        let utterance = AVSpeechUtterance(string: message)
        //utterance.voice = AVSpeechSynthesisVoice(language: "es-PE")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.volume = 1
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
    
    @IBAction func sendWord(_ sender: Any) {
        let wordField = fieldWord.text
        
        buttonSend.isEnabled = false
        let response = checkWord(word: wordField)
        if (response){
            showGreat()
        }else{
            showBad()
        }
    }
    
    @IBAction func nextWord(_ sender: Any) {
        cargarJuego()
    }
    @IBAction func tryAgain(_ sender: Any) {
        current_level = 1
        current_siri = 0
        cargarJuego()
    }
    
    @IBAction func runAway(_ sender: Any) {
        performSegue(withIdentifier: "retornoListaRecords", sender: nil)
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func siriHelp(_ sender: Any) {
        if hasSiriHelped == false {
            current_siri += 1
            hasSiriHelped = true
        }
        reproducir(message: current_word)
    }
}
