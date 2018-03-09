//
//  toolsGame.swift
//  LearningWords
//
//  Created by Administrador on 8/03/18.
//  Copyright © 2018 Administrador. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


    
func socialShare(withMessage message:String, withImage image:String?) -> UIActivityViewController {
    //compartir la imagen
    var items = [Any]()
    //validando que exista la imagen
    if let image = image {
        if let image = UIImage(named: image){
            items.append(image)
        }
    }
    
    items.append(message)
    
    let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    
    return activityController
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
