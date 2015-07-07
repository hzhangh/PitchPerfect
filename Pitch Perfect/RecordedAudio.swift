//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Henry Zhang on 6/27/15.
//  Copyright (c) 2015 Henry Zhang. All rights reserved.
//
//  This RecordedAudio class contains info of the audio file
//      the location (path) of the file
//      the title of the audio file

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!

    init(filePathUrl: NSURL, title: String ) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
