//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Henry Zhang on 6/26/15.
//  Copyright (c) 2015 Henry Zhang. All rights reserved.
//
//  This PlaySoundViewController handles the playing of the audio file. At this moment, it supports the
//  following ways to play the audio:
//      1. Slow, 2. Fast, 3. Like a Chipmunk, 4. Like a Darth Vader
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    // Global veraibles
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // When the View loaded, prepare the audioPlayer and the audioEngine
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioPlayer.volume = 1.0
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func slowPlayer(sender: AnyObject) {
        playAudio(0.5)
    }

    @IBAction func fastPlayer(sender: AnyObject) {
        playAudio(2.0)
    }
    
    @IBAction func stopPlayingAudio(sender: UIButton) {
        stopAudio()
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    

    //
    // This function handles the common actions by the slowPlayer and fastPlayer Actions
    //
    func playAudio( rate: Float) {
        audioEngine.stop()      // stop the audioEngine
        audioEngine.reset()     // reset the audioEngine
        audioPlayer.stop()      // stop the audio player
        audioPlayer.rate = rate // set the audioPlayer's rate
        audioPlayer.currentTime = 0.0   // the default audioPlayer's currentTimeto set to 0.0
        audioPlayer.play()      // start playing the audio
    }

    //
    //  This function stops the audioPlay and stop and reset the audioEngine
    //
    func stopAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAudio()     // stop audio
        
        var audioPlayerNode = AVAudioPlayerNode()   // get an instance of AVAudioPlayerNode
        audioEngine.attachNode(audioPlayerNode)     // attach the audioPlayerNode to audioEngine
        
        var changePitchEffect = AVAudioUnitTimePitch()  // get an instance of AVAudioUnitTimePitch
        changePitchEffect.pitch = pitch                 // reset the pitch value
        audioEngine.attachNode(changePitchEffect)       // configure the Pitch effect of the auodEngine
        
        // connect the audioEngine to the audioPlayerNode
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()  // play
    }
}
