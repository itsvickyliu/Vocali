//
//  Recording.swift
//  Technovation
//
//  Created by Vicky Liu on 4/12/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit
import Speech

protocol SBSpeechRecognizerDelegate {
    func jump()
}

public class SBSpeechRecognizer: NSObject, SFSpeechRecognizerDelegate {
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audio = AVAudioEngine()
    var delegate: SBSpeechRecognizerDelegate!
    
    override init(){
        super.init()
     }
    
    func startRecording(_ keyWord: String,_ mode: String) throws
    {
        recognitionTask?.cancel()
        self.recognitionTask = nil
            
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audio.inputNode

        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
            
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
            
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            
            if mode == "Easy bouncing" {
                if let result = result {
                    let text = result.bestTranscription.formattedString
                    print (text)
                    if text != "" {
                        self.delegate.jump()
                    }
                }
            }
            
            else if mode == "Fluency" {
                if let result = result {
                    let resultArr = result.bestTranscription.formattedString.components(separatedBy: " ")
                    let n = resultArr.count
                    let text: String = resultArr[n-1]
                    print (text)
                    if text.lowercased() == keyWord {
                        self.delegate.jump()
                    }
                }
            }
                
            if error != nil {
                // Stop recognizing speech if there is a problem.
                self.audio.stop()
                print("stop audio - error")
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }

        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
            
        audio.prepare()
        try audio.start()
        print("start recording")
    }
    
    func stopRecording() {
        audio.stop()
        audio.inputNode.removeTap(onBus: 0) // Remove tap on bus when stopping recording.
        recognitionRequest?.endAudio()
    }
}
