//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Karen Tang on 6/21/15.
//  Copyright (c) 2015 KPT. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
  let tapToRecordString = "Tap to Record"
  let tapToContinueString = "Tap to Continue Recording"
  let recordingInProgressString = "Recording..."
  let savingString = "Saving Audio File..."

  @IBOutlet weak var pauseButton: UIButton!
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var recordingLabel: UILabel!
  @IBOutlet weak var stopButton: UIButton!

  var audioRecorder: AVAudioRecorder!
  var dirPath: NSString!
  var formatter = NSDateFormatter()
  var recordedAudio: RecordedAudio!

  override func viewDidLoad() {
    super.viewDidLoad()
    // initialize the type of formatter we're using
    formatter.dateFormat = "yyyyMMdd-HHmmss"
    // initialize the directory path where we'll save the sound files to
    dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

    // add a button to the navigation menu
    let fileBrowserButton = UIBarButtonItem(image: UIImage(named: "browser"), style: .Plain, target: self, action: "goToFileBrowser")
    navigationItem.setRightBarButtonItems([fileBrowserButton], animated: true)
  }

  override func viewDidAppear(animated: Bool) {
    stopButton.hidden = true
    pauseButton.hidden = true
    recordButton.enabled = true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "stopRecording") {
      let effectsViewController: EffectsViewController = segue.destinationViewController as EffectsViewController
      let data = sender as RecordedAudio
      effectsViewController.recordedAudio = data
    }
  }

  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    recordingLabel.text = tapToRecordString

    if (flag) {
      // save file info
      println(recorder.url)
      recordedAudio = RecordedAudio(url: recorder.url, title: recorder.url.lastPathComponent!)
      performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    } else {
      println("Error: recording not successful");
      stopButton.hidden = true
      pauseButton.hidden = true
      recordButton.enabled = true
    }
  }

  func getSaveFilePathUrl() -> NSURL {
    var currentDateTime = NSDate()
    var fileName = formatter.stringFromDate(currentDateTime) + ".wav"
    var pathArray = [dirPath, fileName]

    return NSURL.fileURLWithPathComponents(pathArray)!
  }

  func goToFileBrowser() {
    performSegueWithIdentifier("fileBrowser", sender: nil)
  }

  @IBAction func pauseAudio(sender: UIButton) {
    recordingLabel.text = tapToContinueString
    pauseButton.enabled = false
    recordButton.enabled = true

    audioRecorder.pause();
  }

  @IBAction func recordAudio(sender: UIButton) {
    if (pauseButton.hidden) {
      // if pause button is hidden, then we are beginning to record
      var filePath = getSaveFilePathUrl()

      // initialize audio player
      var session = AVAudioSession.sharedInstance()
      session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
      audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
      audioRecorder.delegate = self;
      audioRecorder.meteringEnabled = true
      audioRecorder.prepareToRecord()
      // start recording
      audioRecorder.record()
    } else {
      // pause button isn't hidden, which means we are resuming a recording
      audioRecorder.record()
    }

    recordingLabel.text = recordingInProgressString
    stopButton.hidden = false
    pauseButton.hidden = false
    pauseButton.enabled = true
    recordButton.enabled = false
  }

  @IBAction func stopAudio(sender: UIButton) {
    recordingLabel.text = savingString
    stopButton.hidden = true
    pauseButton.hidden = true
    recordButton.enabled = true

    // stop recording
    audioRecorder.stop()
    var session = AVAudioSession.sharedInstance()
    session.setActive(false, error: nil)
  }

}

