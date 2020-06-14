//
//  TypeModels.swift
//  Test Your Model
//
//  Created by Teddy Bérard on 03/01/2020.
//  Copyright © 2020 Teddy Bérard. All rights reserved.
//

import Foundation
import UIKit

class TypeModels {
    
    // MARK: - Properties
    
    let name: String
    let image: UIImage
    let type: TypeDetection
    
    // MARK: - Initialization
    
    init(name: String, image: UIImage, type: TypeDetection) {
        self.name = name
        self.image = image
        self.type = type
    }
}

enum TypeDetection {
    case Sound
    case Object
    case Image
}
