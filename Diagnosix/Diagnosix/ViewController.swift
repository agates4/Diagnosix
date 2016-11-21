/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The primary view controller. The speach-to-text engine is managed an configured here.
 */

import UIKit
import Speech
import SwiftyJSON
import Alamofire
import SwiftSiriWaveformView

public class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var textLabel: UITextView!
    @IBOutlet weak var audioView: SwiftSiriWaveformView!
    var timer:Timer?
    var startTime = TimeInterval()
    var timerTime = Timer()
    var change:CGFloat = 0.01
    
    //@IBOutlet weak var header: UIImageView!
    let mainColor = UIColor(red:0.26, green:0.52, blue:0.96, alpha:1.0)
    let secondaryColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
    let darkColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
    let lightColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
    
    private var diagnosisString = "";
    // MARK: Properties
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    //@IBOutlet var textView : UITextView!
    
    @IBOutlet var recordButton : UIButton!
    
    // MARK: UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.audioView.density = 1.0
        
        textLabel.text = "Ready to record?"
        //header.backgroundColor = mainColor
        //self.view.backgroundColor = secondaryColor
        //self.textLabel.textColor = darkColor
        //textView.textContainerInset = UIEdgeInsetsMake(10,10,10,10);
        
        // Disable the record buttons until authorization has been granted.
        recordButton.isEnabled = false
    }
    
    internal func refreshAudioView(_:Timer) {
        if self.audioView.amplitude <= self.audioView.idleAmplitude || self.audioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.audioView.amplitude += self.change
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                    
                case .denied:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    
    //override public var preferredStatusBarStyle: UIStatusBarStyle {
    //    return .lightContent
    //}
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            self.textLabel.font = self.textLabel.font?.withSize(18)
            if let result = result {
                self.diagnosisString = result.bestTranscription.formattedString
                self.textLabel.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            else
            {
                self.textLabel.text = "Ready to record?"
                self.audioView.numberOfWaves = 0
                self.timer?.invalidate()
                self.timerTime.invalidate()
                //toDiagnosList
                self.textLabel.textAlignment = .center
                self.textLabel.font = self.textLabel.font?.withSize(28)
                self.textLabel.text = "Ready to record?"
                let image : UIImage = UIImage(named : "notR_copy.png")!
                self.recordButton.setImage(image, for: .normal)
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                self.recordButton.setTitle("Start Recording", for: [])
                
                self.audioView.numberOfWaves = 0
                self.timer?.invalidate()
                self.timerTime.invalidate()
                //toDiagnosList
                self.textLabel.textAlignment = .center
                self.textLabel.font = self.textLabel.font?.withSize(28)
                self.textLabel.text = "Ready to record?"
                let image : UIImage = UIImage(named : "notR_copy.png")!
                self.recordButton.setImage(image, for: .normal)
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
        
        textLabel.text = "Ready to record?"
        self.audioView.numberOfWaves = 0
        self.timer?.invalidate()
        self.timerTime.invalidate()
        //toDiagnosList
        textLabel.textAlignment = .center
        self.textLabel.font = self.textLabel.font?.withSize(28)
        textLabel.text = "Ready to record?"
        let image : UIImage = UIImage(named : "notR_copy.png")!
        recordButton.setImage(image, for: .normal)
    }
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: [])
        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
    // MARK: Interface Builder actions
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
                
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        displayTimeLabel.text = "\(strMinutes):\(strSeconds)"
    }
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }  
    
    @IBAction func recordButtonTapped() {
        if audioEngine.isRunning
        {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Stopping", for: .disabled)
            textLabel.text = "Ready to record?"
            
            let parameters: Parameters = [
                "speech": diagnosisString
            ]
            var swiftyJsonVar : JSON!
            Alamofire.request("http://f5036f6d.ngrok.io/speech", method: .post, parameters: parameters, encoding: JSONEncoding(options: [])).responseJSON { (responseData) -> Void in
                var intID : Int = 0
                if((responseData.result.value) != nil) {
                    swiftyJsonVar = JSON(responseData.result.value!)
                    intID = Int(swiftyJsonVar.numberValue as Int!)
                    self.audioView.numberOfWaves = 0
                    self.timer?.invalidate()
                    self.timerTime.invalidate()
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! DiagnosisController
                    let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    controller.modalTransitionStyle = modalStyle
                    controller.sickID = intID
                    self.present(controller, animated: true, completion: nil)
                }
            }
            self.audioView.numberOfWaves = 0
            self.timer?.invalidate()
            self.timerTime.invalidate()
            //toDiagnosList
            textLabel.textAlignment = .center
            self.textLabel.font = self.textLabel.font?.withSize(28)
            textLabel.text = "Ready to record?"
            let image : UIImage = UIImage(named : "notR_copy.png")!
            recordButton.setImage(image, for: .normal)
        }
        else
        {
            try! startRecording()
            textLabel.textAlignment = .right
            textLabel.text = "Ready to record?"
            audioView.numberOfWaves = 5
            let aSelector : Selector = #selector(ViewController.updateTime)
            timerTime = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate
            timer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(ViewController.refreshAudioView(_:)), userInfo: nil, repeats: true)
            recordButton.setTitle("Stop recording", for: [])
            let image : UIImage = UIImage(named : "yesR_copy.png")!
            recordButton.setImage(image, for: .normal)
        }
    }
}

