//
//  ObjectDetectorViewController.swift
//  Test Your Model
//
//  Created by Teddy Bérard on 16/12/2019.
//  Copyright © 2019 Teddy Bérard. All rights reserved.
//

import UIKit

class ObjectDetectorViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var detectImageView: UIImageView!
    @IBOutlet weak var detectedObjectTableView: UITableView!
    var imagePicker: ImagePicker!
    
    /// Update with your model name
    static let modelName: String = "Miniature"
    
    let imageDetector: ImageDetector = ImageDetector()
    var result: [PhotoObjectDetection] = []

    // MARK: - Cycle life

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    // MARK: - @IBAction
    
    @IBAction func selectAction(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }

    @IBAction func detectAction(_ sender: Any) {        
        guard let image = detectImageView.image,
            let cgOrientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)),
        let cgImage =  image.cgImage else { return }
        
        imageDetector.searchObject(in: cgImage, with: cgOrientation) { result in

            DispatchQueue.main.async {
                self.result = result ?? []
                self.detectedObjectTableView.reloadData()
            }
            
        }
    }
    
}

extension ObjectDetectorViewController: UITableViewDelegate, UITableViewDataSource {

    private func setupTableView() {
        detectedObjectTableView.register(UINib.init(nibName: "DetectedObjectTableViewCell", bundle: nil), forCellReuseIdentifier: "detectedCell")
        detectedObjectTableView.separatorStyle = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = detectedObjectTableView.dequeueReusableCell(withIdentifier: "detectedCell", for: indexPath) as?
            DetectedObjectTableViewCell else { return UITableViewCell() }
        
        cell.setupLabel(object: result[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

extension ObjectDetectorViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        detectImageView.image = image
    }
    
    
}

