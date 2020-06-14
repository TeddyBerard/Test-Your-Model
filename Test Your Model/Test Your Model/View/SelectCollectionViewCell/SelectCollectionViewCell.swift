//
//  SelectCollectionViewCell.swift
//  Test Your Model
//
//  Created by Teddy Bérard on 03/01/2020.
//  Copyright © 2020 Teddy Bérard. All rights reserved.
//

import UIKit

class SelectCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!

    // MARK: - Cycle life
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        typeImageView.image = nil
        typeLabel.text = nil
        
        
        roundedView.layer.cornerRadius = 16
        roundedView.clipsToBounds = true
        
    }
    
    /// Setup cell with the model type name and image
    /// - Parameters:
    ///   - typeName: model type name
    ///   - typeImage: model type image
    func setupCell(typeName: String, typeImage: UIImage) {
        typeLabel.text = typeName
        typeImageView.image = typeImage
        typeImageView.tintColor = .black
    }

}
