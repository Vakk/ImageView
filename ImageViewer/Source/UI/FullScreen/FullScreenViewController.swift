//
//  FullScreenViewController.swift
//  ImageViewer
//
//  Created by Valerii Kotsulym on 9/25/19.
//  Copyright © 2019 Valerii Kotsulym. All rights reserved.
//

import Foundation
import UIKit
import Pods_ImageViewer

class FullScreenViewController: UIViewController {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    lazy var viewModel = { FullScreenViewModel() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        bindViewModel()
    }
    
    private func initCollectionView() {
        imagesCollectionView.register(UINib(nibName: "FullScreenCell", bundle: nil), forCellWithReuseIdentifier: "FullScreenCell")
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
    }
    
}

extension FullScreenViewController: ViewModelBindable {
    func bindViewModel() {
        viewModel.fetchImage() { [weak self] image in
            guard let `self` = self else { return }
            self.imagesCollectionView.reloadData()
        }
    }
}

extension FullScreenViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let collectionViewFrame = imagesCollectionView.frame
         return CGSize(width: collectionViewFrame.width, height: collectionViewFrame.height)
     }

}

extension FullScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullScreenCell", for: indexPath) as! FullScreenCell
        cell.bind(itemViewModel: viewModel.images[indexPath.row])
        return cell
    }
    
    
}

class ImageItem {
    private var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
}
