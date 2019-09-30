//
//  FullScreenItemViewModel.swift
//  ImageViewer
//
//  Created by Valerii Kotsulym on 9/26/19.
//  Copyright © 2019 Valerii Kotsulym. All rights reserved.
//

import Foundation
import UIKit

class FullScreenItemViewModel {
    private let imageUrl: String
    private var currentKey: String = ""
    private var cacheImage: UIImage? = nil
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    func loadImage(action: @escaping (UIImage) -> Void) {
        let key = UUID.init().uuidString
        currentKey = key
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let `self` = self else { return }
            if let image = self.getImage() {
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    if self.currentKey == key {
                        self.cacheImage = image
                        action(image)
                    }
                }
            }
        }
    }
    
    private func getImage() -> UIImage? {
        if let cacheImage = cacheImage {
            return cacheImage
        } else if let url = URL(string: imageUrl),
            let data = try? Data(contentsOf : url) {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}
