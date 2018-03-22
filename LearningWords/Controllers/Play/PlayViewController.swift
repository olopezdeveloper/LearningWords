//
//  PlayViewController.swift
//  LearningWords
//
//  Created by Administrador on 11/02/18.
//  Copyright © 2018 Administrador. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    //MARK:- IBOutlet Game Play
    @IBOutlet private weak var labelLevel: UILabel!
    @IBOutlet private weak var imageWord: UIImageView!
    @IBOutlet private weak var fieldWord: UITextField!
    @IBOutlet private weak var labelGreat: UILabel!
    @IBOutlet private weak var labelBad: UILabel!
    @IBOutlet private weak var labelSiriHelp: UILabel!
    
    @IBOutlet private weak var buttonSend: UIButton!
    @IBOutlet private weak var buttonAway: UIButton!
    @IBOutlet private weak var buttonNext: UIButton!
    @IBOutlet private weak var buttonAgain: UIButton!
    @IBOutlet private weak var buttonShare: UIButton!
    
    @IBOutlet private weak var sharePlayButton: UIBarButtonItem!
    
    //MARK:- Variables del Juego
    //Convertir en Objeto en Version 1.01
    var current_level = 1
    private var current_word = ""
    private var current_siri = 0
    private var hasSiriHelped = false
    private var arrayWord = [String]()
    private var siriHelp = SIRI_HELP
    
    private var imageView = UIImageView()
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Carga la vista por primera vez
        cargarJuego()
        
        let jeremyGif = UIImage.gifImageWithName("loading")
        imageView = UIImageView(image: jeremyGif)
        
    }
    
    //MARK:- Private Functions Game Play
    // iniciador de juego
    private func cargarJuego(){
        labelLevel.text = String(current_level)
        let randonWord = getRandomWord()
        imageWord.image = UIImage(named: randonWord)
        labelGreat.isHidden = true
        labelBad.isHidden = true
        labelSiriHelp.text = String(SIRI_HELP)
        buttonNext.isHidden = true
        buttonAway.isHidden = true
        buttonShare.isHidden = true
        buttonAgain.isHidden = true
        buttonSend.isEnabled = true
        buttonSend.isHidden = false
        buttonSend.backgroundColor = UIColor.green
        fieldWord.text = ""
        hasSiriHelped = false
        siriHelp = SIRI_HELP
        current_word = randonWord
    }
    // respuesta correcta
    private func showGreat() {
        labelGreat.isHidden = false
        buttonNext.isHidden = false
    }
    // respuesta equivocada
    private func showBad() {
        labelBad.isHidden = false
        buttonAgain.isHidden = false
        buttonAway.isHidden = false
        buttonShare.isHidden = false
        buttonNext.isHidden = true
    }
    // traer palabra ramdon
    private func getRandomWord() -> String{
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
    private func checkWord(word:String?) -> Bool {
        if current_word.lowercased() == word?.lowercased() {
            return true
        }else{
            saveRecord()
            return false
        }
    }
    // Guardar Record de la partida SQLite
    private func saveRecord(){
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
    // Remover loading
    private func removeLoading() {
        imageView.removeFromSuperview()
    }
    
    //MARK:- IBAction Events
    @IBAction private func sendWord(_ sender: Any) {
        let wordField = fieldWord.text
        
        buttonSend.isEnabled = false
        buttonSend.backgroundColor = UIColor.gray
        let response = checkWord(word: wordField)
        if (response){
            if current_level > CORRECT_WORD_TO_WIN{
                performSegue(withIdentifier: "victory", sender: nil)
            }else{
                showGreat()
                current_level += 1
            }
        }else{
            showBad()
        }
    }
    
    @IBAction private func nextWord(_ sender: Any) {
        arrayWord.append(current_word)
        cargarJuego()
    }
    
    @IBAction private func tryAgain(_ sender: Any) {
        current_level = 1
        current_siri = 0
        arrayWord = [String]()
        cargarJuego()
    }
    
    @IBAction private func siriHelp(_ sender: Any) {
        if hasSiriHelped == false {
            current_siri += 1
            hasSiriHelped = true
        }
        if siriHelp > 0 {
            
            
            imageView.frame = CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: 150.0)
            view.addSubview(imageView)
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                reproducir(message: self?.current_word, end: {
                    DispatchQueue.main.async {
                        self?.removeLoading()
                    }
                })
            }
                
            siriHelp -= 1
            labelSiriHelp.text = String(siriHelp)
            
        }
        
    }
    @IBAction private func shareLose(_ sender: Any) {
        let message = "#\(current_word) Lvl \(current_level) Aprendiendo ingles con #LearningWords #olopezdeveloper"
        
        let activityController = socialShare(withMessage: message, withImage: current_word)
        
        present(activityController, animated: true, completion: nil)
    }
    
    //MARK:- Segue Game Over Victory
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let victory = segue.destination as? GameOverViewController {
            victory.current_level = current_level
        }
    }
}
