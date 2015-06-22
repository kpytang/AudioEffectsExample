//
//  EffectsViewController.swift
//  Pitch Perfect
//
//  Created by Karen Tang on 6/21/15.
//  Copyright (c) 2015 Yugen Labs. All rights reserved.
//

import UIKit
import AVFoundation

class EffectsViewController: UIViewController, AVAudioPlayerDelegate {

  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var playButtonLabel: UILabel!
  @IBOutlet weak var stopButton: UIButton!

  var audioPlayer: AVAudioPlayer!
  var audioPlayerNode: AVAudioPlayerNode!
  var audioEngine: AVAudioEngine!
  var audioFile: AVAudioFile!
  var recordedAudio: RecordedAudio!

  override func viewDidLoad() {
    super.viewDidLoad()
    showPlayButton(true)

    println(recordedAudio.filePathUrl)

    // initialize audio player with passed in file name
    audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl!, error: nil)
    audioPlayer.delegate = self
    audioPlayer.enableRate = true

    // initialize audio engine
    audioEngine = AVAudioEngine()
    audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
    finishedPlaying()
  }

  func finishedPlaying() {
    showPlayButton(true)
  }

  @IBAction func lowerAudioPitch(sender: UIButton) {
    showPlayButton(false)

    playAudioWithVariablePitch(pitch: -1000)
  }

  func playAudioWithVariableRate(rate:Float = 1.0) {
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()

    audioPlayer.rate = rate
    audioPlayer.currentTime = 0.0
    audioPlayer.play()
  }

  func playAudioWithVariablePitch(pitch:Float = 1.0) {
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()

    // add audio player to audio engine
    audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)

    // add pitch effect to audio engine
    var pitchEffect = AVAudioUnitTimePitch()
    pitchEffect.pitch = pitch
    audioEngine.attachNode(pitchEffect)

    // apply pitch effect to audio player and play
    audioEngine.connect(audioPlayerNode, to: pitchEffect, format: nil)
    audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)

    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: finishedPlaying)
    audioEngine.startAndReturnError(nil)
    audioPlayerNode.play()
  }

  func playAudioWithVariableReverb(reverb:Float = 0.0) {
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()

    // add audio player to audio engine
    audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)

    // add pitch effect to audio engine
    var reverbEffect = AVAudioUnitReverb()
    var delayEffect = AVAudioUnitDelay()
    delayEffect.delayTime = 1.0
    delayEffect.feedback = 80
    audioEngine.attachNode(delayEffect)
    audioEngine.attachNode(reverbEffect)

    // apply pitch effect to audio player and play
    audioEngine.connect(audioPlayerNode, to: delayEffect, format: nil)
    audioEngine.connect(delayEffect, to: reverbEffect, format: nil)
    audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)

    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: finishedPlaying)
    audioEngine.startAndReturnError(nil)
    audioPlayerNode.play()
  }

  @IBAction func playAudio(sender: UIButton) {
    if (!playButton.hidden) {
      playAudioWithVariableRate(rate: 1.0)
      showPlayButton(false)
    }
  }

  @IBAction func raiseAudioPitch(sender: UIButton) {
    showPlayButton(false)
    playAudioWithVariablePitch(pitch: 1000)
  }

  @IBAction func reverb(sender: UIButton) {
    showPlayButton(false)
    playAudioWithVariableReverb(reverb: 20)
  }
  
  func showPlayButton(show: Bool) {
    stopButton.hidden = show
    playButton.hidden = !show
    playButtonLabel.hidden = !show
  }

  @IBAction func slowDownAudio(sender: UIButton) {
    showPlayButton(false)
    playAudioWithVariableRate(rate: 0.5)
  }

  @IBAction func speedUpAudio(sender: UIButton) {
    showPlayButton(false)
    playAudioWithVariableRate(rate: 2.0)
  }

  @IBAction func stopAudio(sender: UIButton) {
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()

    showPlayButton(true)
  }

  
  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  */

}
