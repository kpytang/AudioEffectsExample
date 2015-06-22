//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Karen Tang on 6/21/15.
//  Copyright (c) 2015 KPT. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
  var filePathUrl: NSURL!
  var title: String!

  init(url: NSURL, title: NSString) {
    println(url)
    self.filePathUrl = url
    self.title = title
  }
}