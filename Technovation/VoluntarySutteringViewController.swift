//
//  VoluntarySutteringViewController.swift
//  Technovation
//
//  Created by Vicky Liu on 10/13/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class VoluntarySutteringViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    let voices = AVSpeechSynthesisVoice.speechVoices()
    let voiceSynth = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.voiceSynth.delegate = self
    }

    @IBAction func voluntaryStuttering(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: "Ha ha happy")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.3
        voiceSynth.speak(utterance)
    }
}
