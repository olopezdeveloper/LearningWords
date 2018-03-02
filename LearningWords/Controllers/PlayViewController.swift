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
    
    @IBOutlet weak var sharePlayButton: UIBarButtonItem!
    
    var current_word = ""
    var current_level = 1
    var current_siri = 0
    var hasSiriHelped = false
    var arrayWord = [String]()
    
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
        buttonSend.backgroundColor = UIColor.green
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
        var filterWord = ""
        if arrayWord.isEmpty == false {
            filterWord = arrayWord.joined(separator: "','")
        }
        if let registros = DataBase.shared().ejecutarSelect("select * from words where text not in ('\(filterWord)') ORDER BY RANDOM() limit 1") as? [[String:String]]{
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
        buttonSend.backgroundColor = UIColor.gray
        let response = checkWord(word: wordField)
        if (response){
            if arrayWord.count >= CORRECT_WORD_TO_WIN{
                performSegue(withIdentifier: "victory", sender: nil)
            }else{
                showGreat()
            }
        }else{
            showBad()
        }
    }
    
    @IBAction func nextWord(_ sender: Any) {
        arrayWord.append(current_word)
        cargarJuego()
    }
    @IBAction func tryAgain(_ sender: Any) {
        current_level = 1
        current_siri = 0
        cargarJuego()
    }
    
    
    @IBAction func siriHelp(_ sender: Any) {
        if hasSiriHelped == false {
            current_siri += 1
            hasSiriHelped = true
        }
        reproducir(message: current_word)
    }
    
    @IBAction func share(_ sender: Any) {
        //compartir la imagen
        var items = [Any]()
        //validando que exista la imagen
        if let image = UIImage(named: current_word){
            items.append(image)
        }
        items.append("#\(current_word) Aprendiendo ingles con #LearningWords #olopezdeveloper")
        
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        present(activityController, animated: true, completion: nil)
    }
    
}
