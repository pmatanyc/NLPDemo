//
//  MainController.swift
//  NLPDemo
//
//  Created by Paola Mata on 7/22/17.
//  Copyright © 2017 BuzzFeed Inc. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class MainViewController: UIViewController, SFSpeechRecognizerDelegate {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!

    private var isSpeechRecognitionAuthorized: Bool = SFSpeechRecognizer.authorizationStatus() == SFSpeechRecognizerAuthorizationStatus.authorized

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    override func viewDidLoad() {
        super.viewDidLoad()

        recordButton.isEnabled = isSpeechRecognitionAuthorized
        speechRecognizer?.delegate = self

        if !isSpeechRecognitionAuthorized {
            SFSpeechRecognizer.requestAuthorization { authStatus in
                switch authStatus {
                case .notDetermined:
                    print("speech recognition not yet authorized")
                case .authorized:
                    break
                case .denied, .restricted:
                    let alert = UIAlertController(title: "Permission", message: "Update permissions in Settings", preferredStyle: UIAlertControllerStyle.alert)
                    let dismissAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                    let settingsAction = UIAlertAction(title: "Go to Setting", style: UIAlertActionStyle.default, handler: { _ in
                        // Direct user to app's settings
                    })
                    alert.addAction(dismissAction)
                    alert.addAction(settingsAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
        }

        recordButton.isEnabled = false
    }

    @IBAction func recordButtonPressed(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            recordButton.setTitle("Stop Recording", for: .normal)
        }
    }

    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("error setting audio session properties")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let recognitionRequest = recognitionRequest else {
            fatalError("error creating SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] result, error in
            guard let strongSelf = self else { return }

            var isFinal = false

            if let result = result {
                isFinal = result.isFinal

                if isFinal {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let textAnalysisVC = storyboard.instantiateViewController(withIdentifier: "TextAnalysis") as? TextAnalysisViewController
                    if let textAnalysisVC = textAnalysisVC {
                        textAnalysisVC.text = result.bestTranscription.formattedString
                        strongSelf.navigationController?.pushViewController(textAnalysisVC, animated: true)
                    }
                }
            }

            if error != nil || isFinal {
                strongSelf.audioEngine.stop()
                strongSelf.audioEngine.inputNode.removeTap(onBus: 0)

                strongSelf.recognitionRequest = nil
                strongSelf.recognitionTask = nil
                strongSelf.recordButton.isEnabled = true
            }
        })

        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, when in
            guard let strongSelf = self else { return }
            strongSelf.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            print("error starting audio engine")
        }
    }
}
