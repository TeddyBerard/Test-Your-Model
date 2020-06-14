//
//  DetectedObjectTableViewCell.swift
//  Test Your Model
//
//  Created by Teddy Bérard on 07/01/2020.
//  Copyright © 2020 Teddy Bérard. All rights reserved.
//

import UIKit

class DetectedObjectTableViewCell: UITableViewCell {
    
    // MARK: - Properties

    @IBOutlet weak var objectNameLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var roundedView: UIView!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        objectNameLabel.text = nil
        confidenceLabel.text = nil
        
        roundedView.layer.cornerRadius = 16
        roundedView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLabel(object: PhotoObjectDetection) {
        objectNameLabel.text = object.name
        confidenceLabel.text = String(format: "%.1f", object.percentConfidence)
    }

    
}
