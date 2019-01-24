//
//  UIImage+Compress.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/24.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit


extension UIImage {
    
    func compressImageScale(to size: CGSize) -> Data? {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage?.jpegData(compressionQuality: 0.8)
    }
    
    
}
