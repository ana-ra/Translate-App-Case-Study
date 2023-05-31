//
//  SpeechManager.swift
//  translateStudy
//
//  Created by Pedro Ceccon on 31/05/23.
//

import Foundation
import Speech
import SwiftUI

actor SpeechManager: ObservableObject {
    
    var transcribed: String = ""
    var locale: String = "pt"
    
    func setLocale(_ code: String?) {
        if let languageCode = code {
            locale = languageCode
        }
    }
    
    func resetTranscription() {
        transcribed = ""
    }
    
    @MainActor
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
    
    
    let speechRecognizer = SFSpeechRecognizer()!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    func startRecording() throws {
      
      // Cancel the previous recognition task.
      recognitionTask?.cancel()
      recognitionTask = nil
      
      // Audio session, to get information from the microphone.
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
      let inputNode = audioEngine.inputNode
      
      // The AudioBuffer
      recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
      recognitionRequest!.shouldReportPartialResults = true
      
      // Force speech recognition to be on-device
      if #available(iOS 13, *) {
        recognitionRequest!.requiresOnDeviceRecognition = true
      }
      
      // Actually create the recognition task. We need to keep a pointer to it so we can stop it.
      recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { result, error in
        var isFinal = false
        
        if let result = result {
          isFinal = result.isFinal
          print("Text \(result.bestTranscription.formattedString)")
        }
        
        if error != nil || isFinal {
          // Stop recognizing speech if there is a problem.
            self.audioEngine.stop()
          inputNode.removeTap(onBus: 0)
          
            self.recognitionRequest = nil
            self.recognitionTask = nil
        }
      }
      
      // Configure the microphone.
      let recordingFormat = inputNode.outputFormat(forBus: 0)
        // The buffer size tells us how much data should the microphone record before dumping it into the recognition request.
      inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
          self.recognitionRequest?.append(buffer)
      }
      
      audioEngine.prepare()
      try audioEngine.start()
    }
    
    func transcribeAudio(url: URL) -> String {
        // create a new recognizer and point it at our audio
        var recognizer = SFSpeechRecognizer(locale: Locale(identifier: locale))
        let request = SFSpeechURLRecognitionRequest(url: url)
        // start recognition!
        recognizer?.recognitionTask(with: request) { [unowned self] (result, error) in
            // abort if we didn't get any transcription back
            guard let result = result else {
                fatalError("error")
            }

            // if we got the final transcription back, print it
            if result.isFinal {
                self.transcribed = result.bestTranscription.formattedString
            }
        }
        return transcribed
    }
}
