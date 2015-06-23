### AudioEffectsExample

A sample iOS app that showcases basic use cases for
[AVAudioPlayer](https://developer.apple.com/library/ios/documentation/AVFoundation/Reference/AVAudioPlayerClassReference/)
and [AVAudioEngine](https://developer.apple.com/library/prerelease/ios/documentation/AVFoundation/Reference/AVAudioEngine_Class/index.html)
using Swift 1.2

App allows you to:
* record audio
  * pause and resume while you are recording
  * save the recorded audio as a *.wav file in the Documents folder (filenames default to `yyyymmdd-HHmmss.wav` format
* use a simple file browser 
  * view previously recorded audio files (for now, only looks in the Document folder)
  * delete previously recorded audio files
* playback the recorded file
* apply audio effects
  * lower/increase the pitch
  * speed up/slow down the playback rate
  * add an echo/reverb
