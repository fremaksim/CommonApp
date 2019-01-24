//
//  UIImage+Crop.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/24.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit

extension UIImage {
    
    func projectedSizeForImage(_ image: CGRect, bounds: CGSize) -> CGSize {
        let aspectRatio = image.size.width/image.size.height
        var projectedWidth = bounds.width
        var projectedHeight = projectedWidth/aspectRatio
        if projectedHeight > bounds.height {
            projectedHeight = bounds.height
            projectedWidth = projectedHeight * aspectRatio
        }
        return CGSize(width: projectedWidth, height: projectedHeight)
    }
    
    
    
}
