//
//  FullScreenViewModel.swift
//  ImageViewer
//
//  Created by Valerii Kotsulym on 9/25/19.
//  Copyright © 2019 Valerii Kotsulym. All rights reserved.
//

import Foundation
import UIKit

class FullScreenViewModel {
    private var imageUrls = Array(arrayLiteral:
        "https://tinypng.com/images/social/website.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/0/0f/Grosser_Panda.JPG",
        "https://douglascuddletoy.com/wp-content/uploads/2019/04/308-Emmett.jpg",
        "https://images-na.ssl-images-amazon.com/images/I/61hSQqE3THL._SL1500_.jpg",
        "https://ichef.bbci.co.uk/news/660/cpsprodpb/4FA0/production/_108848302_a0d15811-30d8-4a51-8dd3-ab45f3dbc387.jpg"
    )
    var images = [FullScreenItemViewModel]()
    
    func fetchImage(result:  @escaping ([FullScreenItemViewModel]) -> ()) -> Void {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            var resultItems = [FullScreenItemViewModel]()
            resultItems.append(contentsOf: self.imageUrls.map { FullScreenItemViewModel(imageUrl: $0) })
            self.images = resultItems
            DispatchQueue.main.async(execute: {
                result(resultItems)
            })
        }
    }
    
}
