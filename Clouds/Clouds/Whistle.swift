//
//  Whistle.swift
//  Clouds
//
//  Created by jhampac on 2/25/16.
//  Copyright © 2016 jhampac. All rights reserved.
//

import UIKit
import CloudKit

class Whistle: NSObject
{
    var recordID: CKRecordID!
    var genre: String!
    var comments: String!
    var audio: NSURL!
}
