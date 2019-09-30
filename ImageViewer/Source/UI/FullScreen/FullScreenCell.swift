//
//  FullScreenImageItem.swift
//  ImageViewer
//
//  Created by Valerii Kotsulym on 9/25/19.
//  Copyright © 2019 Valerii Kotsulym. All rights reserved.
//

import Foundation
import UIKit

class FullScreenCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func bind(itemViewModel: FullScreenItemViewModel) {
        imageView.image = nil
        itemViewModel.getImage(action: { [weak self] image in
            self?.imageView.image = image
        })
    }
    
}
