//
//  SpeakIntro.swift
//  Technovation
//
//  Created by Vicky Liu on 4/5/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//
import AVFoundation
import Speech

protocol CanSpeakDelegate {
   func speechDidFinish()
}

class CanSpeak: NSObject, AVSpeechSynthesizerDelegate {

   let voices = AVSpeechSynthesisVoice.speechVoices()
   let voiceSynth = AVSpeechSynthesizer()

   var delegate: CanSpeakDelegate!
    
    override init(){
        super.init()
        self.voiceSynth.delegate = self
     }
    
    func sayThis(_ keyWord: String){
        let utterance = AVSpeechUtterance(string: "Repeat after me: \(keyWord)")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        voiceSynth.speak(utterance)
    }
    
    func voluntarySpeech() {

    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.delegate.speechDidFinish()
    }
}
