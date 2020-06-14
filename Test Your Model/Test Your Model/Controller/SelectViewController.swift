//
//  SelectViewController.swift
//  Test Your Model
//
//  Created by Teddy Bérard on 03/01/2020.
//  Copyright © 2020 Teddy Bérard. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var selectCollectionView: UICollectionView!
    
    private let types: [TypeModels] = [TypeModels(name: "Object Detector", image: UIImage(systemName: "viewfinder.circle")!, type: .Object)]
    
    // MARK: - Cycle life

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        selectCollectionView.delegate = self
        selectCollectionView.dataSource = self
        selectCollectionView.alwaysBounceVertical = true
        selectCollectionView.register(UINib.init(nibName: "SelectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "selectCell")

    }
    
    // MARK: - @IBAction
    
}

// MARK: - Extension : UICollectionViewDataSource && UICollectionViewDelegate

extension SelectViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectCell", for: indexPath) as?
            SelectCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setupCell(typeName: types[indexPath.row].name, typeImage: types[indexPath.row].image)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        switch types[indexPath.row].type {
        case .Image:
            break
        case .Object:
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ObjectDetectorViewController") as! UITabBarController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        case .Sound:
            break
        }
    }
}

// MARK: - Extension : UICollectionViewDelegateFlowLayout


extension SelectViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (collectionView.bounds.width/2.0) - 40
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }
    
    
    
}
