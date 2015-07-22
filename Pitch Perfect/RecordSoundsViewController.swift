//
//  RecordSoundsViewController.swif
//  Pitch Perfect
//
//  Created by Henry Zhang on 6/15/15.
//  Copyright (c) 2015 Henry Zhang. All rights reserved.
//
//  The RecordSoundsViewController handles any actions related to start resording, stop recording, prepare for Segue.

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // Global variables
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        
        // Hide the Stop button when the view appears
        stopButton.hidden = true
        
        // Enable the Record button
        recordingButton.enabled = true
        
        // Show the 'Tap to Record' message when the view appears
        recordingInProgress.text = "Tap to Record"
        recordingInProgress.hidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // When the Segue detects that the recording stops, pass the audio file to the playSoundsVC to use
        if ( segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        // toggle on the 'Recording in progress' message when the Record button is pressed
        recordingInProgress.hidden = false
        recordingInProgress.text = "Recording in progress"
        
        // Hide the Stop button and disable the Recording button when Recording is in progress
        stopButton.hidden = false
        recordingButton.enabled = false
        
        // Get the Directory where the app has access to store a file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        // Name the audio file
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Instantiate an AVAudioSession and make it can play andrecord
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
        
        // Prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            // If the recording finished successfullly, set the path to the file and the title of the recording, 
            // and setup the Segue
            recordedAudio = RecordedAudio( filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            // else output an error message to the debugger, enable the Record button, hide the Stop button
            println("Recording was not successful")
            recordingButton.enabled = true
            stopButton.hidden = true
        }
        
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        // When the stop button is pressed, hide the Recording button, stop the recorder, and inactivate the audioSession
        recordingInProgress.hidden = true
        recordingButton.enabled = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

