//
//  PhotoObjectDetection.swift
//  Test Your Model
//
//  Created by Teddy Bérard on 07/01/2020.
//  Copyright © 2020 Teddy Bérard. All rights reserved.
//

import Foundation
import Vision

class PhotoObjectDetection {
    
    var name: String
    var confidence: VNConfidence
    var percentConfidence: Float
    
    init(name: String, confidence: VNConfidence) {
        self.name = name
        self.confidence = confidence
        self.percentConfidence = confidence * 100
    }
    
}
