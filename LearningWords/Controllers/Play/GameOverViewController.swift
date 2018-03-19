//
//  GameOverViewController.swift
//  LearningWords
//
//  Created by Administrador on 8/03/18.
//  Copyright © 2018 Administrador. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    var current_level = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction private func shareVictory(_ sender: Any) {
        let message = "#LearningWords Lvl \(current_level) I'm a Winner! Aprendiendo ingles con #olopezdeveloper"
        
        let activityController = socialShare(withMessage: message, withImage: nil)
        print(message)
        present(activityController, animated: true, completion: nil)
    }
    
}
